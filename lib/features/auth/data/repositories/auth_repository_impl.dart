import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_roles.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Stream<AuthState> get authStateChanges;
  User? get currentAuthUser;

  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String fullName,
    required AppRole role,
    String? phoneNumber,
    String? businessName,
    String? province,
    String? city,
  });

  Future<UserEntity?> fetchUserProfile(String userId);

  Future<void> signOut();

  Future<void> sendPasswordReset(String email);

  // Dynamic Super Admin Settings & Controls
  Future<Map<String, dynamic>> fetchSystemConfig();
  Future<void> updateSystemConfig(Map<String, dynamic> config);

  // Dynamic Categories Management
  Future<List<Map<String, dynamic>>> fetchCategories();
  Future<void> toggleCategory({required String id, required bool isActive});
  Future<void> createCategory(Map<String, dynamic> category);
  Future<void> deleteCategory(String id);

  // User Moderation Controls
  Future<List<UserEntity>> fetchAllUsers();
  Future<void> updateUserStatus({required String userId, required String status});
  Future<void> deleteUserAccount(String userId);
}

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient? _customClient;

  AuthRepositoryImpl({SupabaseClient? client}) : _customClient = client;

  SupabaseClient? get _supabase {
    if (_customClient != null) return _customClient;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<AuthState> get authStateChanges {
    final client = _supabase;
    if (client != null) {
      return client.auth.onAuthStateChange;
    }
    return const Stream<AuthState>.empty();
  }

  @override
  User? get currentAuthUser => _supabase?.auth.currentUser;

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final client = _supabase;
    if (client == null) {
      return UserEntity(
        id: 'mock-user-1',
        email: email.trim(),
        fullName: 'Aarav Sharma (आरव शर्मा)',
        role: AppRole.customer,
        status: 'active',
        createdAt: DateTime.now(),
      );
    }

    try {
      final AuthResponse response = await client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException('प्रयोगकर्ता फेला परेन (User not found)');
      }

      final profile = await fetchUserProfile(user.id);
      if (profile != null) {
        // Enforce moderation state
        if (profile.status == 'suspended' || profile.status == 'blocked') {
          await client.auth.signOut();
          throw AuthException(
            profile.status == 'blocked'
                ? 'तपाईंको खाता स्थायी रूपमा रोकिएको छ (Account Blocked by Super Admin)'
                : 'तपाईंको खाता अस्थायी रूपमा निलम्बित गरिएको छ (Account Suspended)',
          );
        }
        return profile;
      }

      return UserEntity(
        id: user.id,
        email: user.email ?? email,
        fullName: user.userMetadata?['full_name'] as String? ?? 'Easy App User',
        role: AppRole.fromString(user.userMetadata?['role'] as String?),
        status: 'active',
        createdAt: DateTime.now(),
      );
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      throw Exception('लगइन प्रक्रियामा त्रुटि: $e');
    }
  }

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String fullName,
    required AppRole role,
    String? phoneNumber,
    String? businessName,
    String? province,
    String? city,
  }) async {
    final client = _supabase;
    if (client == null) {
      return UserEntity(
        id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
        email: email.trim(),
        fullName: fullName.trim(),
        role: role,
        status: role == AppRole.businessOwner ? 'pending' : 'active',
        createdAt: DateTime.now(),
      );
    }

    try {
      final AuthResponse response = await client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'full_name': fullName.trim(),
          'role': role.value,
          'phone_number': phoneNumber?.trim(),
          'business_name': businessName?.trim(),
          'province': province,
          'city': city,
        },
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException('दर्ता प्रक्रिया सफल भएन (Signup failed)');
      }

      final profilePayload = {
        'id': user.id,
        'email': user.email ?? email.trim(),
        'full_name': fullName.trim(),
        'role': role.value,
        'status': role == AppRole.businessOwner ? 'pending' : 'active',
        'phone_number': phoneNumber?.trim(),
        'business_name': businessName?.trim(),
        'province': province,
        'city': city,
        'is_phone_verified': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      await client.from('profiles').upsert(profilePayload);

      return UserModel.fromJson(profilePayload);
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      throw Exception('दर्ता गर्दा समस्या: $e');
    }
  }

  @override
  Future<UserEntity?> fetchUserProfile(String userId) async {
    final client = _supabase;
    if (client == null) return null;
    try {
      final data = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data == null) return null;
      return UserModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    final client = _supabase;
    if (client == null) return;
    try {
      await client.auth.signOut();
    } catch (e) {
      throw Exception('लगआउट त्रुटि: $e');
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    final client = _supabase;
    if (client == null) return;
    try {
      await client.auth.resetPasswordForEmail(email.trim());
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> fetchSystemConfig() async {
    final client = _supabase;
    if (client != null) {
      try {
        final data = await client
            .from('system_settings')
            .select('value')
            .eq('key', 'app_config')
            .maybeSingle();

        if (data != null && data['value'] is Map) {
          return Map<String, dynamic>.from(data['value'] as Map);
        }
      } catch (_) {}
    }

    return {
      'app_title': 'Easy App',
      'app_title_np': 'इजी एप',
      'owner_company': 'Republic Nepal TV & Advertising Pvt. Ltd.',
      'tagline': 'All Digital Services & Media in One Place',
    };
  }

  @override
  Future<void> updateSystemConfig(Map<String, dynamic> config) async {
    final client = _supabase;
    if (client == null) return;
    await client.from('system_settings').upsert({
      'key': 'app_config',
      'value': config,
      'updated_at': DateTime.now().toIso8601String(),
      'updated_by': client.auth.currentUser?.id,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final client = _supabase;
    if (client == null) return [];
    try {
      final response = await client
          .from('categories')
          .select()
          .order('sort_order', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> toggleCategory({required String id, required bool isActive}) async {
    final client = _supabase;
    if (client == null) return;
    await client.from('categories').update({
      'is_active': isActive,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  @override
  Future<void> createCategory(Map<String, dynamic> category) async {
    final client = _supabase;
    if (client == null) return;
    await client.from('categories').insert(category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    final client = _supabase;
    if (client == null) return;
    await client.from('categories').delete().eq('id', id);
  }

  @override
  Future<List<UserEntity>> fetchAllUsers() async {
    final client = _supabase;
    if (client == null) return [];
    try {
      final response = await client
          .from('profiles')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((row) => UserModel.fromJson(row as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updateUserStatus({required String userId, required String status}) async {
    final client = _supabase;
    if (client == null) return;
    await client.from('profiles').update({
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  @override
  Future<void> deleteUserAccount(String userId) async {
    final client = _supabase;
    if (client == null) return;
    await client.from('profiles').delete().eq('id', userId);
  }

  AuthException _mapAuthException(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials')) {
      return const AuthException('इमेल वा पासवर्ड मिलेन (Invalid credentials)');
    }
    if (msg.contains('user already registered')) {
      return const AuthException('यो इमेल पहिले नै दर्ता भइसकेको छ (Email already registered)');
    }
    if (msg.contains('password should be at least')) {
      return const AuthException('पासवर्ड कम्तिमा ६ अक्षरको हुनुपर्छ (Password must be 6+ chars)');
    }
    return e;
  }
}

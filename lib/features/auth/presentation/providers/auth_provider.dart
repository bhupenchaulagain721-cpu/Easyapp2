import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_roles.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(client: client);
});

final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

/// Dynamic App Configuration Provider (App Title, Tagline, Owner metadata)
final systemConfigProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return await repo.fetchSystemConfig();
});

/// Dynamic Categories & Service Segments Provider
final categoriesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return await repo.fetchCategories();
});

/// State representation of the Auth Flow
class AuthStateModel {
  final bool isLoading;
  final UserEntity? user;
  final String? errorMessage;
  final bool isInitialCheckDone;
  final String dynamicAppTitle;
  final String ownerCompany;

  const AuthStateModel({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.isInitialCheckDone = false,
    this.dynamicAppTitle = 'Easy App',
    this.ownerCompany = 'Republic Nepal TV & Advertising Pvt. Ltd.',
  });

  bool get isAuthenticated => user != null;
  AppRole get role => user?.role ?? AppRole.customer;

  AuthStateModel copyWith({
    bool? isLoading,
    UserEntity? user,
    String? errorMessage,
    bool? isInitialCheckDone,
    String? dynamicAppTitle,
    String? ownerCompany,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthStateModel(
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isInitialCheckDone: isInitialCheckDone ?? this.isInitialCheckDone,
      dynamicAppTitle: dynamicAppTitle ?? this.dynamicAppTitle,
      ownerCompany: ownerCompany ?? this.ownerCompany,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthStateModel> {
  final AuthRepository _repository;
  StreamSubscription<AuthState>? _authSubscription;

  AuthNotifier(this._repository) : super(const AuthStateModel()) {
    _init();
  }

  void _init() async {
    // 1. Load dynamic system settings (App Title: Easy App, Owner Company)
    try {
      final config = await _repository.fetchSystemConfig();
      state = state.copyWith(
        dynamicAppTitle: config['app_title'] as String? ?? 'Easy App',
        ownerCompany: config['owner_company'] as String? ??
            'Republic Nepal TV & Advertising Pvt. Ltd.',
      );
    } catch (_) {}

    // 2. Initial check of current session
    final currentSupabaseUser = _repository.currentAuthUser;
    if (currentSupabaseUser != null) {
      _loadProfile(currentSupabaseUser.id);
    } else {
      state = state.copyWith(isInitialCheckDone: true);
    }

    // 3. Listen to remote auth state
    _authSubscription = _repository.authStateChanges.listen((event) async {
      final sessionUser = event.session?.user;
      if (sessionUser == null) {
        state = state.copyWith(
          user: null,
          clearUser: true,
          isLoading: false,
          isInitialCheckDone: true,
        );
      } else {
        await _loadProfile(sessionUser.id);
      }
    });
  }

  Future<void> _loadProfile(String userId) async {
    try {
      final profile = await _repository.fetchUserProfile(userId);
      state = state.copyWith(
        user: profile,
        isLoading: false,
        isInitialCheckDone: true,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isInitialCheckDone: true,
      );
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.signInWithEmail(
        email: email,
        password: password,
      );
      state = state.copyWith(
        isLoading: false,
        user: user,
        clearError: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required AppRole role,
    String? phoneNumber,
    String? businessName,
    String? province,
    String? city,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
        phoneNumber: phoneNumber,
        businessName: businessName,
        province: province,
        city: city,
      );
      state = state.copyWith(
        isLoading: false,
        user: user,
        clearError: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.signOut();
      state = state.copyWith(
        clearUser: true,
        isLoading: false,
        isInitialCheckDone: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Super Admin: Update Dynamic App Title & Config
  Future<void> updateAppTitle(String newTitle) async {
    final currentConfig = await _repository.fetchSystemConfig();
    currentConfig['app_title'] = newTitle;
    await _repository.updateSystemConfig(currentConfig);
    state = state.copyWith(dynamicAppTitle: newTitle);
  }

  // Super Admin: Moderate user
  Future<void> moderateUserStatus(String userId, String status) async {
    await _repository.updateUserStatus(userId: userId, status: status);
  }

  // Super Admin: Toggle service category
  Future<void> toggleCategory(String catId, bool isActive) async {
    await _repository.toggleCategory(id: catId, isActive: isActive);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthStateModel>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

final currentRoleProvider = Provider<AppRole>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.role;
});

final dynamicTitleProvider = Provider<String>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.dynamicAppTitle;
});

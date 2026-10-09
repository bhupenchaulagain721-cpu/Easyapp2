import '../../../../core/constants/app_roles.dart';

/// Pure domain entity representing an authenticated user profile in Easy App.
class UserEntity {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final AppRole role;
  final String status; // 'active', 'pending', 'suspended', 'blocked'
  final String? avatarUrl;
  final bool isPhoneVerified;
  final String? businessName;
  final String? province;
  final String? city;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    required this.role,
    this.status = 'active',
    this.avatarUrl,
    this.isPhoneVerified = false,
    this.businessName,
    this.province,
    this.city,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';
  bool get isSuspended => status == 'suspended';
  bool get isBlocked => status == 'blocked';

  bool get canAccessBusinessPortal =>
      (role == AppRole.superAdmin || role == AppRole.businessOwner || role == AppRole.staff) &&
      isActive;

  bool get isSuperAdmin => role == AppRole.superAdmin && isActive;

  UserEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    AppRole? role,
    String? status,
    String? avatarUrl,
    bool? isPhoneVerified,
    String? businessName,
    String? province,
    String? city,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      businessName: businessName ?? this.businessName,
      province: province ?? this.province,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          role == other.role &&
          status == other.status;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ role.hashCode ^ status.hashCode;
}

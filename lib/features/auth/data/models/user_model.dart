import '../../../../core/constants/app_roles.dart';
import '../../domain/entities/user_entity.dart';

/// Data transfer model mapping directly to Supabase public.profiles table.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.phoneNumber,
    required super.role,
    super.status = 'active',
    super.avatarUrl,
    super.isPhoneVerified = false,
    super.businessName,
    super.province,
    super.city,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      fullName: (json['full_name'] as String?)?.trim() ?? 'Nepali Citizen',
      phoneNumber: json['phone_number'] as String?,
      role: AppRole.fromString(json['role'] as String?),
      status: json['status'] as String? ?? 'active',
      avatarUrl: json['avatar_url'] as String?,
      isPhoneVerified: json['is_phone_verified'] as bool? ?? false,
      businessName: json['business_name'] as String?,
      province: json['province'] as String?,
      city: json['city'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'role': role.value,
      'status': status,
      'avatar_url': avatarUrl,
      'is_phone_verified': isPhoneVerified,
      'business_name': businessName,
      'province': province,
      'city': city,
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      role: entity.role,
      status: entity.status,
      avatarUrl: entity.avatarUrl,
      isPhoneVerified: entity.isPhoneVerified,
      businessName: entity.businessName,
      province: entity.province,
      city: entity.city,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

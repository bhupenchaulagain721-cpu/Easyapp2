/// Comprehensive RBAC & Multi-Tenant Role System for Easy App
/// Owned by: Republic Nepal TV & Advertising Pvt. Ltd.
///
/// Supported User Types and Roles:
/// - Platform Admins: [superAdmin], [platformAdmin], [supportAdmin]
/// - Business Tenants: [businessOwner], [businessAdmin], [branchManager], [departmentManager]
/// - Field & Operations: [staff], [deliveryPartner], [serviceProvider]
/// - Consumers & External: [customer], [guest], [partner]
enum AppRole {
  superAdmin('superAdmin'),
  platformAdmin('platformAdmin'),
  supportAdmin('supportAdmin'),
  businessOwner('businessOwner'),
  businessAdmin('businessAdmin'),
  branchManager('branchManager'),
  departmentManager('departmentManager'),
  staff('staff'),
  deliveryPartner('deliveryPartner'),
  serviceProvider('serviceProvider'),
  customer('customer'),
  guest('guest'),
  partner('partner');

  final String value;
  const AppRole(this.value);

  static AppRole fromString(String? roleStr) {
    if (roleStr == null) return AppRole.customer;
    return AppRole.values.firstWhere(
      (role) => role.value.toLowerCase() == roleStr.toLowerCase(),
      orElse: () => AppRole.customer,
    );
  }

  String get displayNameEn {
    switch (this) {
      case AppRole.superAdmin:
        return 'Super Administrator';
      case AppRole.platformAdmin:
        return 'Platform Administrator';
      case AppRole.supportAdmin:
        return 'Customer Support Admin';
      case AppRole.businessOwner:
        return 'Business Owner';
      case AppRole.businessAdmin:
        return 'Business Administrator';
      case AppRole.branchManager:
        return 'Branch Manager';
      case AppRole.departmentManager:
        return 'Department Manager';
      case AppRole.staff:
        return 'Operations Staff';
      case AppRole.deliveryPartner:
        return 'Delivery Partner';
      case AppRole.serviceProvider:
        return 'Service Provider / Clinic';
      case AppRole.customer:
        return 'Customer';
      case AppRole.guest:
        return 'Guest User';
      case AppRole.partner:
        return 'Strategic Media Partner';
    }
  }

  String get displayNameNp {
    switch (this) {
      case AppRole.superAdmin:
        return 'मुख्य प्रशासक (Super Admin)';
      case AppRole.platformAdmin:
        return 'प्लेटफर्म प्रशासक';
      case AppRole.supportAdmin:
        return 'सपोर्ट प्रशासक';
      case AppRole.businessOwner:
        return 'व्यवसाय मालिक (Merchant Owner)';
      case AppRole.businessAdmin:
        return 'व्यवसाय प्रबन्धक';
      case AppRole.branchManager:
        return 'शाखा प्रबन्धक (Branch Manager)';
      case AppRole.departmentManager:
        return 'विभाग प्रमुख';
      case AppRole.staff:
        return 'स्टोर तथा फिल्ड कर्मचारी';
      case AppRole.deliveryPartner:
        return 'डेलिभरी पार्टनर (राइडर)';
      case AppRole.serviceProvider:
        return 'सेवा प्रदायक (क्लिनिक / टेक्निसियन)';
      case AppRole.customer:
        return 'ग्राहक (Customer)';
      case AppRole.guest:
        return 'अतिथि प्रयोगकर्ता';
      case AppRole.partner:
        return 'मिडिया तथा व्यावसायिक साझेदार';
    }
  }

  String get defaultRoutePath {
    switch (this) {
      case AppRole.superAdmin:
      case AppRole.platformAdmin:
      case AppRole.supportAdmin:
        return '/admin-dashboard';
      case AppRole.businessOwner:
      case AppRole.businessAdmin:
      case AppRole.branchManager:
      case AppRole.departmentManager:
      case AppRole.staff:
        return '/business-dashboard';
      case AppRole.deliveryPartner:
      case AppRole.serviceProvider:
      case AppRole.customer:
      case AppRole.guest:
      case AppRole.partner:
        return '/customer-dashboard';
    }
  }

  bool get isPlatformAdmin =>
      this == AppRole.superAdmin ||
      this == AppRole.platformAdmin ||
      this == AppRole.supportAdmin;

  bool get isBusinessManager =>
      this == AppRole.businessOwner ||
      this == AppRole.businessAdmin ||
      this == AppRole.branchManager ||
      this == AppRole.departmentManager;
}

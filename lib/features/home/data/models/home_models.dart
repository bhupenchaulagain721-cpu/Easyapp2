import 'package:flutter/foundation.dart';

/// Model representing a Category from the `categories` table
class CategoryModel {
  final String id;
  final String name;
  final String nameNp;
  final String slug;
  final String segmentType;
  final String iconName;
  final int sortOrder;
  final bool isActive;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.nameNp,
    required this.slug,
    required this.segmentType,
    required this.iconName,
    required this.sortOrder,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      nameNp: json['name_np'] as String? ?? json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      segmentType: json['segment_type'] as String? ?? 'ecommerce',
      iconName: json['icon_name'] as String? ?? 'category',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

/// Model representing a Business from the `businesses` table
class BusinessModel {
  final String id;
  final String ownerId;
  final String name;
  final String? nameNp;
  final String categorySlug;
  final String phoneNumber;
  final String? email;
  final String province;
  final String city;
  final String address;
  final String status; // 'pending', 'approved', 'rejected', 'suspended'
  final String? panVatNumber;
  final String? logoUrl;

  const BusinessModel({
    required this.id,
    required this.ownerId,
    required this.name,
    this.nameNp,
    required this.categorySlug,
    required this.phoneNumber,
    this.email,
    required this.province,
    required this.city,
    required this.address,
    required this.status,
    this.panVatNumber,
    this.logoUrl,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id']?.toString() ?? '',
      ownerId: json['owner_id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      nameNp: json['name_np'] as String?,
      categorySlug: json['category_slug'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      email: json['email'] as String?,
      province: json['province'] as String? ?? 'Bagmati Province',
      city: json['city'] as String? ?? 'Kathmandu',
      address: json['address'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      panVatNumber: json['pan_vat_number'] as String?,
      logoUrl: json['logo_url'] as String?,
    );
  }
}

/// Model representing an Ad from the `ads` table (Republic Nepal TV Ads Engine)
class AdModel {
  final String id;
  final String title;
  final String? titleNp;
  final String imageUrl;
  final String? redirectUrl;
  final String sponsorName;
  final String placement; // 'home', 'home_banner', 'live_tv'
  final int priority;
  final String status; // 'pending', 'approved', 'rejected'
  final String? contactPhone;
  final bool isActive;

  const AdModel({
    required this.id,
    required this.title,
    this.titleNp,
    required this.imageUrl,
    this.redirectUrl,
    required this.sponsorName,
    this.placement = 'home',
    this.priority = 1,
    this.status = 'approved',
    this.contactPhone,
    this.isActive = true,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      titleNp: json['title_np'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
      redirectUrl: json['redirect_url'] as String?,
      sponsorName: json['sponsor_name'] as String? ?? 'Republic Nepal TV & Advertising Pvt. Ltd.',
      placement: json['placement'] as String? ?? 'home',
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      status: json['status'] as String? ?? 'approved',
      contactPhone: json['contact_phone'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

/// Model representing a Special Offer from the `offers` table
class OfferModel {
  final String id;
  final String? businessId;
  final String title;
  final String titleNp;
  final String? description;
  final int discountPercent;
  final String? couponCode;
  final DateTime? validUntil;
  final String status;
  final bool isActive;

  const OfferModel({
    required this.id,
    this.businessId,
    required this.title,
    required this.titleNp,
    this.description,
    required this.discountPercent,
    this.couponCode,
    this.validUntil,
    this.status = 'approved',
    required this.isActive,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id']?.toString() ?? '',
      businessId: json['business_id']?.toString(),
      title: json['title'] as String? ?? '',
      titleNp: json['title_np'] as String? ?? json['title'] as String? ?? '',
      description: json['description'] as String?,
      discountPercent: (json['discount_percent'] as num?)?.toInt() ?? 0,
      couponCode: json['coupon_code'] as String?,
      validUntil: json['valid_until'] != null ? DateTime.tryParse(json['valid_until'] as String) : null,
      status: json['status'] as String? ?? 'approved',
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

/// Model representing a Provincial Branch from the `branches` table
class BranchModel {
  final String id;
  final String name;
  final String nameNp;
  final String province;
  final String city;
  final String address;
  final String? phoneNumber;
  final String? email;
  final bool isActive;

  const BranchModel({
    required this.id,
    required this.name,
    required this.nameNp,
    required this.province,
    required this.city,
    required this.address,
    this.phoneNumber,
    this.email,
    required this.isActive,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      nameNp: json['name_np'] as String? ?? json['name'] as String? ?? '',
      province: json['province'] as String? ?? '',
      city: json['city'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

/// Model representing a Live Ticker / News Bulletin / Market Rate from the `ticker_items` table
/// Exact columns: kind IN ('news', 'notice', 'market_rate'), sort_order, message, message_np, rate_item, rate_value
class TickerItemModel {
  final String id;
  final String message;
  final String messageNp;
  final String kind; // 'news', 'notice', 'market_rate'
  final String? rateItem;
  final String? rateValue;
  final int sortOrder;
  final String? contactPhone;
  final bool isActive;

  String get category => kind;

  const TickerItemModel({
    required this.id,
    required this.message,
    required this.messageNp,
    this.kind = 'news',
    this.rateItem,
    this.rateValue,
    this.sortOrder = 0,
    this.contactPhone,
    required this.isActive,
  });

  factory TickerItemModel.fromJson(Map<String, dynamic> json) {
    return TickerItemModel(
      id: json['id']?.toString() ?? '',
      message: json['message'] as String? ?? '',
      messageNp: json['message_np'] as String? ?? json['message'] as String? ?? '',
      kind: json['kind'] as String? ?? json['category'] as String? ?? 'news',
      rateItem: json['rate_item'] as String?,
      rateValue: json['rate_value'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      contactPhone: json['contact_phone'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

/// Dynamic System Config Model from `system_settings.app_config`
class AppConfigModel {
  final String appTitle;
  final String appTitleNp;
  final String tvName;
  final String logoUrl;
  final String footerText;
  final String ownerCompany;
  final String supportPhone;

  const AppConfigModel({
    this.appTitle = 'Easy App',
    this.appTitleNp = 'इजी एप',
    this.tvName = 'RN TV',
    this.logoUrl = '',
    this.footerText = 'रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि',
    this.ownerCompany = 'Republic Nepal TV & Advertising Pvt. Ltd.',
    this.supportPhone = '+977-1-4112233',
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      appTitle: json['app_title'] as String? ?? 'Easy App',
      appTitleNp: json['app_title_np'] as String? ?? 'इजी एप',
      tvName: json['tv_name'] as String? ?? 'RN TV',
      logoUrl: json['logo_url'] as String? ?? '',
      footerText: json['footer_text'] as String? ?? 'रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि',
      ownerCompany: json['owner_company'] as String? ?? 'Republic Nepal TV & Advertising Pvt. Ltd.',
      supportPhone: json['support_phone'] as String? ?? '+977-1-4112233',
    );
  }
}

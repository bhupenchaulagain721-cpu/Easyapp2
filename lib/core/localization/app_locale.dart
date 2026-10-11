import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supported application languages for Nepal & Global market
enum AppLanguage {
  nepali('ne', 'नेपाली', 'NP'),
  english('en', 'English', 'EN');

  final String code;
  final String label;
  final String badge;

  const AppLanguage(this.code, this.label, this.badge);
}

/// Reactive StateNotifier for language switching
class LocaleNotifier extends StateNotifier<AppLanguage> {
  LocaleNotifier() : super(AppLanguage.nepali);

  void toggleLanguage() {
    state = state == AppLanguage.nepali ? AppLanguage.english : AppLanguage.nepali;
  }

  void setLanguage(AppLanguage language) {
    state = language;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, AppLanguage>((ref) {
  return LocaleNotifier();
});

/// Centralized localization dictionary for Phase 1 screens
class AppStrings {
  AppStrings._();

  static String of(AppLanguage lang, String key) {
    final isNp = lang == AppLanguage.nepali;
    return isNp ? (_nepali[key] ?? key) : (_english[key] ?? key);
  }

  static const Map<String, String> _nepali = {
    // Branding
    'appName': 'Easy App (इजि एप)',
    'companyName': 'Republic Nepal TV & Advertising Pvt. Ltd.',
    'companyNameNp': 'रिपब्लिक नेपाल टिभी एण्ड एडभरटाइजिङ प्रा. लि.',
    'poweredBy': 'Powered by',

    // Splash
    'splashTagline': 'नेपालको आधिकारिक सुपर एप · भुक्तानी, बजार, स्वास्थ्य, किराना तथा टिभी',
    'getStarted': 'सुरु गर्नुहोस्',

    // Auth common
    'loginTitle': 'नमस्ते! स्वागत छ',
    'loginSubtitle': 'आफ्नो खातामा लगइन गर्नुहोस्',
    'emailOrPhone': 'इमेल वा मोबाइल नम्बर',
    'password': 'गोप्य पासवर्ड',
    'signIn': 'लगइन गर्नुहोस्',
    'signingIn': 'प्रमाणीकरण हुँदैछ...',
    'dontHaveAccount': 'नयाँ खाता दर्ता गर्नुहोस्',
    'alreadyHaveAccount': 'पहिले नै खाता छ? लगइन गर्नुहोस्',
    'registerTitle': 'नयाँ खाता खोल्नुहोस्',
    'fullName': 'पूरा नाम',
    'phone': 'मोबाइल नम्बर (+977)',
    'email': 'इमेल ठेगाना',
    'selectRole': 'भूमिका (Account Role)',
    'customer': 'ग्राहक',
    'businessOwner': 'व्यापारी',
    'staff': 'कर्मचारी',
    'register': 'दर्ता गर्नुहोस्',

    // Home
    'home': 'गृहपृष्ठ',
    'walletTitle': 'Easy Wallet (सुपर वालेट)',
    'kycVerified': 'KYC Verified ✓',
    'scanPay': 'Scan Pay',
    'sendMoney': 'पठाउनुहोस्',
    'topUp': 'टप-अप',
    'electricity': 'बिजुली महसुल',
    'dynamicModules': 'सक्रिय सेवा मोड्युलहरू (Dynamic Modules)',
    'liveStream': 'Republic Nepal TV प्रत्यक्ष प्रसारण',
    'live': 'LIVE',
    'registerBusinessHero': 'पसल वा सेवा व्यवसाय छ? Easy App मा दर्ता गर्नुहोस्!',

    // Modules
    'modHealth': 'क्लिनिक तथा स्वास्थ्य',
    'modHealthSub': 'डाक्टर अपोइन्टमेन्ट, ओपिडी टोकन',
    'modFood': 'किराना तथा खाद्यान्न',
    'modFoodSub': 'दैनिक उपभोग्य ताजा सामग्री',
    'modClothing': 'कपडा तथा फेसन',
    'modClothingSub': 'ढाका टोपी, परम्परागत तथा आधुनिक',
    'modCosmetics': 'कस्मेटिक्स तथा सौन्दर्य',
    'modCosmeticsSub': 'हर्बल स्किनकेयर, प्राकृतिक उत्पादन',
    'modRealEstate': 'घरजग्गा खरिदबिक्री',
    'modRealEstateSub': 'जग्गा, घर, फ्ल्याट तथा भाडा',
    'modRecycle': 'पुनःप्रयोग तथा कवाडी',
    'modRecycleSub': 'इ-वेस्ट, पुराना सामान, रिसाइकल',
    'modLocalMarket': 'स्थानीय हाटबजार',
    'modLocalMarketSub': 'गाउँघरका उत्पादन तथा सेवा',
    'modUtilities': 'बिजुली तथा खानेपानी',
    'modUtilitiesSub': 'नेपाल विद्युत प्राधिकरण बिल',

    // Profile
    'profile': 'मेरो प्रोफाइल',
    'savedAddresses': 'सुरक्षित ठेगानाहरू',
    'ordersAndHistory': 'अपोइन्टमेन्ट तथा अर्डर विवरण',
    'favorites': 'मनपर्ने सेवा तथा पसल',
    'privacyNotice': 'डाटा सुरक्षा तथा गोपनीयता',
    'privacyDesc': 'नागरिकको डिजिटल सार्वभौमिकता रक्षा गर्न Easy App ले कारोबारका लागि आवश्यक सीमित डाटा मात्र संकलन गर्दछ।',
    'language': 'भाषा (Language)',
    'logout': 'खाताबाट बाहिरिनुहोस् (Log Out)',
  };

  static const Map<String, String> _english = {
    // Branding
    'appName': 'Easy App',
    'companyName': 'Republic Nepal TV & Advertising Pvt. Ltd.',
    'companyNameNp': 'Republic Nepal TV & Advertising Pvt. Ltd.',
    'poweredBy': 'Powered by',

    // Splash
    'splashTagline': "Nepal's Official Super App · Payments, Market, Health, Grocery & TV",
    'getStarted': 'Get Started',

    // Auth common
    'loginTitle': 'Welcome Back',
    'loginSubtitle': 'Sign in to access your dashboard',
    'emailOrPhone': 'Email or Mobile Number',
    'password': 'Password',
    'signIn': 'Sign In',
    'signingIn': 'Authenticating...',
    'dontHaveAccount': 'Create New Account',
    'alreadyHaveAccount': 'Already have an account? Sign In',
    'registerTitle': 'Create New Account',
    'fullName': 'Full Name',
    'phone': 'Mobile (+977)',
    'email': 'Email Address',
    'selectRole': 'Account Role',
    'customer': 'Customer',
    'businessOwner': 'Merchant',
    'staff': 'Staff',
    'register': 'Register',

    // Home
    'home': 'Home',
    'walletTitle': 'Easy Wallet',
    'kycVerified': 'KYC Verified ✓',
    'scanPay': 'Scan Pay',
    'sendMoney': 'Send',
    'topUp': 'Top-up',
    'electricity': 'Electricity',
    'dynamicModules': 'Active Dynamic Modules',
    'liveStream': 'Republic Nepal TV Live Satellite',
    'live': 'LIVE',
    'registerBusinessHero': 'Own a store or service? Register on Easy App today!',

    // Modules
    'modHealth': 'Clinic & Health',
    'modHealthSub': 'Doctor Appointments & OPD Tokens',
    'modFood': 'Kirana & Grocery',
    'modFoodSub': 'Daily essentials & fresh farm foods',
    'modClothing': 'Clothing & Fashion',
    'modClothingSub': 'Traditional wear & garments',
    'modCosmetics': 'Cosmetics & Beauty',
    'modCosmeticsSub': 'Herbal skincare & personal care',
    'modRealEstate': 'Real Estate',
    'modRealEstateSub': 'Land, houses & rentals in Nepal',
    'modRecycle': 'Reuse & Recycle',
    'modRecycleSub': 'Pre-owned goods, e-waste & scrap',
    'modLocalMarket': 'Local Haat Market',
    'modLocalMarketSub': 'Artisans & seasonal local farm produce',
    'modUtilities': 'Electricity & Water',
    'modUtilitiesSub': 'NEA bills & Khanepani counters',

    // Profile
    'profile': 'My Profile',
    'savedAddresses': 'Saved Addresses',
    'ordersAndHistory': 'Orders & Appointment History',
    'favorites': 'Saved Favorites',
    'privacyNotice': 'Privacy & Data Minimization',
    'privacyDesc': 'Easy App prioritizes minimal data collection strictly necessary for commerce & utility billing in Nepal.',
    'language': 'Language / भाषा',
    'logout': 'Sign Out',
  };
}

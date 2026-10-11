import pubspecCode from '../../pubspec.yaml?raw';
import mainDartCode from '../../lib/main.dart?raw';
import appRolesCode from '../../lib/core/constants/app_roles.dart?raw';
import appColorsCode from '../../lib/core/constants/app_colors.dart?raw';
import appThemeCode from '../../lib/core/theme/app_theme.dart?raw';
import companyFooterCode from '../../lib/core/widgets/company_footer.dart?raw';
import userEntityCode from '../../lib/features/auth/domain/entities/user_entity.dart?raw';
import userModelCode from '../../lib/features/auth/data/models/user_model.dart?raw';
import authRepoImplCode from '../../lib/features/auth/data/repositories/auth_repository_impl.dart?raw';
import authProviderCode from '../../lib/features/auth/presentation/providers/auth_provider.dart?raw';
import loginScreenCode from '../../lib/features/auth/presentation/screens/login_screen.dart?raw';
import registerScreenCode from '../../lib/features/auth/presentation/screens/register_screen.dart?raw';
import authGateCode from '../../lib/features/auth/presentation/screens/auth_gate.dart?raw';
import customerDashboardCode from '../../lib/features/dashboard/presentation/screens/customer_dashboard.dart?raw';
import businessDashboardCode from '../../lib/features/dashboard/presentation/screens/business_dashboard.dart?raw';
import adminDashboardCode from '../../lib/features/dashboard/presentation/screens/admin_dashboard.dart?raw';
import schemaSqlCode from '../../schema.sql?raw';
import codemagicYamlCode from '../../codemagic.yaml?raw';
import easyMusicScreenCode from '../../lib/features/music/presentation/screens/easy_music_screen.dart?raw';
import appLocaleCode from '../../lib/core/localization/app_locale.dart?raw';
import splashScreenCode from '../../lib/features/auth/presentation/screens/splash_screen.dart?raw';
import homeScreenCode from '../../lib/features/home/presentation/screens/home_screen.dart?raw';
import profileScreenCode from '../../lib/features/profile/presentation/screens/profile_screen.dart?raw';
import supabaseDataRepoCode from '../../lib/features/home/data/repositories/supabase_data_repository.dart?raw';
import homeModelsCode from '../../lib/features/home/data/models/home_models.dart?raw';
import androidAppBuildGradleCode from '../../android/app/build.gradle?raw';
import androidManifestCode from '../../android/app/src/main/AndroidManifest.xml?raw';
import androidSettingsGradleCode from '../../android/settings.gradle?raw';
import androidBuildGradleCode from '../../android/build.gradle?raw';

export interface FlutterFile {
  path: string;
  category: 'Configuration' | 'Core & Theme' | 'Domain Layer' | 'Data Layer' | 'Presentation' | 'Database / Supabase' | 'Android Native';
  description: string;
  language: 'dart' | 'yaml' | 'sql' | 'groovy' | 'xml';
  code: string;
}

export const FLUTTER_FILES: FlutterFile[] = [
  {
    path: 'pubspec.yaml',
    category: 'Configuration',
    description: 'Project manifest for easy_app with Supabase Flutter, Riverpod, GoRouter, Google Fonts, and Cupertino icons.',
    language: 'yaml',
    code: pubspecCode,
  },
  {
    path: 'lib/main.dart',
    category: 'Core & Theme',
    description: 'Supabase initialization, ProviderScope, dynamic title listener, and role-based GoRouter redirect guards.',
    language: 'dart',
    code: mainDartCode,
  },
  {
    path: 'lib/core/constants/app_roles.dart',
    category: 'Core & Theme',
    description: 'AppRole enum: superAdmin, businessOwner, staff, customer with localized titles and route dispatchers.',
    language: 'dart',
    code: appRolesCode,
  },
  {
    path: 'lib/core/constants/app_colors.dart',
    category: 'Core & Theme',
    description: 'Design tokens: Primary #0F3D3E, Accent #C79A3E, surfaces, and payment brand cues.',
    language: 'dart',
    code: appColorsCode,
  },
  {
    path: 'lib/core/theme/app_theme.dart',
    category: 'Core & Theme',
    description: 'ThemeData definitions for Light & Dark mode supporting Google Fonts Plus Jakarta Sans and Material 3.',
    language: 'dart',
    code: appThemeCode,
  },
  {
    path: 'lib/core/widgets/company_footer.dart',
    category: 'Core & Theme',
    description: 'Permanent footer branding: "Powered by Republic Nepal TV & Advertising Pvt. Ltd."',
    language: 'dart',
    code: companyFooterCode,
  },
  {
    path: 'lib/features/auth/domain/entities/user_entity.dart',
    category: 'Domain Layer',
    description: 'Pure domain entity representing user profile with role & moderation status (active, pending, suspended, blocked).',
    language: 'dart',
    code: userEntityCode,
  },
  {
    path: 'lib/features/auth/data/models/user_model.dart',
    category: 'Data Layer',
    description: 'Data Transfer Model for public.profiles with JSON serializers/deserializers.',
    language: 'dart',
    code: userModelCode,
  },
  {
    path: 'lib/features/auth/data/repositories/auth_repository_impl.dart',
    category: 'Data Layer',
    description: 'Repository handling Supabase Auth, dynamic system settings, categories management, and user moderation.',
    language: 'dart',
    code: authRepoImplCode,
  },
  {
    path: 'lib/features/auth/presentation/providers/auth_provider.dart',
    category: 'Presentation',
    description: 'Riverpod AuthNotifier, dynamic app title listener, categories provider, and RBAC actions.',
    language: 'dart',
    code: authProviderCode,
  },
  {
    path: 'lib/features/auth/presentation/screens/login_screen.dart',
    category: 'Presentation',
    description: 'Login screen with dynamic "Easy App" title, credentials validation, and Republic TV company footer.',
    language: 'dart',
    code: loginScreenCode,
  },
  {
    path: 'lib/features/auth/presentation/screens/register_screen.dart',
    category: 'Presentation',
    description: 'Registration screen with role selector, Nepal phone (+977), 7 Provinces, and company footer.',
    language: 'dart',
    code: registerScreenCode,
  },
  {
    path: 'lib/features/auth/presentation/screens/auth_gate.dart',
    category: 'Presentation',
    description: 'Dynamic reactive routing gate dispatching users to role-specific dashboards with branded splash.',
    language: 'dart',
    code: authGateCode,
  },
  {
    path: 'lib/features/dashboard/presentation/screens/customer_dashboard.dart',
    category: 'Presentation',
    description: 'Customer portal: Republic Nepal TV live media stream, Easy Wallet (NPR), dynamic services grid, and footer.',
    language: 'dart',
    code: customerDashboardCode,
  },
  {
    path: 'lib/features/dashboard/presentation/screens/business_dashboard.dart',
    category: 'Presentation',
    description: 'Merchant & Staff workspace: POS sales, order fulfillment queue, scoped permissions, and company footer.',
    language: 'dart',
    code: businessDashboardCode,
  },
  {
    path: 'lib/features/dashboard/presentation/screens/admin_dashboard.dart',
    category: 'Presentation',
    description: 'Super Admin Control Center: Dynamic App Title & Config, Categories & Segments toggle, and User Moderation.',
    language: 'dart',
    code: adminDashboardCode,
  },
  {
    path: 'schema.sql',
    category: 'Database / Supabase',
    description: 'Complete Supabase PostgreSQL DDL: profiles, system_settings, categories tables, triggers, and comprehensive RLS.',
    language: 'sql',
    code: schemaSqlCode,
  },
  {
    path: 'codemagic.yaml',
    category: 'Configuration',
    description: 'Codemagic CI/CD build configuration to automatically build production Android APK and App Bundle with Supabase credentials.',
    language: 'yaml',
    code: codemagicYamlCode,
  },
  {
    path: 'lib/features/music/presentation/screens/easy_music_screen.dart',
    category: 'Presentation',
    description: 'Easy Music & Radio Player (कोड म्युजिक): Nepali hits, Republic Nepal TV Live stream audio, background playback with just_audio.',
    language: 'dart',
    code: easyMusicScreenCode,
  },
  {
    path: 'lib/core/localization/app_locale.dart',
    category: 'Core & Theme',
    description: 'Bilingual Nepali & English localization dictionary and reactive locale StateNotifier for Phase 1.',
    language: 'dart',
    code: appLocaleCode,
  },
  {
    path: 'lib/features/auth/presentation/screens/splash_screen.dart',
    category: 'Presentation',
    description: 'Phase 1 Splash Screen: Dynamic app title, Nepali branding, language switcher, and auto-session check.',
    language: 'dart',
    code: splashScreenCode,
  },
  {
    path: 'lib/features/home/presentation/screens/home_screen.dart',
    category: 'Presentation',
    description: 'Phase 1 Home Screen: Module Grid (Clinic, Kirana, Clothing, Cosmetics, Real Estate, Recycle, Local Market, Utilities) and Digital Wallet.',
    language: 'dart',
    code: homeScreenCode,
  },
  {
    path: 'lib/features/profile/presentation/screens/profile_screen.dart',
    category: 'Presentation',
    description: 'Phase 1 Customer Profile: KYC status, saved addresses, orders history, data minimization notice, and language switcher.',
    language: 'dart',
    code: profileScreenCode,
  },
  {
    path: 'lib/features/home/data/models/home_models.dart',
    category: 'Domain Layer',
    description: 'Data models for categories, businesses, ads, offers, branches, and ticker_items matching schema.sql.',
    language: 'dart',
    code: homeModelsCode,
  },
  {
    path: 'lib/features/home/data/repositories/supabase_data_repository.dart',
    category: 'Data Layer',
    description: 'Comprehensive Supabase data repository querying profiles, businesses, categories, ads, offers, branches, ticker_items, and system_settings.',
    language: 'dart',
    code: supabaseDataRepoCode,
  },
  {
    path: 'android/app/build.gradle',
    category: 'Android Native',
    description: 'Android App Build Configuration with applicationId com.republicnepal.easyapp, targetSdk 34, minSdk 21.',
    language: 'groovy',
    code: androidAppBuildGradleCode,
  },
  {
    path: 'android/app/src/main/AndroidManifest.xml',
    category: 'Android Native',
    description: 'Android Manifest with package com.republicnepal.easyapp, Internet permissions, and FlutterActivity declaration.',
    language: 'xml',
    code: androidManifestCode,
  },
  {
    path: 'android/settings.gradle',
    category: 'Android Native',
    description: 'Gradle settings and Flutter tool plugin management for Android build.',
    language: 'groovy',
    code: androidSettingsGradleCode,
  },
  {
    path: 'android/build.gradle',
    category: 'Android Native',
    description: 'Top-level root Android Gradle configuration with Google and MavenCentral repositories.',
    language: 'groovy',
    code: androidBuildGradleCode,
  },
];

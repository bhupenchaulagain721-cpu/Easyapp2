import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/widgets/company_footer.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import '../../../dashboard/presentation/screens/customer_dashboard.dart';
import '../../../dashboard/presentation/screens/business_dashboard.dart';
import '../../../dashboard/presentation/screens/admin_dashboard.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    // Initial session restoration
    if (!authState.isInitialCheckDone) {
      return _BrandedSplashScreen(
        appTitle: authState.dynamicAppTitle,
      );
    }

    // Unauthenticated state
    if (!authState.isAuthenticated || authState.user == null) {
      return const LoginScreen();
    }

    final user = authState.user!;

    // Account Moderation Intercept
    if (user.status == 'suspended' || user.status == 'blocked') {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.block_rounded, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Text(
                  user.status == 'blocked'
                      ? 'खाता स्थायी रूपमा रोकिएको छ (Account Blocked)'
                      : 'खाता अस्थायी रूपमा निलम्बित (Account Suspended)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'कृपया Republic Nepal TV प्रशासनसँग सम्पर्क गर्नुहोस्।',
                  style: TextStyle(color: AppColors.lightTextSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
                  child: const Text('लगइन पृष्ठमा फर्कनुहोस् (Back to Login)'),
                ),
                const SizedBox(height: 32),
                const CompanyFooter(),
              ],
            ),
          ),
        ),
      );
    }

    // Role-based multi-dashboard dispatch
    switch (user.role) {
      case AppRole.superAdmin:
        return const AdminDashboard();
      case AppRole.businessOwner:
      case AppRole.staff:
        return const BusinessDashboard();
      case AppRole.customer:
        return const CustomerDashboard();
    }
  }
}

class _BrandedSplashScreen extends StatelessWidget {
  final String appTitle;

  const _BrandedSplashScreen({required this.appTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.accent, width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.bolt_rounded,
                        color: AppColors.accent,
                        size: 52,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    appTitle.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'एकै ठाउँमा सबै डिजिटल सेवाहरू तथा प्रत्यक्ष मिडिया',
                    style: TextStyle(
                      color: AppColors.accentLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 36),
                  const SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const CompanyFooter(isDark: true),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

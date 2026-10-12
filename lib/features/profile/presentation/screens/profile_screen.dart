import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/widgets/company_footer.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Phase 1 Profile Management Screen
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final userName = user?.fullName ?? 'Aarav Sharma (आरव शर्मा)';
    final userEmail = user?.email ?? 'aarav.sharma@nepal.np';
    final userPhone = user?.phoneNumber ?? '+977 9841234567';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          AppStrings.of(lang, 'profile'),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          // Language Switcher
          TextButton(
            onPressed: () {
              ref.read(localeProvider.notifier).toggleLanguage();
            },
            child: Row(
              children: [
                const Icon(Icons.language_rounded, color: AppColors.accent, size: 16),
                const SizedBox(width: 4),
                Text(
                  lang.badge,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.accent, width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          'AS',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'KYC ✓',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userEmail,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontFamily: 'monospace'),
                          ),
                          Text(
                            userPhone,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Data Minimization Notice
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security_rounded, color: Colors.green.shade800, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.of(lang, 'privacyNotice'),
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.of(lang, 'privacyDesc'),
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Saved Addresses
              _ProfileSectionCard(
                title: AppStrings.of(lang, 'savedAddresses'),
                icon: Icons.location_on_rounded,
                children: const [
                  _ProfileItemTile(
                    title: 'Home (घर)',
                    subtitle: 'New Baneshwor, Ward No. 10, Kathmandu',
                    icon: Icons.home_rounded,
                  ),
                  _ProfileItemTile(
                    title: 'Work (कार्यालय)',
                    subtitle: 'Durbar Marg, Kathmandu',
                    icon: Icons.business_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Orders & History
              _ProfileSectionCard(
                title: AppStrings.of(lang, 'ordersAndHistory'),
                icon: Icons.history_rounded,
                children: const [
                  _ProfileItemTile(
                    title: 'Dr. Consultation Token #042',
                    subtitle: 'Siddhartha Health Clinic · Completed',
                    icon: Icons.receipt_long_rounded,
                  ),
                  _ProfileItemTile(
                    title: 'NEA Electricity Bill Payment',
                    subtitle: 'Ratnapark Counter · रु. ९४०.०० Paid',
                    icon: Icons.bolt_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Language Switch Setting
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.translate_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.of(lang, 'language'),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SegmentedButton<AppLanguage>(
                      segments: const [
                        ButtonSegment(value: AppLanguage.nepali, label: Text('नेपाली')),
                        ButtonSegment(value: AppLanguage.english, label: Text('English')),
                      ],
                      selected: {lang},
                      onSelectionChanged: (val) {
                        ref.read(localeProvider.notifier).setLanguage(val.first);
                      },
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sign Out Button
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(authNotifierProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.red),
                  label: Text(
                    AppStrings.of(lang, 'logout'),
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Permanent Footer
              const CompanyFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _ProfileSectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _ProfileItemTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.grey.shade700, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

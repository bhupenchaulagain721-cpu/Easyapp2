import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/company_footer.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CustomerDashboard extends ConsumerWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dynamicTitle = authState.dynamicAppTitle;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt_rounded, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'नमस्ते, ${user?.fullName ?? "ग्राहक"} 👋',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user?.province ?? 'काठमाडौँ उपत्यका (Kathmandu)',
                    style: const TextStyle(fontSize: 11, color: AppColors.lightTextMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            tooltip: 'लगआउट (Sign Out)',
            onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Republic Nepal TV Live Streaming Highlight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2A2D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.fonepayRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.live_tv_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Republic Nepal TV',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'LIVE',
                              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w900, fontSize: 10),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Text(
                          'प्रत्यक्ष प्रसारण तथा ताजा समाचार (Media & Advertising)',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white60, size: 14),
                ],
              ),
            ),

            // Easy App Nepal Digital Wallet Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF165B5E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.28),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_balance_wallet_outlined, color: AppColors.accent, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '$dynamicTitle वालेट (Easy Wallet)',
                            style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'KYC Verified ✅',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'रु. २४,५००.००',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Text(
                    'NPR 24,500.00 Available Balance',
                    style: TextStyle(color: AppColors.accentLight, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _WalletActionBtn(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'स्क्यान पे (Scan)',
                        onTap: () {},
                      ),
                      _WalletActionBtn(
                        icon: Icons.send_rounded,
                        label: 'रकम पठाउने',
                        onTap: () {},
                      ),
                      _WalletActionBtn(
                        icon: Icons.add_circle_outline_rounded,
                        label: 'टपअप (Top Up)',
                        onTap: () {},
                      ),
                      _WalletActionBtn(
                        icon: Icons.receipt_long_rounded,
                        label: 'विवरण (History)',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Dynamic Services Header
            Text(
              '$dynamicTitle डिजिटल सेवाहरू (All Dynamic Modules)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),

            // Services Grid
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              children: [
                _ServiceTile(
                  icon: Icons.live_tv_rounded,
                  color: AppColors.fonepayRed,
                  label: 'टिभी मिडिया\n(Republic TV)',
                ),
                _ServiceTile(
                  icon: Icons.shopping_bag_outlined,
                  color: const Color(0xFF0F3D3E),
                  label: 'अनलाइन बजार\n(Market)',
                ),
                _ServiceTile(
                  icon: Icons.delivery_dining_outlined,
                  color: const Color(0xFFD97706),
                  label: 'खाना डेलिभरी\n(Food)',
                ),
                _ServiceTile(
                  icon: Icons.two_wheeler_outlined,
                  color: const Color(0xFF059669),
                  label: 'राइड शेयर\n(Rides)',
                ),
                _ServiceTile(
                  icon: Icons.lightbulb_outline_rounded,
                  color: const Color(0xFF2563EB),
                  label: 'बिजुली / पानी\n(Utilities)',
                ),
                _ServiceTile(
                  icon: Icons.flight_takeoff_rounded,
                  color: const Color(0xFF7C3AED),
                  label: 'हवाई टिकट\n(Aviation)',
                ),
                _ServiceTile(
                  icon: Icons.local_hospital_outlined,
                  color: const Color(0xFFDC2626),
                  label: 'स्वास्थ्य सेवा\n(Health)',
                ),
                _ServiceTile(
                  icon: Icons.campaign_rounded,
                  color: AppColors.accentDark,
                  label: 'विज्ञापन\n(Ad Agency)',
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Permanent Footer Branding
            const CompanyFooter(),
          ],
        ),
      ),
    );
  }
}

class _WalletActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _WalletActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _ServiceTile({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, height: 1.2),
        ),
      ],
    );
  }
}

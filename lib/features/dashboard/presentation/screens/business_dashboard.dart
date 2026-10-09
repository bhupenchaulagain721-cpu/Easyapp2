import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/widgets/company_footer.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class BusinessDashboard extends ConsumerWidget {
  const BusinessDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final isStaff = user?.role == AppRole.staff;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  user?.businessName ?? 'Easy Merchant Portal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isStaff ? AppColors.info.withOpacity(0.15) : AppColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isStaff ? 'STAFF' : 'MERCHANT OWNER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isStaff ? AppColors.info : AppColors.accentDark,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'प्रबन्धक: ${user?.fullName ?? "Merchant"} · ${user?.city ?? "Kathmandu"}',
              style: const TextStyle(fontSize: 11, color: AppColors.lightTextMuted),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_rounded),
            tooltip: 'रिफ्रेश (Refresh)',
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'आजको बिक्री संकलन (Today\'s Revenue)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextMuted),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '+18.4% vs हिजो',
                          style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'रु. ८६,४२०.००',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricSubItem(
                          title: 'अर्डरहरू (Orders)',
                          value: '५२ वटा',
                          icon: Icons.receipt_long_outlined,
                        ),
                      ),
                      Expanded(
                        child: _MetricSubItem(
                          title: 'Fonepay / QR',
                          value: 'रु. ६४,१००',
                          icon: Icons.qr_code_2_rounded,
                        ),
                      ),
                      Expanded(
                        child: _MetricSubItem(
                          title: 'नगद (Cash)',
                          value: 'रु. २२,३२०',
                          icon: Icons.payments_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'दैनिक कार्यहरू (Store Operations)',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.point_of_sale_rounded, size: 20),
                    label: const Text('नयाँ बिल (POS)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.add_box_outlined, size: 20),
                    label: const Text('सामान थप्नुहोस्', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'हालका अर्डरहरू (Live Order Queue)',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _OrderListTile(
              orderId: '#EASY-9821',
              customer: 'Bikash Tamang (विकास तामाङ)',
              items: 'Ilam Organic Tea x2, Timur Pepper x1',
              total: 'रु. १,८५०',
              status: 'तयारी हुँदै (Preparing)',
              statusColor: AppColors.warning,
            ),
            _OrderListTile(
              orderId: '#EASY-9820',
              customer: 'Aarushi Karki (आरुषि कार्की)',
              items: 'Pure Ghee 1kg x1, Mustang Apples x2kg',
              total: 'रु. २,४००',
              status: 'डेलिभरीमा छ (Out for Delivery)',
              statusColor: AppColors.info,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.accentDark, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isStaff ? 'कर्मचारी सीमित पहुँच (Staff Scoped RLS)' : 'मालिक पूर्ण नियन्त्रण (Full Merchant RLS)',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.accentDark),
                        ),
                        Text(
                          isStaff
                              ? 'तपाईंसँग POS बिलिङ र अर्डर हेर्ने अनुमति छ। वित्त र कर्मचारी व्यवस्थापन मालिकको मात्र हो।'
                              : 'व्यापारिक सेटिङ, बैंक खाता र कर्मचारी अनुमतिको पूर्ण पहुँच सक्रिय छ।',
                          style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const CompanyFooter(),
          ],
        ),
      ),
    );
  }
}

class _MetricSubItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricSubItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.lightTextMuted),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontSize: 11, color: AppColors.lightTextMuted),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _OrderListTile extends StatelessWidget {
  final String orderId;
  final String customer;
  final String items;
  final String total;
  final String status;
  final Color statusColor;

  const _OrderListTile({
    required this.orderId,
    required this.customer,
    required this.items,
    required this.total,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(orderId, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(customer, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 2),
          Text(items, style: const TextStyle(fontSize: 12, color: AppColors.lightTextMuted)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('कुल रकम: $total', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.accentDark)),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                child: const Text('हेर्नुहोस् (View)'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

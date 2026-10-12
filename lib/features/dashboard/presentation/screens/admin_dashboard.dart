import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/company_footer.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  int _activeTab = 0; // 0: System Config, 1: Modules/Categories, 2: User Moderation
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentTitle = ref.read(dynamicTitleProvider);
    _titleController.text = currentTitle;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _updateTitle() async {
    final newTitle = _titleController.text.trim();
    if (newTitle.isEmpty) return;
    await ref.read(authNotifierProvider.notifier).updateAppTitle(newTitle);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('App Title updated to "$newTitle" successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
              child: const Icon(Icons.security_rounded, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'सुपर एडमिन कन्सोल (Super Admin)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'प्रशासक: ${user?.email ?? "admin"} · Republic Nepal TV HQ',
                  style: const TextStyle(fontSize: 11, color: AppColors.lightTextMuted),
                ),
              ],
            ),
          ],
        ),
        actions: [
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
            // Admin Segmented Navigation Bar
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _TabButton(
                      title: 'प्रणाली सेटिङ',
                      subtitle: 'App Config',
                      isSelected: _activeTab == 0,
                      onTap: () => setState(() => _activeTab = 0),
                    ),
                  ),
                  Expanded(
                    child: _TabButton(
                      title: 'मोड्युल तथा समूह',
                      subtitle: 'Categories',
                      isSelected: _activeTab == 1,
                      onTap: () => setState(() => _activeTab = 1),
                    ),
                  ),
                  Expanded(
                    child: _TabButton(
                      title: 'खाता नियन्त्रण',
                      subtitle: 'Moderation',
                      isSelected: _activeTab == 2,
                      onTap: () => setState(() => _activeTab = 2),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // TAB 0: DYNAMIC SYSTEM CONFIG
            if (_activeTab == 0) ...[
              Text(
                '१. गतिशील एप सेटिङ (Dynamic App Title & Global Branding)',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              const Text(
                'यस सेटिङबाट एप पुन: रिलिज नगरी प्रत्यक्ष रूपमा एपको नाम र ब्रान्डिङ परिवर्तन गर्न सकिन्छ।',
                style: TextStyle(fontSize: 12, color: AppColors.lightTextMuted),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'एपको आधिकारिक नाम (Dynamic App Title)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: 'उदा. Easy App',
                              prefixIcon: Icon(Icons.edit_note_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _updateTitle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(110, 52),
                          ),
                          child: const Text('अपडेट (Save)'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    const Text('मालिक कम्पनी: Republic Nepal TV & Advertising Pvt. Ltd.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    const Text('स्वामित्व: रिपब्लिक नेपाल टिभी एण्ड एडभरटाइजिङ प्रा. लि.', style: TextStyle(fontSize: 12, color: AppColors.lightTextSecondary)),
                    const SizedBox(height: 4),
                    const Text('प्राथमिक रंग: #0F3D3E · सहायक रंग: #C79A3E', style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: AppColors.accentDark)),
                  ],
                ),
              ),
            ],

            // TAB 1: DYNAMIC CATEGORIES & SERVICE MODULES
            if (_activeTab == 1) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '२. गतिशील सेवा मोड्युलहरू (Dynamic Modules & Segments)',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('नयाँ वर्ग थप्नुहोस्', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(120, 36)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _CategoryControlTile(
                title: 'Republic Nepal TV & Live Media',
                titleNp: 'प्रत्यक्ष टिभी प्रसारण तथा समाचार',
                segment: 'MEDIA & STREAMING',
                isActive: true,
                onToggle: (v) {},
              ),
              _CategoryControlTile(
                title: 'Easy Marketplace (Pasal)',
                titleNp: 'अनलाइन ई-कमर्स बजार',
                segment: 'ECOMMERCE',
                isActive: true,
                onToggle: (v) {},
              ),
              _CategoryControlTile(
                title: 'Food & Beverage Delivery',
                titleNp: 'खाना तथा खाजा डेलिभरी',
                segment: 'FOOD',
                isActive: true,
                onToggle: (v) {},
              ),
              _CategoryControlTile(
                title: 'Easy Rides & Logistics',
                titleNp: 'सवारी तथा पार्सल सेवा',
                segment: 'RIDES',
                isActive: true,
                onToggle: (v) {},
              ),
              _CategoryControlTile(
                title: 'NEA Electricity & Water Utilities',
                titleNp: 'बिजुली तथा खानेपानी महसुल भुक्तानी',
                segment: 'UTILITIES',
                isActive: true,
                onToggle: (v) {},
              ),
              _CategoryControlTile(
                title: 'Republic Advertising Agency Services',
                titleNp: 'विज्ञापन तथा ब्रान्डिङ अभियान',
                segment: 'SERVICES',
                isActive: false,
                onToggle: (v) {},
              ),
            ],

            // TAB 2: USER MODERATION & RBAC CONTROLS
            if (_activeTab == 2) ...[
              Text(
                '३. प्रयोगकर्ता तथा पसल नियन्त्रण (Approve, Suspend, Block, Delete)',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _UserModerationTile(
                name: 'Sunil Gurung (अन्नपूर्ण अर्गानिक फार्म)',
                email: 'sunil.gurung@nepal.np',
                role: 'व्यापारी (Merchant)',
                status: 'pending',
                onApprove: () {},
                onSuspend: () {},
                onDelete: () {},
              ),
              _UserModerationTile(
                name: 'Kiran Shrestha (किरण श्रेष्ठ)',
                email: 'kiran.rides@nepal.np',
                role: 'कर्मचारी (Staff)',
                status: 'active',
                onApprove: () {},
                onSuspend: () {},
                onDelete: () {},
              ),
              _UserModerationTile(
                name: 'Spam Outlet Kathmandu',
                email: 'suspicious.vendor@gmail.com',
                role: 'व्यापारी (Merchant)',
                status: 'suspended',
                onApprove: () {},
                onSuspend: () {},
                onDelete: () {},
              ),
            ],

            const SizedBox(height: 36),
            const CompanyFooter(),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppColors.accentLight : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryControlTile extends StatelessWidget {
  final String title;
  final String titleNp;
  final String segment;
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const _CategoryControlTile({
    required this.title,
    required this.titleNp,
    required this.segment,
    required this.isActive,
    required this.onToggle,
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        segment,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(titleNp, style: const TextStyle(fontSize: 11, color: AppColors.lightTextMuted)),
              ],
            ),
          ),
          Switch(
            value: isActive,
            activeColor: AppColors.accent,
            activeTrackColor: AppColors.primary,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}

class _UserModerationTile extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String status;
  final VoidCallback onApprove;
  final VoidCallback onSuspend;
  final VoidCallback onDelete;

  const _UserModerationTile({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.onApprove,
    required this.onSuspend,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = status == 'pending';
    final isSuspended = status == 'suspended';

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
              Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isPending
                      ? AppColors.warning.withOpacity(0.12)
                      : isSuspended
                          ? AppColors.error.withOpacity(0.12)
                          : AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isPending
                        ? AppColors.warning
                        : isSuspended
                            ? AppColors.error
                            : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text('$email · $role', style: const TextStyle(fontSize: 11, color: AppColors.lightTextMuted)),
          const SizedBox(height: 10),
          Row(
            children: [
              if (isPending || isSuspended) ...[
                ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(90, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('सक्रिय (Activate)', style: TextStyle(fontSize: 11)),
                ),
                const SizedBox(width: 8),
              ],
              if (!isSuspended) ...[
                OutlinedButton(
                  onPressed: onSuspend,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: const BorderSide(color: AppColors.warning),
                    minimumSize: const Size(80, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('निलम्बन (Suspend)', style: TextStyle(fontSize: 11)),
                ),
                const SizedBox(width: 8),
              ],
              TextButton(
                onPressed: onDelete,
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('मेटाउनुहोस् (Delete)', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

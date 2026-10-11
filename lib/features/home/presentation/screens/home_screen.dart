import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/widgets/company_footer.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/home_models.dart';
import '../providers/home_data_provider.dart';

/// Module Item Model for Easy App Home Dashboard
class ServiceModuleItem {
  final String id;
  final String titleKey;
  final String subtitleKey;
  final IconData icon;
  final Color color;
  final String segment;

  const ServiceModuleItem({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    required this.color,
    required this.segment,
  });
}

final List<ServiceModuleItem> homeModules = [
  const ServiceModuleItem(
    id: 'clinic',
    titleKey: 'modHealth',
    subtitleKey: 'modHealthSub',
    icon: Icons.local_hospital_rounded,
    color: Color(0xFFE53935),
    segment: 'HEALTH',
  ),
  const ServiceModuleItem(
    id: 'kirana',
    titleKey: 'modFood',
    subtitleKey: 'modFoodSub',
    icon: Icons.storefront_rounded,
    color: Color(0xFF2E7D32),
    segment: 'FOOD',
  ),
  const ServiceModuleItem(
    id: 'clothing',
    titleKey: 'modClothing',
    subtitleKey: 'modClothingSub',
    icon: Icons.checkroom_rounded,
    color: Color(0xFF8E24AA),
    segment: 'CLOTHING',
  ),
  const ServiceModuleItem(
    id: 'cosmetics',
    titleKey: 'modCosmetics',
    subtitleKey: 'modCosmeticsSub',
    icon: Icons.spa_rounded,
    color: Color(0xFFD81B60),
    segment: 'COSMETICS',
  ),
  const ServiceModuleItem(
    id: 'real_estate',
    titleKey: 'modRealEstate',
    subtitleKey: 'modRealEstateSub',
    icon: Icons.apartment_rounded,
    color: Color(0xFFE65100),
    segment: 'REALESTATE',
  ),
  const ServiceModuleItem(
    id: 'reuse_recycle',
    titleKey: 'modRecycle',
    subtitleKey: 'modRecycleSub',
    icon: Icons.recycling_rounded,
    color: Color(0xFF00897B),
    segment: 'RECYCLE',
  ),
  const ServiceModuleItem(
    id: 'local_market',
    titleKey: 'modLocalMarket',
    subtitleKey: 'modLocalMarketSub',
    icon: Icons.shopping_basket_rounded,
    color: Color(0xFFF57C00),
    segment: 'LOCAL_MARKET',
  ),
  const ServiceModuleItem(
    id: 'electricity',
    titleKey: 'modUtilities',
    subtitleKey: 'modUtilitiesSub',
    icon: Icons.bolt_rounded,
    color: Color(0xFFFBC02D),
    segment: 'UTILITIES',
  ),
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentNavIndex = 0;
  int _adPageIndex = 0;
  final PageController _adPageController = PageController();
  Timer? _adTimer;
  Timer? _tickerTimer;
  int _tickerIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAdAutoScroll();
    _startTickerRotation();
  }

  void _startAdAutoScroll() {
    _adTimer?.cancel();
    _adTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final ads = ref.read(homeSliderAdsProvider).valueOrNull ?? [];
      if (ads.length > 1 && _adPageController.hasClients) {
        final nextPage = (_adPageIndex + 1) % ads.length;
        _adPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _startTickerRotation() {
    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final tickerItems = ref.read(approvedTickerItemsProvider).valueOrNull ?? [];
      if (tickerItems.isNotEmpty) {
        setState(() {
          _tickerIndex = (_tickerIndex + 1) % tickerItems.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    _tickerTimer?.cancel();
    _adPageController.dispose();
    super.dispose();
  }

  void _showNoticeDialog(String title, String message, IconData icon) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 13, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('बन्द गर्नुहोस् (Close)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  // 1. Post News / Notice Form Dialog (Inserts with status 'pending' only)
  void _openPostNewsForm(AppLanguage lang) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final messageNpController = TextEditingController();
    final phoneController = TextEditingController();
    final rateItemController = TextEditingController();
    final rateValueController = TextEditingController();
    String selectedCategory = 'news';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.campaign_rounded, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Post News / Notice',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Colors.amber),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Posts require Super Admin review (Status: Pending) before publishing.',
                            style: TextStyle(fontSize: 11, color: Colors.brown, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category (प्रकार)',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'news', child: Text('Live News (ताजा समाचार)')),
                      DropdownMenuItem(value: 'notice', child: Text('Public Notice (सार्वजनिक सूचना)')),
                      DropdownMenuItem(value: 'market_rate', child: Text('Market Rate (दैनिक बजार दर)')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() {
                          selectedCategory = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Message / Headline (English)',
                      hintText: 'e.g. Kathmandu Valley organic farmers festival scheduled.',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter message' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: messageNpController,
                    decoration: InputDecoration(
                      labelText: 'Headline (नेपालीमा विवरण)',
                      hintText: 'उदाहरण: काठमाडौँमा जैविक उत्पादन मेला आयोजना हुँदै।',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'नेपालीमा विवरण लेख्नुहोस्' : null,
                  ),
                  if (selectedCategory == 'market_rate') ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: rateItemController,
                            decoration: InputDecoration(
                              labelText: 'Item Name',
                              hintText: 'e.g. Tomato Big',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: rateValueController,
                            decoration: InputDecoration(
                              labelText: 'Rate (रु.)',
                              hintText: 'e.g. रु. ६०/केजी',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Contact Phone Number (सम्पर्क नम्बर)',
                      hintText: '+977-98XXXXXXXX',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final repo = ref.read(supabaseDataRepositoryProvider);
                      final success = await repo.postNewsNotice(
                        message: titleController.text,
                        messageNp: messageNpController.text,
                        kind: selectedCategory,
                        rateItem: rateItemController.text.isNotEmpty ? rateItemController.text : null,
                        rateValue: rateValueController.text.isNotEmpty ? rateValueController.text : null,
                        contactPhone: phoneController.text.isNotEmpty ? phoneController.text : null,
                      );
                      Navigator.pop(ctx);
                      if (success && mounted) {
                        _showNoticeDialog(
                          'Submission Received (पेस भयो)',
                          'तपाईंको सूचना सफलतापूर्वक दर्ता भएको छ (Status: Pending)। रिपब्लिक नेपाल टिभी प्रशासकले प्रमाणीकरण गरेपछि यो प्रत्यक्ष देखिनेछ।',
                          Icons.check_circle_outline,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Submit News for Moderation', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 2. Post Ad Form Dialog (Inserts with status 'pending' only)
  void _openPostAdForm(AppLanguage lang) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final titleNpController = TextEditingController();
    final imageUrlController = TextEditingController(text: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800');
    final sponsorController = TextEditingController();
    final phoneController = TextEditingController();
    final redirectUrlController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.featured_video_rounded, color: AppColors.accent, size: 22),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Post Ad (विज्ञापन पेश गर्नुहोस्)',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 16, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Ads are placed on the Home Slider upon Super Admin approval (Status: Pending).',
                          style: TextStyle(fontSize: 11, color: Colors.brown, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Campaign Title (English)',
                    hintText: 'e.g. Kathmandu Organic Food Festival',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter title' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: titleNpController,
                  decoration: InputDecoration(
                    labelText: 'Campaign Title (नेपाली शीर्षक)',
                    hintText: 'उदाहरण: काठमाडौँ अर्गानिक महोत्सव',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: sponsorController,
                  decoration: InputDecoration(
                    labelText: 'Sponsor / Business Name (प्रायोजक/कम्पनी)',
                    hintText: 'e.g. Everest Agro Pvt. Ltd.',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter sponsor name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'Banner Image URL (तस्वीर लिङ्क)',
                    hintText: 'https://...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter image URL' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contact Phone Number (सम्पर्क फोन)',
                    hintText: '+977-98XXXXXXXX',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: redirectUrlController,
                  decoration: InputDecoration(
                    labelText: 'Target URL / Details Page (ऐच्छिक लिङ्क)',
                    hintText: 'https://yourwebsite.com or /category/kirana-retail',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    final repo = ref.read(supabaseDataRepositoryProvider);
                    final success = await repo.postAd(
                      title: titleController.text,
                      titleNp: titleNpController.text.isNotEmpty ? titleNpController.text : null,
                      imageUrl: imageUrlController.text,
                      sponsorName: sponsorController.text,
                      contactPhone: phoneController.text.isNotEmpty ? phoneController.text : null,
                      redirectUrl: redirectUrlController.text.isNotEmpty ? redirectUrlController.text : null,
                    );
                    Navigator.pop(ctx);
                    if (success && mounted) {
                      _showNoticeDialog(
                        'Ad Submitted for Review',
                        'तपाईंको विज्ञापन पेश भएको छ (Status: Pending)। रिपब्लिक नेपाल टिभी विज्ञापन शाखाले प्रमाणीकरण गरेपछि गृहपृष्ठ स्लाइडरमा देखिनेछ।',
                        Icons.check_circle_outline,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Submit Ad for Moderation (Status: Pending)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    final isNp = lang == AppLanguage.nepali;

    // Supabase Watchers
    final appConfigAsync = ref.watch(appConfigProvider);
    final adsAsync = ref.watch(homeSliderAdsProvider);
    final tickerItemsAsync = ref.watch(approvedTickerItemsProvider);
    final offersAsync = ref.watch(approvedOffersProvider);

    final appConfig = appConfigAsync.valueOrNull ?? const AppConfigModel(
      appTitle: 'Easy App',
      appTitleNp: 'इजी एप',
      tvName: 'RN TV',
      logoUrl: '',
      footerText: 'रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि',
      ownerCompany: 'Republic Nepal TV & Advertising Pvt. Ltd.',
      supportPhone: '+977-1-4112233',
    );

    final dynamicTitle = isNp ? appConfig.appTitleNp : appConfig.appTitle;
    final ads = adsAsync.valueOrNull ?? [];
    final tickerItems = tickerItemsAsync.valueOrNull ?? [];
    final offers = offersAsync.valueOrNull ?? [];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            if (appConfig.logoUrl.trim().isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.accent, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    appConfig.logoUrl.trim(),
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.live_tv_rounded, color: AppColors.primary, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appConfig.appTitle, // Keep app title at top from app_config 'app_title' (default 'Easy App')
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: -0.2),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    appConfig.ownerCompany,
                    style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
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
          IconButton(
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.account_circle_rounded, size: 26),
          ),
        ],
      ),
      body: SafeArea(
        child: _currentNavIndex == 1
            ? _buildTvTab(context, appConfig, isNp)
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
              // 1. NEWS & MARKET-RATE TICKER BAR (Supabase: ticker_items table)
              if (tickerItems.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.trending_up_rounded, color: AppColors.accent, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              tickerItems[_tickerIndex % tickerItems.length].category == 'market_rate' ? 'RATES' : 'NEWS',
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            isNp
                                ? tickerItems[_tickerIndex % tickerItems.length].messageNp
                                : tickerItems[_tickerIndex % tickerItems.length].message,
                            key: ValueKey(_tickerIndex),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => _openPostNewsForm(lang),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),

              // 2. TV BANNER (Reads tv_name and logo_url from system_settings.app_config)
              InkWell(
                onTap: () {
                  setState(() {
                    _currentNavIndex = 1; // Switch to RN TV Live Tab
                  });
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // If logo_url is not empty, show that image in the TV banner; otherwise show text only!
                      if (appConfig.logoUrl.trim().isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            appConfig.logoUrl.trim(),
                            width: 44,
                            height: 44,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  appConfig.tvName, // default "RN TV"
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade600,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'LIVE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isNp
                                  ? 'प्रत्यक्ष २४/७ डिजिटल तथा स्याटेलाइट प्रसारण हेर्न यहाँ थिच्नुहोस्'
                                  : 'Tap to watch official 24/7 digital live stream',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
                    ],
                  ),
                ),
              ),

              // 3. APPROVED HOME BANNER ADS SLIDER (Supabase: ads table)
              if (ads.isNotEmpty) ...[
                SizedBox(
                  height: 160,
                  child: PageView.builder(
                    controller: _adPageController,
                    onPageChanged: (idx) {
                      setState(() {
                        _adPageIndex = idx;
                      });
                    },
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final ad = ads[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(ad.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.1),
                                Colors.black.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ad.sponsorName.toUpperCase(),
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.black87),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isNp && ad.titleNp != null ? ad.titleNp! : ad.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    ads.length,
                    (idx) => Container(
                      width: _adPageIndex == idx ? 18 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: _adPageIndex == idx ? AppColors.primary : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 4. ACTION BAR: POST NEWS & POST AD BUTTONS (Inserts with status 'pending' only)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openPostNewsForm(lang),
                      icon: const Icon(Icons.add_comment_rounded, size: 18, color: AppColors.primary),
                      label: Text(
                        isNp ? 'समाचार / सूचना पठाउनुहोस्' : 'Post News / Notice',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openPostAdForm(lang),
                      icon: const Icon(Icons.campaign_rounded, size: 18, color: Colors.black87),
                      label: Text(
                        isNp ? 'विज्ञापन पेश गर्नुहोस्' : 'Post Ad / Banner',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black87),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: AppColors.accent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 5. TRENDING APPROVED OFFERS (Supabase: offers table)
              if (offers.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isNp ? 'विशेष छुट तथा अफरहरू (Offers)' : 'Trending Offers & Discounts',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimaryLight),
                    ),
                    Text(
                      '${offers.length} Active',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: offers.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (ctx, idx) {
                      final offer = offers[idx];
                      return Container(
                        width: 220,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.amber.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${offer.discountPercent}% OFF',
                                    style: TextStyle(color: Colors.red.shade800, fontSize: 10, fontWeight: FontWeight.w900),
                                  ),
                                ),
                                if (offer.couponCode != null)
                                  Text(
                                    offer.couponCode!,
                                    style: const TextStyle(fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                              ],
                            ),
                            Text(
                              isNp ? offer.titleNp : offer.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 6. DYNAMIC MODULES GRID (Clinic, Kirana, Clothing, Cosmetics, Real Estate, Recycle, Local Market, Utilities)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.of(lang, 'dynamicModules'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Verified Directory',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: homeModules.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final mod = homeModules[index];
                  return InkWell(
                    onTap: () {
                      _showNoticeDialog(
                        AppStrings.of(lang, mod.titleKey),
                        '${AppStrings.of(lang, mod.subtitleKey)}\n\nनेपाल राज्यभरका प्रमाणित सेवा तथा व्यवसायीहरूको सूची।',
                        mod.icon,
                      );
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: mod.color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(mod.icon, color: mod.color, size: 20),
                              ),
                              Text(
                                mod.segment,
                                style: TextStyle(
                                  fontSize: 8,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.of(lang, mod.titleKey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                AppStrings.of(lang, mod.subtitleKey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 7. PERMANENT DYNAMIC FOOTER (system_settings.app_config)
              // "Powered by " + app_config.footer_text (default: "रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि")
              CompanyFooter(footerText: appConfig.footerText),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) {
          if (idx == 2) {
            context.go('/profile');
          } else {
            setState(() {
              _currentNavIndex = idx;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            label: AppStrings.of(lang, 'home'),
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: const Text('LIVE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
              backgroundColor: Colors.red.shade600,
              child: const Icon(Icons.live_tv_rounded),
            ),
            label: appConfig.tvName, // default "RN TV" with LIVE badge
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            label: AppStrings.of(lang, 'profile'),
          ),
        ],
      ),
    );
  }

  /// Dedicated TV Tab (RN TV Live Stream, Schedule & Official Media Hub)
  /// Requirement 1: On the TV tab, show the name "RN TV" with the LIVE badge. Read from app_config key "tv_name".
  /// Requirement 4: If app_config "logo_url" is not empty, show that image; otherwise show text only.
  Widget _buildTvTab(BuildContext context, AppConfigModel appConfig, bool isNp) {
    final lang = ref.watch(localeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. TV Tab Top Banner: Shows tv_name ("RN TV") with the LIVE badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // If logo_url is not empty, show that image in the TV banner; otherwise show text only!
                if (appConfig.logoUrl.trim().isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      appConfig.logoUrl.trim(),
                      width: 46,
                      height: 46,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            appConfig.tvName, // default "RN TV"
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        isNp
                            ? 'प्रत्यक्ष डिजिटल तथा स्याटेलाइट प्रसारण'
                            : 'Official 24/7 Digital Satellite Broadcast',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. High-Definition Live Broadcast Player Simulation Card
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=800'),
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade600,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'LIVE HD',
                                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  '1080p · 60fps',
                                  style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.remove_red_eye_rounded, color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  '१४,२५० watching',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withValues(alpha: 0.4),
                                blurRadius: 16,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${appConfig.tvName} Live: Prime Time Special Broadcast',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action row: Post news tip & program feedback
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openPostNewsForm(lang),
                  icon: const Icon(Icons.campaign_rounded, size: 16, color: Colors.black87),
                  label: Text(
                    isNp ? 'समाचार / सूचना पठाउनुहोस्' : 'Send News Tip',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black87),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openPostAdForm(lang),
                  icon: const Icon(Icons.live_tv_rounded, size: 16, color: AppColors.primary),
                  label: Text(
                    isNp ? 'टिभी विज्ञापन पेश गर्नुहोस्' : 'Book TV Ad',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Program Schedule Guide
          Text(
            isNp ? 'प्रसारण तालिका (Today’s Schedule)' : 'Live Program Schedule',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimaryLight),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildScheduleTile(
                  time: '08:00 PM',
                  title: '${appConfig.tvName} News Hour (मुख्य समाचार)',
                  subtitle: 'Daily national & regional breaking bulletin',
                  isLive: true,
                ),
                const Divider(height: 1),
                _buildScheduleTile(
                  time: '09:00 PM',
                  title: 'Market & Economy Watch (बजार विश्लेषण)',
                  subtitle: 'Daily gold, veg rates, forex & business talk',
                  isLive: false,
                ),
                const Divider(height: 1),
                _buildScheduleTile(
                  time: '10:00 PM',
                  title: 'Special Investigation (विशेष खोज)',
                  subtitle: 'Investigative reporting from province bureaus',
                  isLive: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. Permanent Dynamic Footer at bottom of TV tab
          // "Powered by " + app_config.footer_text (default: "रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि")
          CompanyFooter(footerText: appConfig.footerText),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildScheduleTile({
    required String time,
    required String title,
    required String subtitle,
    required bool isLive,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isLive ? Colors.red.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isLive ? Colors.red.shade200 : Colors.grey.shade300),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isLive ? Colors.red.shade700 : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ON AIR',
                          style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

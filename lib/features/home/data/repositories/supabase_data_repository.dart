import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/home_models.dart';

/// Comprehensive Data Repository for Easy App (Version 1)
/// Strictly connects to Supabase tables:
/// - ads (approved, home placement)
/// - ticker_items (approved)
/// - offers (approved)
/// - system_settings (key: 'app_config')
/// - categories (is_active)
/// - businesses (approved)
///
/// Provides forms for:
/// - "Post news/notice" (inserts status = 'pending' only)
/// - "Post ad" (inserts status = 'pending' only)
class SupabaseDataRepository {
  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  bool get isReady => _client != null;

  // 1. Fetch Dynamic Categories (categories table)
  Future<List<CategoryModel>> getCategories() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('categories')
            .select()
            .eq('is_active', true)
            .order('sort_order', ascending: true);

        return (response as List)
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Supabase getCategories error: $e');
      }
    }

    return const [
      CategoryModel(id: '1', name: 'Republic TV & Media', nameNp: 'टिभी तथा प्रत्यक्ष प्रसारण', slug: 'tv-media', segmentType: 'media_tv', iconName: 'tv', sortOrder: 1, isActive: true),
      CategoryModel(id: '2', name: 'Easy Marketplace (Pasal)', nameNp: 'अनलाइन ई-कमर्स बजार', slug: 'marketplace', segmentType: 'food_retail', iconName: 'shopping_bag', sortOrder: 2, isActive: true),
      CategoryModel(id: '3', name: 'Clinic & Health Centers', nameNp: 'क्लिनिक तथा स्वास्थ्य सेवा', slug: 'health-clinics', segmentType: 'health', iconName: 'local_hospital', sortOrder: 3, isActive: true),
      CategoryModel(id: '4', name: 'Kirana & Food Retail', nameNp: 'किराना तथा दैनिक उपभोग्य', slug: 'kirana-retail', segmentType: 'food_retail', iconName: 'store', sortOrder: 4, isActive: true),
      CategoryModel(id: '5', name: 'Clothing & Fashion', nameNp: 'पहिरन तथा फेसन स्टोर', slug: 'clothing-fashion', segmentType: 'fashion', iconName: 'checkroom', sortOrder: 5, isActive: true),
      CategoryModel(id: '6', name: 'Cosmetics & Beauty', nameNp: 'सौन्दर्य तथा कस्मेटिक्स', slug: 'cosmetics-beauty', segmentType: 'beauty', iconName: 'spa', sortOrder: 6, isActive: true),
      CategoryModel(id: '7', name: 'Real Estate (Buy & Sell)', nameNp: 'घरजग्गा खरिद तथा बिक्री', slug: 'real-estate', segmentType: 'real_estate', iconName: 'apartment', sortOrder: 7, isActive: true),
      CategoryModel(id: '8', name: 'Reuse & Recycle', nameNp: 'पुन: प्रयोग तथा रिसाइकल', slug: 'reuse-recycle', segmentType: 'recycle', iconName: 'recycling', sortOrder: 8, isActive: true),
      CategoryModel(id: '9', name: 'Local Market (Haat)', nameNp: 'हाट बजार तथा स्थानीय उत्पादन', slug: 'local-market', segmentType: 'local_market', iconName: 'shopping_basket', sortOrder: 9, isActive: true),
      CategoryModel(id: '10', name: 'Electricity & Utilities', nameNp: 'बिजुली तथा खानेपानी महसुल', slug: 'utilities', segmentType: 'utilities', iconName: 'bolt', sortOrder: 10, isActive: true),
    ];
  }

  // 2. Fetch Approved Advertisements (ads table: approved + home placement)
  Future<List<AdModel>> getHomeSliderAds() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('ads')
            .select()
            .eq('status', 'approved')
            .eq('is_active', true)
            .or('placement.eq.home,placement.eq.home_banner')
            .order('priority', ascending: true);

        return (response as List)
            .map((json) => AdModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Supabase getHomeSliderAds error: $e');
      }
    }

    return const [
      AdModel(
        id: 'ad1',
        title: 'Republic Nepal TV Live 24/7 Satellite',
        titleNp: 'रिपब्लिक नेपाल टिभी २४/७ प्रत्यक्ष डिजिटल प्रसारण',
        imageUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=800',
        redirectUrl: 'https://republicnepal.tv',
        sponsorName: 'Republic Nepal TV & Advertising Pvt. Ltd.',
        placement: 'home',
        priority: 1,
        status: 'approved',
        isActive: true,
      ),
      AdModel(
        id: 'ad2',
        title: 'Organic Himalayan Herbs & Food Festival',
        titleNp: 'जैविक हिमाली जडीबुटी तथा खाद्यान्न महोत्सव',
        imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800',
        redirectUrl: '/category/kirana-retail',
        sponsorName: 'Nepal Agriculture Chamber',
        placement: 'home',
        priority: 2,
        status: 'approved',
        isActive: true,
      ),
      AdModel(
        id: 'ad3',
        title: 'Nepal Real Estate & Housing Expo 2026',
        titleNp: 'नेपाल घरजग्गा तथा आवास मेला २०२६',
        imageUrl: 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800',
        redirectUrl: '/category/real-estate',
        sponsorName: 'Real Estate Association of Nepal',
        placement: 'home',
        priority: 3,
        status: 'approved',
        isActive: true,
      ),
    ];
  }

  // 3. Fetch Approved Ticker Items (ticker_items table: news & market rates)
  Future<List<TickerItemModel>> getApprovedTickerItems() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('ticker_items')
            .select()
            .eq('status', 'approved')
            .eq('is_active', true)
            .order('sort_order', ascending: true);

        return (response as List)
            .map((json) => TickerItemModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Supabase getApprovedTickerItems error: $e');
      }
    }

    return const [
      TickerItemModel(
        id: 't1',
        message: 'Gold (छापावाल सुन): रु. १,६२,००० / तोला | Silver (चाँदी): रु. १,९५० / तोला',
        messageNp: 'सुन (छापावाल): रु. १,६२,०००/तोला | चाँदी: रु. १,९५०/तोला (नेपाल सुनचाँदी व्यवसायी महासंघ)',
        kind: 'market_rate',
        rateItem: 'Gold / Silver',
        rateValue: 'रु. १,६२,०००',
        sortOrder: 1,
        isActive: true,
      ),
      TickerItemModel(
        id: 't2',
        message: 'Kalimati Veg: Tomato (गोलभेडा) रु. ५५/केजी | Potato (आलु) रु. ४२/केजी | Onion (प्याज) रु. ८५/केजी',
        messageNp: 'कालीमाटी बजार: गोलभेडा रु. ५५/केजी, रातो आलु रु. ४२/केजी, सुकेको प्याज रु. ८५/केजी',
        kind: 'market_rate',
        rateItem: 'Vegetables (कालीमाटी)',
        rateValue: 'दैनिक दररेट',
        sortOrder: 2,
        isActive: true,
      ),
      TickerItemModel(
        id: 't3',
        message: 'Forex: USD \$1 = NPR 134.20 | EUR €1 = NPR 146.50 | QAR 1 = NPR 36.85 (NRB Official)',
        messageNp: 'मुद्रा विनिमय: अमेरिकी डलर १ = रु. १३४.२०, युरो १ = रु. १४६.५० (नेपाल राष्ट्र बैंक)',
        kind: 'market_rate',
        rateItem: 'Forex (विदेशी मुद्रा)',
        rateValue: 'NRB Rate',
        sortOrder: 3,
        isActive: true,
      ),
      TickerItemModel(
        id: 't4',
        message: 'Republic Nepal TV: Special investigative report on local markets streaming live tonight at 8:00 PM.',
        messageNp: 'ताजा समाचार: रिपब्लिक नेपाल टिभीमा आज राति ८ बजे विशेष विश्लेषणात्मक प्रत्यक्ष प्रसारण।',
        kind: 'news',
        rateItem: 'Live TV News',
        rateValue: 'LIVE',
        sortOrder: 4,
        isActive: true,
      ),
    ];
  }

  // 4. Fetch Approved Offers (offers table)
  Future<List<OfferModel>> getApprovedOffers() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('offers')
            .select()
            .eq('status', 'approved')
            .eq('is_active', true)
            .order('created_at', ascending: false);

        return (response as List)
            .map((json) => OfferModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Supabase getApprovedOffers error: $e');
      }
    }

    return [
      OfferModel(
        id: 'o1',
        title: 'Grand Opening Grocery Discount',
        titleNp: 'किराना तथा दैनिक उपभोग्यमा १५% विशेष छुट',
        description: 'Applicable across all verified Kirana retail stores on Easy App',
        discountPercent: 15,
        couponCode: 'EASYKIRANA15',
        status: 'approved',
        isActive: true,
        validUntil: DateTime.now().add(const Duration(days: 30)),
      ),
      OfferModel(
        id: 'o2',
        title: 'Ayurvedic Health Consultation Token',
        titleNp: 'क्लिनिक तथा ओपिडी परामर्शमा नि:शुल्क टोकन',
        description: 'Free preliminary doctor consultation token at partner clinics',
        discountPercent: 25,
        couponCode: 'SWASTHYA2026',
        status: 'approved',
        isActive: true,
        validUntil: DateTime.now().add(const Duration(days: 14)),
      ),
      OfferModel(
        id: 'o3',
        title: 'Local Haat Farmers Seasonal Offer',
        titleNp: 'हाट बजार स्थानीय तरकारी तथा फलफूल',
        description: 'Direct farm-to-table fresh seasonal produce with zero markup',
        discountPercent: 10,
        couponCode: 'HAATBAZAR10',
        status: 'approved',
        isActive: true,
        validUntil: DateTime.now().add(const Duration(days: 20)),
      ),
    ];
  }

  // 5. Fetch Dynamic System App Config (system_settings table: app_config)
  Future<AppConfigModel> getAppConfig() async {
    final client = _client;
    if (client != null) {
      try {
        final data = await client
            .from('system_settings')
            .select('value')
            .eq('key', 'app_config')
            .maybeSingle();

        if (data != null && data['value'] is Map) {
          return AppConfigModel.fromJson(Map<String, dynamic>.from(data['value'] as Map));
        }
      } catch (e) {
        debugPrint('Supabase getAppConfig error: $e');
      }
    }

    return const AppConfigModel(
      appTitle: 'Easy App',
      appTitleNp: 'इजी एप',
      tvName: 'RN TV',
      logoUrl: '',
      footerText: 'रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि',
      ownerCompany: 'Republic Nepal TV & Advertising Pvt. Ltd.',
      supportPhone: '+977-1-4112233',
    );
  }

  // 6. Post News / Notice Form
  // Match Supabase columns exactly: kind only 'news','notice','market_rate'; no 'alert' or 'priority';
  // and NEVER set status, approved_by, created_by, or fee_amount from the app (DB defaults handle status = 'pending').
  Future<bool> postNewsNotice({
    required String message,
    required String messageNp,
    required String kind, // Strictly 'news', 'notice', or 'market_rate'
    String? rateItem,
    String? rateValue,
    String? contactPhone,
  }) async {
    // Sanitize kind to only allowed schema values: 'news', 'notice', 'market_rate'
    final validKind = (kind == 'notice' || kind == 'market_rate') ? kind : 'news';

    final insertData = <String, dynamic>{
      'message': message.trim(),
      'message_np': messageNp.trim(),
      'kind': validKind,
      'sort_order': 0,
      'is_active': true,
    };

    if (rateItem != null && rateItem.trim().isNotEmpty) {
      insertData['rate_item'] = rateItem.trim();
    }
    if (rateValue != null && rateValue.trim().isNotEmpty) {
      insertData['rate_value'] = rateValue.trim();
    }
    if (contactPhone != null && contactPhone.trim().isNotEmpty) {
      insertData['contact_phone'] = contactPhone.trim();
    }

    final client = _client;
    if (client != null) {
      try {
        await client.from('ticker_items').insert(insertData);
        return true;
      } catch (e) {
        debugPrint('Supabase postNewsNotice error: $e');
        return false;
      }
    }

    debugPrint('Local Mock: Saved news/notice (DB pending default): $insertData');
    return true;
  }

  // 7. Post Ad Form
  // Inserts ad with placement 'home'.
  // NEVER sets status, approved_by, created_by or fee_amount from the app (DB defaults handle status = 'pending').
  Future<bool> postAd({
    required String title,
    String? titleNp,
    required String imageUrl,
    String? redirectUrl,
    required String sponsorName,
    String? contactPhone,
  }) async {
    final insertData = <String, dynamic>{
      'title': title.trim(),
      'image_url': imageUrl.trim(),
      'sponsor_name': sponsorName.trim(),
      'placement': 'home', // Home slider placement
      'priority': 1,
      'is_active': true,
    };

    if (titleNp != null && titleNp.trim().isNotEmpty) {
      insertData['title_np'] = titleNp.trim();
    }
    if (redirectUrl != null && redirectUrl.trim().isNotEmpty) {
      insertData['redirect_url'] = redirectUrl.trim();
    }
    if (contactPhone != null && contactPhone.trim().isNotEmpty) {
      insertData['contact_phone'] = contactPhone.trim();
    }

    final client = _client;
    if (client != null) {
      try {
        await client.from('ads').insert(insertData);
        return true;
      } catch (e) {
        debugPrint('Supabase postAd error: $e');
        return false;
      }
    }

    debugPrint('Local Mock: Saved ad (DB pending default): $insertData');
    return true;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/home_models.dart';
import '../../data/repositories/supabase_data_repository.dart';

final supabaseDataRepositoryProvider = Provider<SupabaseDataRepository>((ref) {
  return SupabaseDataRepository();
});

// Dynamic System Settings App Config
final appConfigProvider = FutureProvider<AppConfigModel>((ref) async {
  final repo = ref.watch(supabaseDataRepositoryProvider);
  return repo.getAppConfig();
});

// Approved Ads for Home Placement Slider
final homeSliderAdsProvider = FutureProvider<List<AdModel>>((ref) async {
  final repo = ref.watch(supabaseDataRepositoryProvider);
  return repo.getHomeSliderAds();
});

// Approved Ticker Items for News & Market Rates
final approvedTickerItemsProvider = FutureProvider<List<TickerItemModel>>((ref) async {
  final repo = ref.watch(supabaseDataRepositoryProvider);
  return repo.getApprovedTickerItems();
});

// Approved Offers
final approvedOffersProvider = FutureProvider<List<OfferModel>>((ref) async {
  final repo = ref.watch(supabaseDataRepositoryProvider);
  return repo.getApprovedOffers();
});

// Dynamic Categories
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repo = ref.watch(supabaseDataRepositoryProvider);
  return repo.getCategories();
});

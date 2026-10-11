import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_roles.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/dashboard/presentation/screens/admin_dashboard.dart';
import 'features/dashboard/presentation/screens/business_dashboard.dart';
import 'features/dashboard/presentation/screens/customer_dashboard.dart';

// Reading SUPABASE_URL and SUPABASE_ANON_KEY from --dart-define
// Example: flutter run --dart-define=SUPABASE_URL=https://xyz.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJ...
const String kSupabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String kSupabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kSupabaseUrl.isNotEmpty && kSupabaseAnonKey.isNotEmpty) {
    try {
      await Supabase.initialize(
        url: kSupabaseUrl,
        anonKey: kSupabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          autoRefreshToken: true,
        ),
      );
      debugPrint('Easy App: Supabase initialized with anon key.');
    } catch (e) {
      debugPrint('Easy App Supabase Initialization Notice: $e');
    }
  } else {
    debugPrint(
      'Notice: SUPABASE_URL and SUPABASE_ANON_KEY were not passed via --dart-define.\n'
      'App running with fallback local data state for UI development.',
    );
  }

  runApp(
    const ProviderScope(
      child: EasyAppRoot(),
    ),
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      // Phase 1 Routes
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Multi-Role Dashboards (backward compatible)
      GoRoute(
        path: '/customer-dashboard',
        name: 'customer_dashboard',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/business-dashboard',
        name: 'business_dashboard',
        builder: (context, state) => const BusinessDashboard(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        name: 'admin_dashboard',
        builder: (context, state) => const AdminDashboard(),
      ),
    ],
    redirect: (context, state) {
      if (!authState.isInitialCheckDone) return null;

      final isGoingToAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/';
      final isAuthenticated = authState.isAuthenticated && authState.user != null;

      if (!isAuthenticated && !isGoingToAuth) {
        return '/login';
      }

      if (isAuthenticated && (state.matchedLocation == '/login' || state.matchedLocation == '/register')) {
        return '/home';
      }

      return null;
    },
  );
});

class EasyAppRoot extends ConsumerWidget {
  const EasyAppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final dynamicTitle = ref.watch(dynamicTitleProvider);

    return MaterialApp.router(
      title: dynamicTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

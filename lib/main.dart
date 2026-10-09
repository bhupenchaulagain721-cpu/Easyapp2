import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_roles.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/auth_gate.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/dashboard/presentation/screens/admin_dashboard.dart';
import 'features/dashboard/presentation/screens/business_dashboard.dart';
import 'features/dashboard/presentation/screens/customer_dashboard.dart';

const String _kDefaultSupabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://easyapp.supabase.co',
);

const String _kDefaultSupabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_anon_key_for_development',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: _kDefaultSupabaseUrl,
      anonKey: _kDefaultSupabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        autoRefreshToken: true,
      ),
    );
  } catch (e) {
    debugPrint('Easy App Supabase Notice: $e');
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
      GoRoute(
        path: '/',
        name: 'auth_gate',
        builder: (context, state) => const AuthGate(),
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
        path: '/customer-dashboard',
        name: 'customer_dashboard',
        builder: (context, state) => const CustomerDashboard(),
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

      final isGoingToAuth = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isAuthenticated = authState.isAuthenticated && authState.user != null;

      if (!isAuthenticated && !isGoingToAuth && state.matchedLocation != '/') {
        return '/login';
      }

      if (isAuthenticated && isGoingToAuth) {
        return authState.role.defaultRoutePath;
      }

      if (isAuthenticated) {
        final role = authState.role;
        final loc = state.matchedLocation;

        if (loc == '/admin-dashboard' && role != AppRole.superAdmin) {
          return role.defaultRoutePath;
        }

        if (loc == '/business-dashboard' &&
            role != AppRole.businessOwner &&
            role != AppRole.staff &&
            role != AppRole.superAdmin) {
          return '/customer-dashboard';
        }
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
    // Listen to dynamic title from database system_settings
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

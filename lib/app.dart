import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/routing/routes.dart';
import 'features/user/domain/entities/user.dart';
import 'features/user/presentation/providers/user_provider.dart';
import 'core/theme/theme.dart';

/// Main navigation router configuration with role-based access control
/// 
/// This router handles:
/// - Authentication state redirection
/// - Role-based route access (Customer vs Owner)
/// - Proper navigation flow based on user status
final routerProvider = Provider<GoRouter>((ref) {
  final userState = ref.watch(userProvider);

  return GoRouter(
    initialLocation: userState.isAuthenticated 
        ? (userState.user?.role == UserRole.owner ? AppRoutes.ownerDashboard : AppRoutes.home)
        : AppRoutes.signIn,
    debugLogDiagnostics: false,
    routes: buildAppRoutes(userState.user?.role, userState.isAuthenticated),
    redirect: (context, state) {
      final isAuthenticated = userState.isAuthenticated;
      final currentPath = state.uri.path;
      final userRole = userState.user?.role;
      
      debugPrint('🔵 Router Redirect: isAuth=$isAuthenticated, path=$currentPath, role=$userRole');
      
      // Auth screens
      final isSigningIn = currentPath == AppRoutes.signIn;
      final isSigningUp = currentPath == AppRoutes.signUp;
      final isVerifying = currentPath == AppRoutes.verification;

      // Not authenticated - ensure on auth screen
      if (!isAuthenticated) {
        if (isSigningIn || isSigningUp || isVerifying) {
          return null; // Allow auth screens
        }
        return AppRoutes.signIn; // Redirect to sign in
      }

      // Authenticated - block access to auth screens and redirect to appropriate home
      if (isSigningIn || isSigningUp || isVerifying) {
        if (userRole == null) {
          return AppRoutes.signIn;
        }
        final redirectTo = userRole == UserRole.owner 
            ? AppRoutes.ownerDashboard 
            : AppRoutes.home;
        debugPrint('🔵 Post-login redirect to: $redirectTo');
        return redirectTo;
      }

      // Authenticated - check role-based access
      final isOwnerRoute = currentPath.startsWith('/owner-');
      final isProfileRoute = currentPath == AppRoutes.profile;
      final isCustomerRoute = currentPath.startsWith('/') && !currentPath.startsWith('/owner-') && currentPath != '/' && currentPath != AppRoutes.signIn && currentPath != AppRoutes.signUp && currentPath != AppRoutes.verification;

      // Owner trying to access profile - redirect to owner profile
      if (isProfileRoute && userRole == UserRole.owner) {
        debugPrint('🔵 Owner accessing profile, redirecting to owner profile');
        return AppRoutes.ownerProfile;
      }

      // Owner trying to access customer route (but not profile)
      if (isCustomerRoute && userRole == UserRole.owner && currentPath != AppRoutes.home && !isProfileRoute) {
        debugPrint('🔵 Owner tried customer route, redirecting to owner dashboard');
        return AppRoutes.ownerDashboard;
      }

      // Customer trying to access owner route
      if (isOwnerRoute && userRole != null && userRole != UserRole.owner) {
        debugPrint('🔵 Customer tried owner route, redirecting to home');
        return AppRoutes.home;
      }

      return null; // No redirect needed
    },
  );
});

/// Main app widget
class BrewEaseApp extends ConsumerWidget {
  const BrewEaseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'BrewEase Rewards',
      theme: BrewEaseTheme.lightTheme,
      darkTheme: BrewEaseTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

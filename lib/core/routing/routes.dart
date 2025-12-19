import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/user/domain/entities/user.dart';
import '../../features/user/presentation/screens/sign_in_screen.dart';
import '../../features/user/presentation/screens/sign_up_screen.dart';
import '../../features/user/presentation/screens/profile_screen.dart';
import '../../features/menu/presentation/screens/menu_screen.dart';
import '../../features/menu/presentation/screens/menu_detail_screen.dart';
import '../../features/loyalty/presentation/screens/loyalty_screen.dart';
import '../../features/order/presentation/screens/orders_screen.dart';
import '../../features/transaction/presentation/screens/transactions_screen.dart';
import '../../features/notification/presentation/screens/notifications_screen.dart';
import '../../features/menu/domain/entities/menu_item.dart';
import '../../features/owner/presentation/screens/owner_dashboard_screen.dart';
import '../../features/owner/presentation/screens/owner_menu_management_screen.dart';
import '../../features/owner/presentation/screens/owner_orders_dashboard_screen.dart';
import '../../features/owner/presentation/screens/owner_end_of_day_summary_screen.dart';
import '../../features/owner/presentation/screens/owner_profile_screen.dart';
import '../widgets/brewease_bottom_nav_bar.dart';

/// Route path constants for type-safe navigation
class AppRoutes {
  // Auth routes
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String verification = '/verification';

  // Customer routes
  static const String home = '/home';
  static const String menu = '/menu';
  static const String menuDetail = '/menu-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
  static const String orderHistory = '/order-history';

  // Shared routes
  static const String profile = '/profile';
  static const String loyalty = '/loyalty';
  static const String orders = '/orders';
  static const String transactions = '/transactions';
  static const String notifications = '/notifications';

  // Owner routes
  static const String ownerDashboard = '/owner-dashboard';
  static const String ownerProfile = '/owner-profile';
  static const String ownerMenuManagement = '/owner-menu-management';
  static const String ownerOrdersDashboard = '/owner-orders-dashboard';
  static const String ownerOrderDetail = '/owner-orders-dashboard/:orderId';
  static const String ownerEndOfDaySummary = '/owner-end-of-day-summary';
}

/// Build customer routes (Home shell with bottom navigation)
List<RouteBase> buildCustomerRoutes() {
  return [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(
        role: UserRole.customer,
        child: child,
      ),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const MenuScreen(),
        ),
        GoRoute(
          path: AppRoutes.menu,
          name: 'menu',
          builder: (context, state) => const MenuScreen(),
        ),
        GoRoute(
          path: AppRoutes.menuDetail,
          name: 'menuDetail',
          builder: (context, state) {
            final item = state.extra as MenuItem?;
            if (item == null) {
              return const Scaffold(
                body: Center(child: Text('Error: Item not found')),
              );
            }
            return MenuDetailScreen(item: item);
          },
        ),
        GoRoute(
          path: AppRoutes.loyalty,
          name: 'loyalty',
          builder: (context, state) => const LoyaltyScreen(),
        ),
        GoRoute(
          path: AppRoutes.orders,
          name: 'orders',
          builder: (context, state) => const OrdersScreen(),
        ),
        GoRoute(
          path: AppRoutes.transactions,
          name: 'transactions',
          builder: (context, state) => const TransactionsScreen(),
        ),
        GoRoute(
          path: AppRoutes.notifications,
          name: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ];
}

/// Build owner routes
List<RouteBase> buildOwnerRoutes() {
  return [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(
        role: UserRole.owner,
        child: child,
      ),
      routes: [
        GoRoute(
          path: AppRoutes.ownerDashboard,
          name: 'ownerDashboard',
          builder: (context, state) => const OwnerDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.ownerProfile,
          name: 'ownerProfile',
          builder: (context, state) => const OwnerProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.ownerMenuManagement,
          name: 'ownerMenuManagement',
          builder: (context, state) => const OwnerMenuManagementScreen(),
        ),
        GoRoute(
          path: AppRoutes.ownerOrdersDashboard,
          name: 'ownerOrdersDashboard',
          builder: (context, state) => const OwnerOrdersDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.ownerEndOfDaySummary,
          name: 'ownerEndOfDaySummary',
          builder: (context, state) => const OwnerEndOfDaySummaryScreen(),
        ),
      ],
    ),
  ];
}

/// Build all routes with proper authentication and role-based guards
List<RouteBase> buildAppRoutes(UserRole? userRole, bool isAuthenticated) {
  return [
    // Authentication routes (always available)
    GoRoute(
      path: AppRoutes.signIn,
      name: 'signIn',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      name: 'signUp',
      builder: (context, state) => const SignUpScreen(),
    ),

    // Verification route
    GoRoute(
      path: AppRoutes.verification,
      name: 'verification',
      builder: (context, state) => const Placeholder(
        child: Center(
          child: Text('Verification Screen - Coming Soon'),
        ),
      ),
    ),

    // Customer routes (always built, redirect handles access)
    ...buildCustomerRoutes(),

    // Owner routes (always built, redirect handles access)
    ...buildOwnerRoutes(),
  ];
}

/// Main scaffold with role-based bottom navigation
class MainScaffold extends StatefulWidget {
  final Widget child;
  final UserRole role;

  const MainScaffold({
    super.key,
    required this.child,
    required this.role,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: widget.role == UserRole.customer
          ? BrewEaseBottomNavBar.customer(
              currentRoute: location,
              onItemTapped: (route) {
                context.go(route);
              },
            )
          : BrewEaseBottomNavBar.owner(
              currentRoute: location,
              onItemTapped: (route) {
                context.go(route);
              },
            ),
    );
  }
}

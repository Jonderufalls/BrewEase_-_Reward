import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/user/domain/entities/user.dart';
import '../theme/theme.dart';

/// Navigation item data model
class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final int? badge;

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    this.badge,
  });
}

/// Enhanced bottom navigation bar with role-based items
/// 
/// Features:
/// - Smooth animations
/// - Badge support for notifications/orders
/// - Role-specific navigation items
/// - Active route highlighting
/// - Responsive design
class BrewEaseBottomNavBar extends StatelessWidget {
  final String currentRoute;
  final UserRole role;
  final List<NavItem> items;
  final ValueChanged<String> onItemTapped;

  const BrewEaseBottomNavBar({
    super.key,
    required this.currentRoute,
    required this.role,
    required this.items,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < items.length; i++)
                _buildNavBarItem(
                  context,
                  items[i],
                  i == items.indexWhere((item) => item.route == currentRoute),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(BuildContext context, NavItem item, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isActive) {
            context.go(item.route);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Icon container with background on active
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: isActive
                        ? BoxDecoration(
                            color: BrewEaseTheme.accentOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : null,
                    child: Icon(
                      isActive ? item.activeIcon : item.icon,
                      color: isActive
                          ? BrewEaseTheme.accentOrange
                          : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  // Badge
                  if (item.badge != null && item.badge! > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: BrewEaseTheme.warningRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(minWidth: 20),
                        child: Text(
                          item.badge! > 9 ? '9+' : '${item.badge}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? BrewEaseTheme.accentOrange : Colors.grey[600],
                ),
                child: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Active indicator line
              if (isActive)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    height: 3,
                    width: 20,
                    decoration: BoxDecoration(
                      color: BrewEaseTheme.accentOrange,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Factory constructor to build customer navigation items
  factory BrewEaseBottomNavBar.customer({
    required String currentRoute,
    required ValueChanged<String> onItemTapped,
  }) {
    return BrewEaseBottomNavBar(
      currentRoute: currentRoute,
      role: UserRole.customer,
      items: [
        NavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
          route: '/home',
        ),
        NavItem(
          icon: Icons.shopping_bag_outlined,
          activeIcon: Icons.shopping_bag,
          label: 'Orders',
          route: '/orders',
          // badge: 2, // Example: show 2 pending orders
        ),
        NavItem(
          icon: Icons.star_outline,
          activeIcon: Icons.star,
          label: 'Loyalty',
          route: '/loyalty',
        ),
        NavItem(
          icon: Icons.notifications_outlined,
          activeIcon: Icons.notifications,
          label: 'Promos',
          route: '/notifications',
          // badge: 3, // Example: show 3 new promos
        ),
        NavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profile',
          route: '/profile',
        ),
      ],
      onItemTapped: onItemTapped,
    );
  }

  /// Factory constructor to build owner navigation items
  factory BrewEaseBottomNavBar.owner({
    required String currentRoute,
    required ValueChanged<String> onItemTapped,
  }) {
    return BrewEaseBottomNavBar(
      currentRoute: currentRoute,
      role: UserRole.owner,
      items: [
        NavItem(
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard,
          label: 'Dashboard',
          route: '/owner-dashboard',
        ),
        NavItem(
          icon: Icons.menu_book_outlined,
          activeIcon: Icons.menu_book,
          label: 'Menu',
          route: '/owner-menu-management',
        ),
        NavItem(
          icon: Icons.assignment_outlined,
          activeIcon: Icons.assignment,
          label: 'Orders',
          route: '/owner-orders-dashboard',
          // badge: 5, // Example: show 5 pending orders
        ),
        NavItem(
          icon: Icons.bar_chart_outlined,
          activeIcon: Icons.bar_chart,
          label: 'Analytics',
          route: '/owner-end-of-day-summary',
        ),
        NavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profile',
          route: '/profile',
        ),
      ],
      onItemTapped: onItemTapped,
    );
  }
}

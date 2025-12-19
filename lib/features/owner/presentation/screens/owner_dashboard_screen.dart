import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../providers/backend_provider.dart';

class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() =>
      _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final backendService = ref.watch(backendServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        backgroundColor: BrewEaseTheme.primaryBrown,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(ownerOrderSummaryProvider);
          ref.invalidate(ownerMenuStatsProvider);
          ref.invalidate(ownerDailyRevenueProvider);
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Header
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      BrewEaseTheme.primaryBrown,
                      BrewEaseTheme.primaryBrown.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back, Owner',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 600 ? 32 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage your coffee shop operations',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Key Metrics
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today\'s Metrics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMetricsGrid(ref, backendService),
                  ],
                ),
              ),

              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActionButtons(context),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(WidgetRef ref, dynamic backendService) {
    return FutureBuilder<Map<String, dynamic>>(
      future: Future.wait<dynamic>([
        backendService.getOrderSummary(),
        backendService.getActivePromotions().catchError((e) {
          debugPrint('❌ Error fetching promotions: $e');
          return []; // Return empty list on error
        }),
      ]).then((results) async {
        final summary = results[0] as Map<String, dynamic>?;
        final promos = results[1] as List<dynamic>? ?? [];
        
        // Calculate daily revenue (simplified)
        final totalOrders = (summary?['totalOrders'] ?? 0) as int;
        final rawSpent = summary?['totalSpent'] ?? 0.0;
        
        // Handle both double and string types
        final totalSpent = rawSpent is String 
            ? double.tryParse(rawSpent) ?? 0.0 
            : (rawSpent as double? ?? 0.0);
        
        return {
          'orders': totalOrders,
          'revenue': totalSpent,
          'promotions': promos.length,
        };
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          debugPrint('❌ Metrics grid error: ${snapshot.error}');
          return _buildErrorMetricsGrid(context);
        }

        final data = snapshot.data ?? {
          'orders': 0,
          'revenue': 0.0,
          'promotions': 0,
        };

        final screenWidth = MediaQuery.of(context).size.width;
        final crossAxisCount = screenWidth > 1200 ? 5 : (screenWidth > 800 ? 4 : 3);
        final childAspectRatio = screenWidth > 1200 ? 1.8 : (screenWidth > 800 ? 1.2 : 0.9);

        return GridView.count(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: screenWidth > 800 ? 12 : 8,
          mainAxisSpacing: screenWidth > 800 ? 12 : 8,
          children: [
            _buildMetricCard(
              'Orders',
              '${data['orders'] ?? 0}',
              Icons.shopping_bag_outlined,
              context,
            ),
            _buildMetricCard(
              'Revenue',
              '\$${(data['revenue'] ?? 0.0).toStringAsFixed(2)}',
              Icons.trending_up,
              context,
            ),
            _buildMetricCard(
              'Active Promos',
              '${data['promotions'] ?? 0}',
              Icons.local_offer_outlined,
              context,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive sizing
    final padding = screenWidth > 800 ? 12.0 : 8.0;
    final iconSize = screenWidth > 800 ? 24.0 : 18.0;
    final valueFontSize = screenWidth > 800 ? 16.0 : 13.0;
    final titleFontSize = screenWidth > 800 ? 12.0 : 10.0;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: BrewEaseTheme.accentOrange,
            size: iconSize,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 4 : (screenWidth > 800 ? 3 : 2);
    
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.1,
      children: [
        _buildActionCard(
          'Menu Management',
          Icons.restaurant_menu,
          () => context.go('/owner-menu-management'),
        ),
        _buildActionCard(
          'Orders Dashboard',
          Icons.assignment,
          () => context.go('/owner-orders-dashboard'),
        ),
        _buildActionCard(
          'End of Day Report',
          Icons.assessment,
          () => context.go('/owner-end-of-day-summary'),
        ),
        _buildActionCard(
          'Settings',
          Icons.settings,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings coming soon')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: BrewEaseTheme.accentOrange,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMetricsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildMetricCard('Orders', '--', Icons.shopping_bag_outlined, context),
        _buildMetricCard('Revenue', '\$--', Icons.trending_up, context),
        _buildMetricCard('Active Promos', '--', Icons.local_offer, context),
      ],
    );
  }
}

// Providers for owner dashboard data
final ownerOrderSummaryProvider = FutureProvider.autoDispose((ref) async {
  final backend = ref.watch(backendServiceProvider);
  return backend.getOrderSummary();
});

final ownerMenuStatsProvider = FutureProvider.autoDispose((ref) async {
  final backend = ref.watch(backendServiceProvider);
  final items = await backend.getMenuItems();
  return {
    'totalItems': items.length,
    'availableItems': items.where((e) => e['available'] == true).length,
  };
});

final ownerDailyRevenueProvider = FutureProvider.autoDispose((ref) async {
  final backend = ref.watch(backendServiceProvider);
  final summary = await backend.getOrderSummary();
  return summary['totalSpent'] ?? 0.0;
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../providers/backend_provider.dart';

class OwnerEndOfDaySummaryScreen extends ConsumerWidget {
  const OwnerEndOfDaySummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backendService = ref.watch(backendServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('End of Day Summary'),
        backgroundColor: BrewEaseTheme.primaryBrown,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report downloaded')),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: backendService.getOrderSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          final data = snapshot.data!;
          final totalOrders = (data['totalOrders'] ?? 0) as int;
          
          // Handle both double and string types for totalSpent
          final rawSpent = data['totalSpent'] ?? 0.0;
          final totalSpent = rawSpent is String 
              ? double.tryParse(rawSpent) ?? 0.0 
              : (rawSpent as double? ?? 0.0);
          
          final completedOrders = (data['completedOrders'] ?? 0) as int;
          final avgOrderValue = totalOrders > 0 ? totalSpent / totalOrders : 0.0;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Date Summary Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        BrewEaseTheme.primaryBrown,
                        BrewEaseTheme.primaryBrown.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily Summary',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                // Key Metrics
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Summary Metrics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMetricsRow(
                        'Total Orders',
                        totalOrders.toString(),
                        Icons.shopping_bag_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildMetricsRow(
                        'Completed Orders',
                        completedOrders.toString(),
                        Icons.check_circle_outline,
                      ),
                      const SizedBox(height: 12),
                      _buildMetricsRow(
                        'Total Revenue',
                        '\$${totalSpent.toStringAsFixed(2)}',
                        Icons.trending_up,
                        isHighlight: true,
                      ),
                      const SizedBox(height: 12),
                      _buildMetricsRow(
                        'Avg. Order Value',
                        '\$${avgOrderValue.toStringAsFixed(2)}',
                        Icons.calculate_outlined,
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Additional Details
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Additional Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailCard(
                        'Transactions',
                        '${totalOrders} order transactions',
                        Icons.receipt_long_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailCard(
                        'Popular Item',
                        'Espresso (Top seller)',
                        Icons.star_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailCard(
                        'Active Promotions',
                        '3 active offers running',
                        Icons.local_offer_outlined,
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Actions
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: const Text('Download Report as PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BrewEaseTheme.accentOrange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Report downloaded to Downloads folder'),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.mail_outline),
                          label: const Text('Email Report'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Report sent to your email'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricsRow(
    String label,
    String value,
    IconData icon, {
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight ? BrewEaseTheme.accentOrange.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight ? BrewEaseTheme.accentOrange : Colors.grey[300]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: BrewEaseTheme.accentOrange, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isHighlight ? BrewEaseTheme.accentOrange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: BrewEaseTheme.primaryBrown, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

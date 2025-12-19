import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/menu_item.dart';
import '../providers/menu_provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../providers/backend_provider.dart';
import 'favorites_screen.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final List<String> categories = ['All', 'Coffee', 'Tea', 'Pastries', 'Beverages', 'Food'];
  final Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(menuProvider.notifier).fetchMenu('store_1');
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);

    return Scaffold(
      backgroundColor: BrewEaseTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Menu'),
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_outline),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FavoritesScreen(favoriteIds: favorites),
                    ),
                  );
                },
              ),
              if (favorites.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${favorites.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search menu items...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _selectedCategory == 'All'
                  ? ref.read(backendServiceProvider).getMenuItems()
                  : ref.read(backendServiceProvider).getMenuItemsByCategory(_selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                var items = snapshot.data ?? [];
                
                if (_searchController.text.isNotEmpty) {
                  final query = _searchController.text.toLowerCase();
                  items = items.where((item) {
                    final name = (item['name'] as String?)?.toLowerCase() ?? '';
                    final desc = (item['description'] as String?)?.toLowerCase() ?? '';
                    return name.contains(query) || desc.contains(query);
                  }).toList();
                }

                items = items.where((item) => item['available'] != false).toList();

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items available',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isFavorite = favorites.contains(item['id']);
                    return _buildMenuItemCard(item, isFavorite);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildMenuItemCard(Map<String, dynamic> item, bool isFavorite) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: BrewEaseTheme.primaryLight.withOpacity(0.2),
              ),
              child: item['image'] != null && item['image'].toString().isNotEmpty
                  ? Image.network(
                      item['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.coffee,
                        size: 48,
                        color: BrewEaseTheme.primaryBrown,
                      ),
                    )
                  : const Icon(
                      Icons.coffee,
                      size: 48,
                      color: BrewEaseTheme.primaryBrown,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? 'Unknown Item',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item['price']?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: BrewEaseTheme.accentOrange,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (isFavorite) {
                        favorites.remove(item['id']);
                      } else {
                        favorites.add(item['id']);
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? '❤️ Removed from favorites'
                              : '❤️ Added to favorites',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    color: Colors.red,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrewEaseTheme.accentOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {
                    _showCustomizationDialog(item);
                  },
                  child: const Text(
                    'Buy',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomizationDialog(Map<String, dynamic> item) {
    int quantity = 1;
    String sugarLevel = 'Normal';
    final Map<String, String> selectedAddOns = {};
    final List<String> sugarOptions = ['Light', 'Normal', 'Extra'];
    final List<String> availableAddOns = [
      'Extra shot (+\$0.75)',
      'Almond milk (+\$0.50)',
      'Oat milk (+\$0.50)',
      'Coconut milk (+\$0.50)',
      'Whipped cream (+\$0.75)',
      'Caramel sauce (+\$0.50)',
      'Vanilla syrup (+\$0.50)',
      'Hazelnut syrup (+\$0.50)',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final basePrice = (item['price'] as num?)?.toDouble() ?? 0.0;
          double addOnsPrice = 0.0;
          for (var addOn in selectedAddOns.values) {
            final match = RegExp(r'\+\$(\d+\.?\d*)').firstMatch(addOn);
            if (match != null) {
              addOnsPrice += double.parse(match.group(1)!);
            }
          }
          final total = (basePrice + addOnsPrice) * quantity;

          return AlertDialog(
            title: Text('Customize ${item['name']}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Quantity: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
                      IconButton(
                        onPressed: () => setState(() => quantity++),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  const Text('Sugar Level:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: sugarOptions.map((level) {
                      final isSelected = level == sugarLevel;
                      return ChoiceChip(
                        label: Text(level),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => sugarLevel = level);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  const Text('Add-ons:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...availableAddOns.map((addOn) {
                    final key = addOn.split(' ')[0];
                    final isSelected = selectedAddOns.containsKey(key);
                    return CheckboxListTile(
                      title: Text(addOn, style: const TextStyle(fontSize: 13)),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedAddOns[key] = addOn;
                          } else {
                            selectedAddOns.remove(key);
                          }
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                  
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: BrewEaseTheme.accentOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Base Price:'),
                            Text('\$${basePrice.toStringAsFixed(2)}'),
                          ],
                        ),
                        if (addOnsPrice > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Add-ons:'),
                              Text('+\$${addOnsPrice.toStringAsFixed(2)}'),
                            ],
                          ),
                        ],
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: BrewEaseTheme.accentOrange),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BrewEaseTheme.accentOrange,
                ),
                onPressed: () async {
                  await _processOrder(item, quantity, selectedAddOns, total, sugarLevel);
                  if (mounted) {
                    Navigator.pop(context);
                    context.go('/orders');
                  }
                },
                child: const Text('Complete Order'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _processOrder(
    Map<String, dynamic> item,
    int quantity,
    Map<String, String> addOns,
    double total,
    String sugarLevel,
  ) async {
    try {
      final backendService = ref.read(backendServiceProvider);
      
      final orderItems = [
        {
          'itemId': item['id'],
          'name': item['name'],
          'price': item['price'],
          'quantity': quantity,
          'sugarLevel': sugarLevel,
          'addOns': addOns.values.toList(),
          'subtotal': total,
        }
      ];

      await backendService.createOrder(
        userId: 'customer_001',
        items: orderItems,
        total: total,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Order placed! Total: \$${total.toStringAsFixed(2)}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

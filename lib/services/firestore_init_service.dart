import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreInitService {
  static Future<void> initializeFirestore() async {
    debugPrint('🔵 Initializing Firestore with sample data...');
    
    final firestore = FirebaseFirestore.instance;
    
    try {
      // Check if data already exists
      final menuCheck = await firestore.collection('menu').limit(1).get();
      if (menuCheck.docs.isNotEmpty) {
        debugPrint('✅ Firestore already initialized');
        return;
      }
      
      // Initialize Menu Items
      await _initializeMenuItems(firestore);
      
      // Initialize Loyalty Tiers
      await _initializeLoyaltyTiers(firestore);
      
      // Initialize Promotions
      await _initializePromotions(firestore);
      
      debugPrint('✅ Firestore initialization complete');
    } catch (e) {
      debugPrint('❌ Firestore initialization error: $e');
    }
  }
  
  static Future<void> _initializeMenuItems(FirebaseFirestore firestore) async {
    final menuItems = [
      {
        'id': 'item1',
        'name': 'Espresso',
        'category': 'Coffee',
        'price': 3.50,
        'description': 'Strong and bold espresso shot',
        'image': 'https://images.unsplash.com/photo-1510707577662-ddd2bf68fdf9?w=300',
        'available': true,
        'customizable': true,
      },
      {
        'id': 'item2',
        'name': 'Cappuccino',
        'category': 'Coffee',
        'price': 4.50,
        'description': 'Smooth cappuccino with creamy foam',
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300',
        'available': true,
        'customizable': true,
      },
      {
        'id': 'item3',
        'name': 'Latte',
        'category': 'Coffee',
        'price': 4.75,
        'description': 'Smooth and creamy latte',
        'image': 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=300',
        'available': true,
        'customizable': true,
      },
      {
        'id': 'item4',
        'name': 'Iced Coffee',
        'category': 'Cold Drinks',
        'price': 3.99,
        'description': 'Refreshing cold brew coffee',
        'image': 'https://images.unsplash.com/photo-1517668808822-9ebb02ae2a0e?w=300',
        'available': true,
        'customizable': true,
      },
      {
        'id': 'item5',
        'name': 'Matcha Latte',
        'category': 'Specialty',
        'price': 5.50,
        'description': 'Creamy matcha green tea latte',
        'image': 'https://images.unsplash.com/photo-1505252585461-04db1921ae57?w=300',
        'available': true,
        'customizable': true,
      },
      {
        'id': 'item6',
        'name': 'Chocolate Croissant',
        'category': 'Pastries',
        'price': 4.00,
        'description': 'Fresh buttery croissant with chocolate',
        'image': 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=300',
        'available': true,
        'customizable': false,
      },
      {
        'id': 'item7',
        'name': 'Blueberry Muffin',
        'category': 'Pastries',
        'price': 3.75,
        'description': 'Moist blueberry muffin',
        'image': 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=300',
        'available': true,
        'customizable': false,
      },
      {
        'id': 'item8',
        'name': 'Cheese Sandwich',
        'category': 'Food',
        'price': 6.50,
        'description': 'Grilled cheese sandwich with premium cheese',
        'image': 'https://images.unsplash.com/photo-1528735602780-cf6f47ba0e41?w=300',
        'available': true,
        'customizable': true,
      },
    ];
    
    final batch = firestore.batch();
    for (var item in menuItems) {
      batch.set(firestore.collection('menu').doc(item['id'] as String), item);
    }
    await batch.commit();
    debugPrint('✅ Menu items initialized: ${menuItems.length} items');
  }
  
  static Future<void> _initializeLoyaltyTiers(FirebaseFirestore firestore) async {
    final tiers = [
      {
        'id': 'bronze',
        'name': 'Bronze Member',
        'minPoints': 0,
        'maxPoints': 499,
        'discountPercent': 5,
        'color': '#CD7F32',
      },
      {
        'id': 'silver',
        'name': 'Silver Member',
        'minPoints': 500,
        'maxPoints': 999,
        'discountPercent': 10,
        'color': '#C0C0C0',
      },
      {
        'id': 'gold',
        'name': 'Gold Member',
        'minPoints': 1000,
        'maxPoints': 4999,
        'discountPercent': 15,
        'color': '#FFD700',
      },
      {
        'id': 'platinum',
        'name': 'Platinum Member',
        'minPoints': 5000,
        'maxPoints': 999999,
        'discountPercent': 20,
        'color': '#E5E4E2',
      },
    ];
    
    final batch = firestore.batch();
    for (var tier in tiers) {
      batch.set(firestore.collection('loyaltyTiers').doc(tier['id'] as String), tier);
    }
    await batch.commit();
    debugPrint('✅ Loyalty tiers initialized: ${tiers.length} tiers');
  }
  
  static Future<void> _initializePromotions(FirebaseFirestore firestore) async {
    final promos = [
      {
        'id': 'promo1',
        'title': 'Buy One Get One 50% Off',
        'description': 'On all specialty drinks',
        'discountPercent': 50,
        'code': 'BOGO50',
        'validUntil': DateTime.now().add(Duration(days: 30)).toIso8601String(),
        'applicable': true,
      },
      {
        'id': 'promo2',
        'title': '20% Off Friday',
        'description': 'Every Friday afternoon (3-6 PM)',
        'discountPercent': 20,
        'code': 'FRI20',
        'validUntil': DateTime.now().add(Duration(days: 60)).toIso8601String(),
        'applicable': true,
      },
      {
        'id': 'promo3',
        'title': 'Free Pastry with Drink',
        'description': 'Purchase any drink and get a free pastry',
        'discountPercent': 0,
        'code': 'FREEDESSERT',
        'validUntil': DateTime.now().add(Duration(days: 45)).toIso8601String(),
        'applicable': true,
      },
    ];
    
    final batch = firestore.batch();
    for (var promo in promos) {
      batch.set(firestore.collection('promotions').doc(promo['id'] as String), promo);
    }
    await batch.commit();
    debugPrint('✅ Promotions initialized: ${promos.length} promotions');
  }
}

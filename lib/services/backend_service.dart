import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Centralized Backend Service for all Firestore operations
class BackendService {
  static final BackendService _instance = BackendService._internal();
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  
  factory BackendService() {
    return _instance;
  }
  
  BackendService._internal();
  
  // ============== USER OPERATIONS ==============
  
  /// Create user profile document
  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String name,
  }) async {
    try {
      await firestore.collection('users').doc(userId).set({
        'id': userId,
        'email': email,
        'name': name,
        'role': 'customer',
        'loyaltyPoints': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      debugPrint('✅ User profile created: $userId');
    } catch (e) {
      debugPrint('❌ Error creating user profile: $e');
      rethrow;
    }
  }
  
  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      debugPrint('❌ Error fetching user profile: $e');
      return null;
    }
  }
  
  /// Update loyalty points
  Future<void> updateLoyaltyPoints(String userId, int points) async {
    try {
      // First, ensure user document exists
      final userDoc = firestore.collection('users').doc(userId);
      final snapshot = await userDoc.get();
      
      if (!snapshot.exists) {
        // Create user document if it doesn't exist
        await userDoc.set({
          'id': userId,
          'loyaltyPoints': points,
          'createdAt': DateTime.now().toIso8601String(),
        });
        debugPrint('✅ User document created for $userId with $points points');
      } else {
        // Update existing user document
        await userDoc.update({
          'loyaltyPoints': FieldValue.increment(points),
        });
        debugPrint('✅ Loyalty points updated: +$points for user $userId');
      }
    } catch (e) {
      debugPrint('❌ Error updating loyalty points: $e');
      rethrow;
    }
  }
  
  // ============== ORDER OPERATIONS ==============
  
  /// Create new order
  Future<String> createOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
    try {
      final orderRef = await firestore.collection('orders').add({
        'userId': userId,
        'items': items,
        'total': total,
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      // Award loyalty points (1 point per dollar spent)
      await updateLoyaltyPoints(userId, total.toInt());
      
      debugPrint('✅ Order created: ${orderRef.id}');
      return orderRef.id;
    } catch (e) {
      debugPrint('❌ Error creating order: $e');
      rethrow;
    }
  }
  
  /// Get all orders for user
  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      final snapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();
      
      final orders = snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
      
      // Sort by createdAt descending on client side
      orders.sort((a, b) {
        final dateA = DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime(1970);
        final dateB = DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });
      
      debugPrint('✅ Fetched ${orders.length} orders for user $userId');
      return orders;
    } catch (e) {
      debugPrint('❌ Error fetching orders: $e');
      return [];
    }
  }
  
  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      debugPrint('✅ Order status updated: $orderId -> $status');
    } catch (e) {
      debugPrint('❌ Error updating order status: $e');
      rethrow;
    }
  }
  
  // ============== MENU OPERATIONS ==============
  
  /// Get all menu items
  Future<List<Map<String, dynamic>>> getMenuItems() async {
    try {
      final snapshot = await firestore.collection('menu').get();
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching menu items: $e');
      return [];
    }
  }
  
  /// Get menu items by category
  Future<List<Map<String, dynamic>>> getMenuItemsByCategory(String category) async {
    try {
      final snapshot = await firestore
          .collection('menu')
          .where('category', isEqualTo: category)
          .get();
      
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching menu items by category: $e');
      return [];
    }
  }
  
  /// Search menu items
  Future<List<Map<String, dynamic>>> searchMenu(String query) async {
    try {
      final snapshot = await firestore.collection('menu').get();
      
      final filtered = snapshot.docs
          .where((doc) {
            final name = doc.data()['name'] ?? '';
            return name.toString().toLowerCase().contains(query.toLowerCase());
          })
          .map((doc) => {
            'id': doc.id,
            ...doc.data(),
          })
          .toList();
      
      return filtered;
    } catch (e) {
      debugPrint('❌ Error searching menu: $e');
      return [];
    }
  }
  
  /// Add new menu item
  Future<String> addMenuItem({
    required String name,
    required String category,
    required double price,
    String? description,
    String? image,
  }) async {
    try {
      final docRef = await firestore.collection('menu').add({
        'name': name,
        'category': category,
        'price': price,
        'description': description ?? '',
        'image': image ?? '',
        'available': true,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      debugPrint('✅ Menu item added: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error adding menu item: $e');
      rethrow;
    }
  }
  
  /// Update menu item
  Future<void> updateMenuItem({
    required String itemId,
    String? name,
    String? category,
    double? price,
    String? description,
    String? image,
    bool? available,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      if (name != null) updates['name'] = name;
      if (category != null) updates['category'] = category;
      if (price != null) updates['price'] = price;
      if (description != null) updates['description'] = description;
      if (image != null) updates['image'] = image;
      if (available != null) updates['available'] = available;
      
      await firestore.collection('menu').doc(itemId).update(updates);
      debugPrint('✅ Menu item updated: $itemId');
    } catch (e) {
      debugPrint('❌ Error updating menu item: $e');
      rethrow;
    }
  }
  
  /// Delete menu item
  Future<void> deleteMenuItem(String itemId) async {
    try {
      await firestore.collection('menu').doc(itemId).delete();
      debugPrint('✅ Menu item deleted: $itemId');
    } catch (e) {
      debugPrint('❌ Error deleting menu item: $e');
      rethrow;
    }
  }
  
  /// Toggle menu item availability
  Future<void> toggleMenuItemAvailability(String itemId, bool available) async {
    try {
      await firestore.collection('menu').doc(itemId).update({
        'available': available,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      debugPrint('✅ Menu item availability toggled: $itemId -> $available');
    } catch (e) {
      debugPrint('❌ Error toggling menu item availability: $e');
      rethrow;
    }
  }
  
  // ============== LOYALTY OPERATIONS ==============
  
  /// Get loyalty tiers
  Future<List<Map<String, dynamic>>> getLoyaltyTiers() async {
    try {
      final snapshot = await firestore.collection('loyaltyTiers').get();
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching loyalty tiers: $e');
      return [];
    }
  }
  
  /// Save custom preset
  Future<void> saveCustomPreset({
    required String userId,
    required String name,
    required Map<String, dynamic> customization,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('customPresets')
          .add({
        'name': name,
        'customization': customization,
        'createdAt': DateTime.now().toIso8601String(),
      });
      debugPrint('✅ Custom preset saved for user $userId');
    } catch (e) {
      debugPrint('❌ Error saving custom preset: $e');
      rethrow;
    }
  }
  
  /// Get custom presets
  Future<List<Map<String, dynamic>>> getCustomPresets(String userId) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('customPresets')
          .get();
      
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching custom presets: $e');
      return [];
    }
  }
  
  // ============== PROMOTION OPERATIONS ==============
  
  /// Get all active promotions
  Future<List<Map<String, dynamic>>> getActivePromotions() async {
    try {
      final now = DateTime.now().toIso8601String();
      final snapshot = await firestore
          .collection('promotions')
          .where('validUntil', isGreaterThan: now)
          .where('applicable', isEqualTo: true)
          .get();
      
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching promotions: $e');
      return [];
    }
  }
  
  /// Apply promo code
  Future<Map<String, dynamic>?> applyPromoCode(String code) async {
    try {
      final snapshot = await firestore
          .collection('promotions')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) {
        debugPrint('❌ Promo code not found: $code');
        return null;
      }
      
      return snapshot.docs.first.data();
    } catch (e) {
      debugPrint('❌ Error applying promo code: $e');
      return null;
    }
  }
  
  // ============== TRANSACTION OPERATIONS ==============
  
  /// Create transaction record
  Future<void> createTransaction({
    required String userId,
    required String type, // 'purchase', 'refund', 'adjustment'
    required double amount,
    String? description,
  }) async {
    try {
      await firestore.collection('transactions').add({
        'userId': userId,
        'type': type,
        'amount': amount,
        'description': description,
        'createdAt': DateTime.now().toIso8601String(),
      });
      debugPrint('✅ Transaction created: $type - \$$amount for user $userId');
    } catch (e) {
      debugPrint('❌ Error creating transaction: $e');
      rethrow;
    }
  }
  
  /// Get user transactions
  Future<List<Map<String, dynamic>>> getUserTransactions(String userId) async {
    try {
      final snapshot = await firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();
      
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching transactions: $e');
      return [];
    }
  }
  
  /// Get all orders (for owner dashboard)
  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final snapshot = await firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching all orders: $e');
      return [];
    }
  }
  
  // ============== ANALYTICS ==============
  
  /// Get user order summary
  Future<Map<String, dynamic>> getOrderSummary([String? userId]) async {
    try {
      // If no userId provided, get all orders (for owner)
      final List<Map<String, dynamic>> orders;
      if (userId == null) {
        orders = await getOrders();
      } else {
        orders = await getUserOrders(userId);
      }
      
      int totalOrders = orders.length;
      double totalSpent = 0;
      int completedOrders = 0;
      
      for (var order in orders) {
        totalSpent += (order['total'] as num?)?.toDouble() ?? 0;
        if (order['status'] == 'completed') {
          completedOrders++;
        }
      }
      
      return {
        'totalOrders': totalOrders,
        'totalSpent': totalSpent.toStringAsFixed(2),
        'completedOrders': completedOrders,
        'averageOrderValue': totalOrders > 0
            ? (totalSpent / totalOrders).toStringAsFixed(2)
            : '0.00',
      };
    } catch (e) {
      debugPrint('❌ Error generating order summary: $e');
      return {
        'totalOrders': 0,
        'totalSpent': '0.00',
        'completedOrders': 0,
        'averageOrderValue': '0.00',
      };
    }
  }
}

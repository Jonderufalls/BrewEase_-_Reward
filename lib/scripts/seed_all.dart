import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('🌱 Starting Complete Firestore Data Seeding...\n');
  
  final firestore = FirebaseFirestore.instance;
  
  try {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📍 Step 1: Seeding Users');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    await _seedUsers(firestore);
    
    print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📍 Step 2: Seeding Menu Items & Modifiers');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    await _seedMenu(firestore);
    
    print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📍 Step 3: Seeding Loyalty Programs');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    await _seedLoyalty(firestore);
    
    print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📍 Step 4: Seeding Promotions & Notifications');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    await _seedNotifications(firestore);
    
    print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📍 Step 5: Seeding Sample Orders/Transactions');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    await _seedTransactions(firestore);
    
    print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('✅ ALL DATA SEEDED SUCCESSFULLY!');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    print('Your Firestore database is now ready for UAT.');
    print('Test credentials:');
    print('  • Customer: customer@brewease.com');
    print('  • Owner: owner@brewease.com');
    print('  • Admin: admin@brewease.com\n');
  } catch (e) {
    print('❌ Error during seeding: $e');
  }
}

Future<void> _seedUsers(FirebaseFirestore firestore) async {
  await firestore.collection('users').doc('customer_1').set({
    'id': 'customer_1',
    'name': 'John Customer',
    'email': 'customer@brewease.com',
    'phone': '+63912345678',
    'role': 'customer',
    'avatar': null,
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  });
  print('✓ Customer user seeded');

  await firestore.collection('users').doc('owner_1').set({
    'id': 'owner_1',
    'name': 'Jane Owner',
    'email': 'owner@brewease.com',
    'phone': '+63987654321',
    'role': 'owner',
    'avatar': null,
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  });
  print('✓ Owner user seeded');

  await firestore.collection('users').doc('admin_1').set({
    'id': 'admin_1',
    'name': 'Admin User',
    'email': 'admin@brewease.com',
    'phone': '+63955555555',
    'role': 'admin',
    'avatar': null,
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  });
  print('✓ Admin user seeded');
}

Future<void> _seedMenu(FirebaseFirestore firestore) async {
  await firestore.collection('menus').doc('menu_1').set({
    'id': 'menu_1',
    'name': 'Espresso',
    'description': 'Rich and bold single shot espresso',
    'category': 'Coffee',
    'basePrice': 2.50,
    'images': [],
    'isAvailable': true,
    'isPopular': true,
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  });
  print('✓ Espresso menu item seeded');

  await firestore.collection('menus').doc('menu_2').set({
    'id': 'menu_2',
    'name': 'Cappuccino',
    'description': 'Creamy cappuccino with steamed milk',
    'category': 'Coffee',
    'basePrice': 3.50,
    'images': [],
    'isAvailable': true,
    'isPopular': true,
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  });
  print('✓ Cappuccino menu item seeded');

  await firestore.collection('menus').doc('menu_3').set({
    'id': 'menu_3',
    'name': 'Iced Latte',
    'description': 'Cold latte with ice',
    'category': 'Coffee',
    'basePrice': 4.00,
    'images': [],
    'isAvailable': true,
    'isPopular': false,
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  });
  print('✓ Iced Latte menu item seeded');

  await firestore.collection('modifiers').doc('mod_1').set({
    'id': 'mod_1',
    'name': 'Size',
    'type': 'single_select',
    'options': [
      {'id': 'size_small', 'name': 'Small', 'price': 0.0},
      {'id': 'size_medium', 'name': 'Medium', 'price': 0.5},
      {'id': 'size_large', 'name': 'Large', 'price': 1.0},
    ],
    'isRequired': true,
  });
  print('✓ Size modifier seeded');

  await firestore.collection('modifiers').doc('mod_2').set({
    'id': 'mod_2',
    'name': 'Extra Shots',
    'type': 'multiple_select',
    'options': [
      {'id': 'shot_1', 'name': '1 Extra Shot', 'price': 0.75},
      {'id': 'shot_2', 'name': '2 Extra Shots', 'price': 1.50},
    ],
    'isRequired': false,
  });
  print('✓ Extra Shots modifier seeded');

  await firestore.collection('priceVariants').doc('pv_1').set({
    'id': 'pv_1',
    'name': 'Weekend Premium',
    'basePrice': 3.00,
    'markup': 0.5,
    'isActive': true,
  });
  print('✓ Price variant seeded');
}

Future<void> _seedLoyalty(FirebaseFirestore firestore) async {
  await firestore.collection('rewardTiers').doc('tier_1').set({
    'id': 'tier_1',
    'name': 'Bronze Member',
    'minPoints': 0,
    'maxPoints': 999,
    'discountPercentage': 5.0,
    'createdAt': DateTime.now().toIso8601String(),
  });
  print('✓ Bronze tier seeded');

  await firestore.collection('rewardTiers').doc('tier_2').set({
    'id': 'tier_2',
    'name': 'Silver Member',
    'minPoints': 1000,
    'maxPoints': 4999,
    'discountPercentage': 10.0,
    'createdAt': DateTime.now().toIso8601String(),
  });
  print('✓ Silver tier seeded');

  await firestore.collection('rewardTiers').doc('tier_3').set({
    'id': 'tier_3',
    'name': 'Gold Member',
    'minPoints': 5000,
    'maxPoints': 999999,
    'discountPercentage': 15.0,
    'createdAt': DateTime.now().toIso8601String(),
  });
  print('✓ Gold tier seeded');

  await firestore.collection('vouchers').doc('voucher_1').set({
    'id': 'voucher_1',
    'code': 'WELCOME10',
    'description': 'Welcome voucher - 10% off',
    'discountType': 'percentage',
    'discountValue': 10.0,
    'minPurchaseAmount': 0.0,
    'expiryDate': DateTime.now().add(Duration(days: 365)).toIso8601String(),
    'isActive': true,
    'createdAt': DateTime.now().toIso8601String(),
  });
  print('✓ Welcome voucher seeded');

  await firestore.collection('vouchers').doc('voucher_2').set({
    'id': 'voucher_2',
    'code': 'FREECOFFEE',
    'description': 'Free coffee voucher',
    'discountType': 'fixed',
    'discountValue': 3.50,
    'minPurchaseAmount': 10.0,
    'expiryDate': DateTime.now().add(Duration(days: 180)).toIso8601String(),
    'isActive': true,
    'createdAt': DateTime.now().toIso8601String(),
  });
  print('✓ Free coffee voucher seeded');

  await firestore.collection('loyaltyAccounts').doc('loyalty_customer_1').set({
    'id': 'loyalty_customer_1',
    'userId': 'customer_1',
    'currentPoints': 250,
    'totalPointsEarned': 250,
    'tier': 'Bronze Member',
    'joinedDate': DateTime.now().toIso8601String(),
    'lastActivityDate': DateTime.now().toIso8601String(),
  });
  print('✓ Loyalty account for customer_1 seeded');
}

Future<void> _seedNotifications(FirebaseFirestore firestore) async {
  await firestore.collection('promos').doc('promo_1').set({
    'id': 'promo_1',
    'title': 'Monday Coffee Deal',
    'description': 'Get 20% off on all coffee beverages every Monday',
    'imageUrl': null,
    'discountPercentage': 20.0,
    'validFrom': DateTime.now().toIso8601String(),
    'validUntil': DateTime.now().add(Duration(days: 90)).toIso8601String(),
    'isActive': true,
    'createdAt': DateTime.now().toIso8601String(),
  });
  print('✓ Monday Coffee Deal promo seeded');

  await firestore.collection('promos').doc('promo_2').set({
    'id': 'promo_2',
    'title': 'Bundle Deal - Buy 3 Get 1 Free',
    'description': 'Buy any 3 beverages and get the 4th one for free',
    'imageUrl': null,
    'discountPercentage': 25.0,
    'validFrom': DateTime.now().toIso8601String(),
    'validUntil': DateTime.now().add(Duration(days: 60)).toIso8601String(),
    'isActive': true,
    'createdAt': DateTime.now().toIso8601String(),
  });
  print('✓ Bundle Deal promo seeded');

  await firestore.collection('pushNotifications').doc('notif_1').set({
    'id': 'notif_1',
    'title': 'Welcome to BrewEase Rewards!',
    'body': 'Start earning points with every purchase',
    'type': 'general',
    'imageUrl': null,
    'data': {},
    'createdAt': DateTime.now().toIso8601String(),
    'sentAt': DateTime.now().toIso8601String(),
    'isSent': true,
  });
  print('✓ Welcome notification seeded');

  await firestore.collection('pushNotifications').doc('notif_2').set({
    'id': 'notif_2',
    'title': 'Exclusive Offer for VIP Members',
    'body': 'Gold members get 15% off on all items this weekend',
    'type': 'promotion',
    'imageUrl': null,
    'data': {'promoId': 'promo_1'},
    'createdAt': DateTime.now().toIso8601String(),
    'sentAt': DateTime.now().toIso8601String(),
    'isSent': true,
  });
  print('✓ VIP offer notification seeded');
}

Future<void> _seedTransactions(FirebaseFirestore firestore) async {
  await firestore.collection('transactions').doc('txn_1').set({
    'id': 'txn_1',
    'customerId': 'customer_1',
    'items': [
      {
        'itemId': 'menu_1',
        'name': 'Espresso',
        'quantity': 2,
        'customizations': {'size': 'Medium'},
        'price': 2.50,
      }
    ],
    'totalAmount': 5.00,
    'status': 'pending',
    'paymentMethod': 'cash_on_pickup',
    'createdAt': DateTime.now().toIso8601String(),
    'completedAt': null,
    'notes': 'Test order 1',
  });
  print('✓ Transaction 1 seeded');

  await firestore.collection('transactions').doc('txn_2').set({
    'id': 'txn_2',
    'customerId': 'customer_1',
    'items': [
      {
        'itemId': 'menu_2',
        'name': 'Cappuccino',
        'quantity': 1,
        'customizations': {'size': 'Large', 'extraShots': '1'},
        'price': 3.50,
      },
      {
        'itemId': 'menu_3',
        'name': 'Iced Latte',
        'quantity': 1,
        'customizations': {'size': 'Medium'},
        'price': 4.00,
      }
    ],
    'totalAmount': 7.50,
    'status': 'completed',
    'paymentMethod': 'gcash',
    'createdAt': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    'completedAt': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    'notes': 'Test order 2 - completed',
  });
  print('✓ Transaction 2 seeded');

  await firestore.collection('transactions').doc('txn_3').set({
    'id': 'txn_3',
    'customerId': 'customer_1',
    'items': [
      {
        'itemId': 'menu_1',
        'name': 'Espresso',
        'quantity': 3,
        'customizations': {'size': 'Small'},
        'price': 2.50,
      }
    ],
    'totalAmount': 7.50,
    'status': 'cancelled',
    'paymentMethod': 'card',
    'createdAt': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
    'completedAt': null,
    'notes': 'Test order 3 - cancelled',
  });
  print('✓ Transaction 3 seeded');
}

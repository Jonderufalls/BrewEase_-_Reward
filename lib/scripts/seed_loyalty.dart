import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('🌱 Starting Loyalty Data Seeding...');
  
  final firestore = FirebaseFirestore.instance;
  
  try {
    // Seed Reward Tiers
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

    // Seed Vouchers
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

    // Seed Loyalty Accounts
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

    print('✅ Loyalty seeding completed successfully!');
  } catch (e) {
    print('❌ Error seeding loyalty: $e');
  }
}

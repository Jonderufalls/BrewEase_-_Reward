import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('🌱 Starting Notification Data Seeding...');
  
  final firestore = FirebaseFirestore.instance;
  
  try {
    // Seed Promotions
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

    // Seed Push Notifications
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

    print('✅ Notification seeding completed successfully!');
  } catch (e) {
    print('❌ Error seeding notifications: $e');
  }
}

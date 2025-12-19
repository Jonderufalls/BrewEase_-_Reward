import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('🌱 Starting Menu Data Seeding...');
  
  final firestore = FirebaseFirestore.instance;
  
  try {
    // Seed Menu Items
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

    // Seed Modifiers
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

    // Seed Price Variants
    await firestore.collection('priceVariants').doc('pv_1').set({
      'id': 'pv_1',
      'name': 'Weekend Premium',
      'basePrice': 3.00,
      'markup': 0.5,
      'isActive': true,
    });
    print('✓ Price variant seeded');

    print('✅ Menu seeding completed successfully!');
  } catch (e) {
    print('❌ Error seeding menu: $e');
  }
}

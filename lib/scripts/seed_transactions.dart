import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('🌱 Starting Transaction Data Seeding...');
  
  final firestore = FirebaseFirestore.instance;
  
  try {
    // Seed Orders/Transactions
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

    print('✅ Transaction seeding completed successfully!');
  } catch (e) {
    print('❌ Error seeding transactions: $e');
  }
}

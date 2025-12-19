import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  await Firebase.initializeApp();

  print('🌱 Starting User Data Seeding...');
  
  final firestore = FirebaseFirestore.instance;
  
  try {
    // Seed Customer Users
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

    // Seed Owner User
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

    // Seed Admin User
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

    print('✅ User seeding completed successfully!');
  } catch (e) {
    print('❌ Error seeding users: $e');
  }
}

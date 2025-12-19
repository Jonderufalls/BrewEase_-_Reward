import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'services/firestore_init_service.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
    
    // Initialize Firestore with sample data
    await FirestoreInitService.initializeFirestore();
  } catch (e) {
    debugPrint('❌ Firebase initialization error: $e');
  }
  
  runApp(
    const ProviderScope(
      child: BrewEaseApp(),
    ),
  );
}

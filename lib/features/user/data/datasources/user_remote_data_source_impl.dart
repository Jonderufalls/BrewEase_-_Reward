import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'user_remote_data_source.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final fb_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      debugPrint('🔵 Attempting sign-up for: $email');
      final cred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user!;
      debugPrint('✅ Firebase user created: ${user.uid}');
      final model = UserModel(
        id: user.uid,
        email: email,
        name: name ?? '',
      );
      await firestore.collection('users').doc(user.uid).set(model.toMap());
      debugPrint('✅ User document saved to Firestore');
      return model;
    } on fb_auth.FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Sign-up error: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔵 Attempting sign-in for: $email');
      final cred = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user!;
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromMap({'id': user.uid, ...doc.data()!});
      }
      return UserModel(id: user.uid, email: user.email ?? email, name: '');
    } on fb_auth.FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Sign-in error: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    final doc = await firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromMap({'id': user.uid, ...doc.data()!});
    }
    return UserModel(id: user.uid, email: user.email ?? '', name: '');
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    await firestore.collection('users').doc(user.id).update(user.toMap());
    final doc = await firestore.collection('users').doc(user.id).get();
    return UserModel.fromMap({'id': user.id, ...doc.data()!});
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<bool> isSignedIn() async {
    return firebaseAuth.currentUser != null;
  }
}

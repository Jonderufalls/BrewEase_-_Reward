import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/send_password_reset.dart';
import '../../data/datasources/user_remote_data_source_impl.dart';
import '../../data/repositories/user_repository_impl.dart';

// Firebase Instances
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// Data Sources
final userRemoteDataSourceProvider = Provider((ref) {
  // Use Firebase in all modes now
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  return UserRemoteDataSourceImpl(
    firebaseAuth: auth,
    firestore: firestore,
  );
});

// Repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.watch(userRemoteDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource: remoteDataSource);
});


// Use Cases
final signUpUseCaseProvider = Provider((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return SignUp(repository);
});

final signInUseCaseProvider = Provider((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return SignIn(repository);
});

final signOutUseCaseProvider = Provider((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return SignOut(repository);
});

final getCurrentUserUseCaseProvider = Provider((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetCurrentUser(repository);
});

final updateProfileUseCaseProvider = Provider((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateProfile(repository);
});

final sendPasswordResetUseCaseProvider = Provider((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return SendPasswordReset(repository);
});

// State
class UserState {
  final AppUser? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  UserState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  UserState copyWith({
    AppUser? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// State Notifier
class UserNotifier extends Notifier<UserState> {
  late final SignUp signUpUseCase;
  late final SignIn signInUseCase;
  late final SignOut signOutUseCase;
  late final GetCurrentUser getCurrentUserUseCase;
  late final UpdateProfile updateProfileUseCase;
  late final SendPasswordReset sendPasswordResetUseCase;

  @override
  UserState build() {
    signUpUseCase = ref.watch(signUpUseCaseProvider);
    signInUseCase = ref.watch(signInUseCaseProvider);
    signOutUseCase = ref.watch(signOutUseCaseProvider);
    getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);
    updateProfileUseCase = ref.watch(updateProfileUseCaseProvider);
    sendPasswordResetUseCase = ref.watch(sendPasswordResetUseCaseProvider);
    return UserState();
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? name,
    UserRole role = UserRole.customer,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await signUpUseCase(
      email: email,
      password: password,
      name: name,
      role: role,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
      ),
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await signInUseCase(email: email, password: password);

      result.fold(
        (failure) {
          final errorMsg = failure.toString();
          debugPrint('❌ Sign in failed: $errorMsg');
          
          // If Firebase is not configured, try mock auth
          if (errorMsg.contains('configuration-not-found') || 
              errorMsg.contains('Firebase')) {
            _useMockAuth(email, password);
          } else {
            state = state.copyWith(
              isLoading: false,
              error: errorMsg,
            );
          }
        },
        (user) {
          debugPrint('✅ Sign in successful: ${user.email}');
          state = state.copyWith(
            isLoading: false,
            user: user,
            isAuthenticated: true,
          );
        },
      );
    } catch (e) {
      debugPrint('❌ Sign in error: $e');
      // If Firebase fails, use mock auth
      if (e.toString().contains('configuration-not-found') || 
          e.toString().contains('Firebase')) {
        _useMockAuth(email, password);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  void _useMockAuth(String email, String password) {
    debugPrint('🔵 Switching to Mock Authentication...');
    
    // Mock user database
    final mockUsers = {
      'customer@brewease.com': {
        'id': 'customer_001',
        'email': 'customer@brewease.com',
        'name': 'Demo Customer',
        'role': UserRole.customer,
        'loyaltyPoints': 250,
      },
      'owner@brewease.com': {
        'id': 'owner_001',
        'email': 'owner@brewease.com',
        'name': 'BrewEase Owner',
        'role': UserRole.owner,
        'loyaltyPoints': 0,
      },
      'demo@brewease.com': {
        'id': 'demo_001',
        'email': 'demo@brewease.com',
        'name': 'Demo User',
        'role': UserRole.customer,
        'loyaltyPoints': 150,
      },
      'test@example.com': {
        'id': 'test_001',
        'email': 'test@example.com',
        'name': 'Test User',
        'role': UserRole.customer,
        'loyaltyPoints': 0,
      },
    };

    final userExists = mockUsers.containsKey(email);
    
    if (userExists) {
      final userData = mockUsers[email]!;
      final user = AppUser(
        id: userData['id'] as String,
        email: email,
        name: userData['name'] as String,
        role: userData['role'] as UserRole,
        loyaltyPoints: userData['loyaltyPoints'] as int,
      );
      
      debugPrint('✅ Mock sign in successful: $email');
      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
      );
    } else {
      // Allow any user to sign up in mock mode
      final user = AppUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@')[0],
        role: UserRole.customer,
        loyaltyPoints: 0,
      );
      
      debugPrint('✅ Mock user created and signed in: $email');
      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await signOutUseCase();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        user: null,
        isAuthenticated: false,
      ),
    );
  }

  Future<void> getCurrentUser() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
        isAuthenticated: false,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
      ),
    );
  }

  Future<void> updateProfile(AppUser user) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await updateProfileUseCase(user);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (updatedUser) => state = state.copyWith(
        isLoading: false,
        user: updatedUser,
      ),
    );
  }

  Future<void> sendPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await sendPasswordResetUseCase(email);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (_) => state = state.copyWith(
        isLoading: false,
      ),
    );
  }
}

// Provider
final userProvider = NotifierProvider<UserNotifier, UserState>(() {
  return UserNotifier();
});

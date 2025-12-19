import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';
import 'user_remote_data_source.dart';

/// Mock data source for testing without Firebase
/// Uses shared_preferences for persistent local storage
class MockUserDataSource implements UserRemoteDataSource {
  static final Map<String, UserModel> _mockUsers = {};
  static UserModel? _currentUser;

  /// Initialize users from persistent storage or use defaults
  static Future<void> initialize() async {
    // Always reload from storage to get fresh data
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('mock_users');

    debugPrint('🎭 Mock: Initializing from storage...');

    // First, always set up default accounts
    final defaultUsers = _getDefaultUsers();

    if (usersJson != null && usersJson.isNotEmpty) {
      // Load from persistent storage
      debugPrint('🎭 Mock: Loading users from persistent storage');
      try {
        _mockUsers.clear();
        final Map<String, dynamic> usersMap = jsonDecode(usersJson);
        usersMap.forEach((email, userJson) {
          _mockUsers[email] = UserModel.fromMap(userJson);
        });
        debugPrint('🎭 Mock: Loaded ${_mockUsers.length} users from storage');
        
        // Ensure default accounts are always available
        defaultUsers.forEach((email, user) {
          if (!_mockUsers.containsKey(email)) {
            debugPrint('🎭 Mock: Adding missing default account: $email');
            _mockUsers[email] = user;
          }
        });
      } catch (e) {
        debugPrint('❌ Mock: Error loading users: $e');
        _mockUsers.clear();
        _mockUsers.addAll(defaultUsers);
        await _persistUsers();
      }
    } else {
      // First time - initialize with demo accounts
      debugPrint('🎭 Mock: First time init - creating demo accounts');
      _mockUsers.clear();
      _mockUsers.addAll(defaultUsers);
      await _persistUsers();
    }

    debugPrint('🎭 Mock: Initialized with ${_mockUsers.length} users');
    debugPrint('🎭 Mock: Users in storage: ${_mockUsers.keys.toList()}');
  }

  static Map<String, UserModel> _getDefaultUsers() {
    return {
      'demo@brewease.com': UserModel(
        id: 'demo_user_001',
        email: 'demo@brewease.com',
        name: 'Demo User',
        role: UserRole.customer,
      ),
      'test@example.com': UserModel(
        id: 'test_user_001',
        email: 'test@example.com',
        name: 'Test User',
        role: UserRole.customer,
      ),
      'owner@brewease.com': UserModel(
        id: 'owner_user_001',
        email: 'owner@brewease.com',
        name: 'BrewEase Owner',
        role: UserRole.owner,
      ),
    };
  }

  static Future<void> _persistUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = jsonEncode(_mockUsers.map(
        (email, user) => MapEntry(email, user.toMap()),
      ));
      await prefs.setString('mock_users', usersJson);
    } catch (e) {
      debugPrint('❌ Mock: Error saving users: $e');
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    await initialize();
    await Future.delayed(const Duration(milliseconds: 500));

    if (_mockUsers.containsKey(email)) {
      throw Exception('User with this email already exists');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    debugPrint('🎭 Mock: Creating user: $email');

    final model = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name ?? '',
    );

    _mockUsers[email] = model;
    _currentUser = model;
    await _persistUsers();

    debugPrint('✅ Mock: User created and saved');
    return model;
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await initialize();
    await Future.delayed(const Duration(milliseconds: 500));

    debugPrint('🎭 Mock: Signing in user: $email');
    debugPrint('🎭 Mock: Available users: ${_mockUsers.keys.toList()}');

    if (!_mockUsers.containsKey(email)) {
      debugPrint('❌ Mock: User not found - $email');
      throw Exception('User not found');
    }

    final user = _mockUsers[email]!;
    _currentUser = user;

    debugPrint('✅ Mock: User signed in successfully: $email');
    return user;
  }

  @override
  Future<void> signOut() async {
    debugPrint('🎭 Mock: Signing out user');
    _currentUser = null;
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await initialize();
    debugPrint('🎭 Mock: Getting current user');
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    await initialize();
    debugPrint('🎭 Mock: Updating profile');
    await Future.delayed(const Duration(milliseconds: 300));
    if (_mockUsers.containsKey(user.email)) {
      _mockUsers[user.email] = user;
      _currentUser = user;
      await _persistUsers();
    }
    return user;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    debugPrint('🎭 Mock: Sending password reset to $email');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<bool> isSignedIn() async {
    return _currentUser != null;
  }
}

import 'package:dartz/dartz.dart';

import '../../core/failure.dart';
import '../entities/user.dart';

abstract class UserRepository {
  /// Sign up with email & password. Returns created AppUser on success.
  Future<Either<Failure, AppUser>> signUpWithEmail({
    required String email,
    required String password,
    String? name,
    UserRole role = UserRole.customer,
  });

  /// Sign in with email & password.
  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign out current user.
  Future<Either<Failure, void>> signOut();

  /// Returns current signed-in user or null if not signed in.
  Future<Either<Failure, AppUser?>> getCurrentUser();

  /// Update user profile details.
  Future<Either<Failure, AppUser>> updateProfile(AppUser user);

  /// Send password reset email.
  Future<Either<Failure, void>> sendPasswordReset(String email);

  /// Check if a user is currently signed in.
  Future<Either<Failure, bool>> isSignedIn();
}
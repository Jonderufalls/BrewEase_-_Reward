import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<UserModel> updateProfile(UserModel user);

  Future<void> sendPasswordReset(String email);

  Future<bool> isSignedIn();
}

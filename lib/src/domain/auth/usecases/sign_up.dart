import 'package:dartz/dartz.dart';

import '../../core/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignUp {
  final UserRepository repository;
  SignUp(this.repository);

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
    String? name,
    UserRole role = UserRole.customer,
  }) async {
    return await repository.signUpWithEmail(
      email: email,
      password: password,
      name: name,
      role: role,
    );
  }
}
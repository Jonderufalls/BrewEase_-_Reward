import 'package:dartz/dartz.dart';

import '../../core/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignIn {
  final UserRepository repository;
  SignIn(this.repository);

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
  }) async {
    return await repository.signInWithEmail(email: email, password: password);
  }
}
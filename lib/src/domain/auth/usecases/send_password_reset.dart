import 'package:dartz/dartz.dart';

import '../../core/failure.dart';
import '../repositories/user_repository.dart';

class SendPasswordReset {
  final UserRepository repository;
  SendPasswordReset(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.sendPasswordReset(email);
  }
}
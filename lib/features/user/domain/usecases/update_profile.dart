import 'package:dartz/dartz.dart';
import 'package:brewease_and_reward/core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateProfile {
  final UserRepository repository;
  UpdateProfile(this.repository);

  Future<Either<Failure, AppUser>> call(AppUser user) {
    return repository.updateProfile(user);
  }
}
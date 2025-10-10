import 'package:dartz/dartz.dart';

import '../../core/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateProfile {
  final UserRepository repository;
  UpdateProfile(this.repository);

  Future<Either<Failure, AppUser>> call(AppUser user) async {
    return await repository.updateProfile(user);
  }
}
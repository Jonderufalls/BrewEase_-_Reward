import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/loyalty_account.dart';
import '../repositories/loyalty_repository.dart';

class AddLoyaltyPoints {
  final LoyaltyRepository repository;

  AddLoyaltyPoints(this.repository);

  Future<Either<Failure, LoyaltyAccount>> call({
    required String userId,
    required int points,
  }) {
    return repository.addPoints(userId: userId, points: points);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/loyalty_account.dart';
import '../repositories/loyalty_repository.dart';

class GetLoyaltyAccount {
  final LoyaltyRepository repository;

  GetLoyaltyAccount(this.repository);

  Future<Either<Failure, LoyaltyAccount>> call(String userId) {
    return repository.getLoyaltyAccount(userId);
  }
}

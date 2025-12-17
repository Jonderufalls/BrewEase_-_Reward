import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/reward_tier.dart';
import '../repositories/loyalty_repository.dart';

class GetEligibleRewards {
  final LoyaltyRepository repository;

  GetEligibleRewards(this.repository);

  Future<Either<Failure, List<RewardTier>>> call(String userId) {
    return repository.getEligibleRewards(userId);
  }
}

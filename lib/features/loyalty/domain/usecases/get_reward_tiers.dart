import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/reward_tier.dart';
import '../repositories/loyalty_repository.dart';

class GetRewardTiers {
  final LoyaltyRepository repository;

  GetRewardTiers(this.repository);

  Future<Either<Failure, List<RewardTier>>> call() {
    return repository.getRewardTiers();
  }
}

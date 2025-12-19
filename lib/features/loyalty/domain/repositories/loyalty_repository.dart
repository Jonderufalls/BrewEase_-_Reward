import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/loyalty_account.dart';
import '../entities/reward_tier.dart';
import '../entities/voucher.dart';

abstract class LoyaltyRepository {
  /// Get loyalty account for a customer
  Future<Either<Failure, LoyaltyAccount>> getLoyaltyAccount(String userId);

  /// Add points to a customer's loyalty account (called after order completion)
  Future<Either<Failure, LoyaltyAccount>> addPoints({
    required String userId,
    required int points,
  });

  /// Redeem a voucher; returns updated loyalty account
  Future<Either<Failure, LoyaltyAccount>> redeemVoucher({
    required String userId,
    required String voucherId,
  });

  /// Get all available reward tiers
  Future<Either<Failure, List<RewardTier>>> getRewardTiers();

  /// Get a specific reward tier
  Future<Either<Failure, RewardTier>> getRewardTier(String tierId);

  /// Get all vouchers for a customer
  Future<Either<Failure, List<Voucher>>> getCustomerVouchers(String userId);

  /// Create a voucher when customer reaches a reward tier
  Future<Either<Failure, Voucher>> createVoucher({
    required String rewardTierId,
    required String userId,
  });

  /// Check if customer is eligible for any new reward tiers
  Future<Either<Failure, List<RewardTier>>> getEligibleRewards(String userId);
}

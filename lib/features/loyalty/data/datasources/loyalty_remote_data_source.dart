import '../models/loyalty_models.dart';

abstract class LoyaltyRemoteDataSource {
  Future<LoyaltyAccountModel> getLoyaltyAccount(String userId);

  Future<LoyaltyAccountModel> addPoints({
    required String userId,
    required int points,
  });

  Future<LoyaltyAccountModel> redeemVoucher({
    required String userId,
    required String voucherId,
  });

  Future<List<RewardTierModel>> getRewardTiers();

  Future<RewardTierModel> getRewardTier(String tierId);

  Future<List<VoucherModel>> getCustomerVouchers(String userId);

  Future<VoucherModel> createVoucher({
    required String rewardTierId,
    required String userId,
  });

  Future<List<RewardTierModel>> getEligibleRewards(String userId);
}

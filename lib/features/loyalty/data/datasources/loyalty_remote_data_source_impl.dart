import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/loyalty_models.dart';
import 'loyalty_remote_data_source.dart';

class LoyaltyRemoteDataSourceImpl implements LoyaltyRemoteDataSource {
  final FirebaseFirestore firestore;

  LoyaltyRemoteDataSourceImpl({required this.firestore});

  @override
  Future<LoyaltyAccountModel> getLoyaltyAccount(String userId) async {
    final doc = await firestore
        .collection('loyalty_accounts')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (doc.docs.isEmpty) {
      // Create new loyalty account if doesn't exist
      final newAccount = LoyaltyAccountModel(
        id: const Uuid().v4(),
        userId: userId,
        currentPoints: 0,
        totalPointsEarned: 0,
        redeemedVoucherIds: [],
        createdAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
      );
      await firestore
          .collection('loyalty_accounts')
          .doc(newAccount.id)
          .set(newAccount.toMap());
      return newAccount;
    }

    return LoyaltyAccountModel.fromMap({
      'id': doc.docs[0].id,
      ...doc.docs[0].data()
    });
  }

  @override
  Future<LoyaltyAccountModel> addPoints({
    required String userId,
    required int points,
  }) async {
    final account = await getLoyaltyAccount(userId);
    final updatedPoints = account.currentPoints + points;
    final updatedTotalPoints = account.totalPointsEarned + points;

    await firestore.collection('loyalty_accounts').doc(account.id).update({
      'currentPoints': updatedPoints,
      'totalPointsEarned': updatedTotalPoints,
      'lastUpdatedAt': DateTime.now().toIso8601String(),
    });

    return LoyaltyAccountModel(
      id: account.id,
      userId: userId,
      currentPoints: updatedPoints,
      totalPointsEarned: updatedTotalPoints,
      redeemedVoucherIds: account.redeemedVoucherIds,
      createdAt: account.createdAt,
      lastUpdatedAt: DateTime.now(),
    );
  }

  @override
  Future<LoyaltyAccountModel> redeemVoucher({
    required String userId,
    required String voucherId,
  }) async {
    final account = await getLoyaltyAccount(userId);
    final voucherDoc =
        await firestore.collection('vouchers').doc(voucherId).get();

    if (!voucherDoc.exists) throw Exception('Voucher not found');

    final voucherData = voucherDoc.data()!;
    final rewardTierId = voucherData['rewardTierId'] as String;
    final tierDoc =
        await firestore.collection('reward_tiers').doc(rewardTierId).get();
    final tierData = tierDoc.data()!;
    final rewardValue = (tierData['rewardValue'] as num).toInt();

    await firestore.collection('vouchers').doc(voucherId).update({
      'isRedeemed': true,
      'redeemedAt': DateTime.now().toIso8601String(),
    });

    final updatedAccount = LoyaltyAccountModel(
      id: account.id,
      userId: userId,
      currentPoints: (account.currentPoints - rewardValue).clamp(0, 999999),
      totalPointsEarned: account.totalPointsEarned,
      redeemedVoucherIds: [...account.redeemedVoucherIds, voucherId],
      createdAt: account.createdAt,
      lastUpdatedAt: DateTime.now(),
    );

    await firestore
        .collection('loyalty_accounts')
        .doc(account.id)
        .update(updatedAccount.toMap());

    return updatedAccount;
  }

  @override
  Future<List<RewardTierModel>> getRewardTiers() async {
    final snapshot = await firestore
        .collection('reward_tiers')
        .where('isActive', isEqualTo: true)
        .orderBy('pointsRequired')
        .get();

    return snapshot.docs
        .map((doc) =>
            RewardTierModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }

  @override
  Future<RewardTierModel> getRewardTier(String tierId) async {
    final doc =
        await firestore.collection('reward_tiers').doc(tierId).get();
    if (!doc.exists) throw Exception('Reward tier not found');
    return RewardTierModel.fromMap({'id': doc.id, ...doc.data()!});
  }

  @override
  Future<List<VoucherModel>> getCustomerVouchers(String userId) async {
    final snapshot = await firestore
        .collection('vouchers')
        .where('userId', isEqualTo: userId)
        .where('isRedeemed', isEqualTo: false)
        .where('expiresAt', isGreaterThan: DateTime.now().toIso8601String())
        .get();

    return snapshot.docs
        .map((doc) =>
            VoucherModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }

  @override
  Future<VoucherModel> createVoucher({
    required String rewardTierId,
    required String userId,
  }) async {
    final voucherId = const Uuid().v4();
    final expiresAt = DateTime.now().add(const Duration(days: 30));

    final voucher = VoucherModel(
      id: voucherId,
      rewardTierId: rewardTierId,
      userId: userId,
      code: 'VOUCHER-$voucherId',
      isRedeemed: false,
      createdAt: DateTime.now(),
      expiresAt: expiresAt,
    );

    await firestore
        .collection('vouchers')
        .doc(voucherId)
        .set(voucher.toMap());

    return voucher;
  }

  @override
  Future<List<RewardTierModel>> getEligibleRewards(String userId) async {
    final account = await getLoyaltyAccount(userId);
    final snapshot = await firestore
        .collection('reward_tiers')
        .where('isActive', isEqualTo: true)
        .where('pointsRequired',
            isLessThanOrEqualTo: account.currentPoints)
        .orderBy('pointsRequired', descending: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            RewardTierModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }
}

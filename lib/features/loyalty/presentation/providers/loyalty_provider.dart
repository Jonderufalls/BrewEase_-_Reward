import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/loyalty_account.dart';
import '../../domain/entities/reward_tier.dart';
import '../../domain/entities/voucher.dart';
import '../../domain/repositories/loyalty_repository.dart';
import '../../domain/usecases/get_loyalty_account.dart';
import '../../domain/usecases/add_loyalty_points.dart';
import '../../domain/usecases/redeem_voucher.dart';
import '../../domain/usecases/get_reward_tiers.dart';
import '../../domain/usecases/get_eligible_rewards.dart';
import '../../domain/usecases/get_customer_vouchers.dart';
import '../../data/datasources/loyalty_remote_data_source_impl.dart';
import '../../data/repositories/loyalty_repository_impl.dart';

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// Data Sources
final loyaltyRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return LoyaltyRemoteDataSourceImpl(firestore: firestore);
});

// Repository
final loyaltyRepositoryProvider = Provider<LoyaltyRepository>((ref) {
  final remoteDataSource = ref.watch(loyaltyRemoteDataSourceProvider);
  return LoyaltyRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Use Cases
final getLoyaltyAccountUseCaseProvider = Provider((ref) {
  final repository = ref.watch(loyaltyRepositoryProvider);
  return GetLoyaltyAccount(repository);
});

final addLoyaltyPointsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(loyaltyRepositoryProvider);
  return AddLoyaltyPoints(repository);
});

final redeemVoucherUseCaseProvider = Provider((ref) {
  final repository = ref.watch(loyaltyRepositoryProvider);
  return RedeemVoucher(repository);
});

final getRewardTiersUseCaseProvider = Provider((ref) {
  final repository = ref.watch(loyaltyRepositoryProvider);
  return GetRewardTiers(repository);
});

final getEligibleRewardsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(loyaltyRepositoryProvider);
  return GetEligibleRewards(repository);
});

final getCustomerVouchersUseCaseProvider = Provider((ref) {
  final repository = ref.watch(loyaltyRepositoryProvider);
  return GetCustomerVouchers(repository);
});

// State
class LoyaltyState {
  final LoyaltyAccount? loyaltyAccount;
  final List<RewardTier> rewardTiers;
  final List<Voucher> customerVouchers;
  final List<RewardTier> eligibleRewards;
  final bool isLoading;
  final String? error;

  LoyaltyState({
    this.loyaltyAccount,
    this.rewardTiers = const [],
    this.customerVouchers = const [],
    this.eligibleRewards = const [],
    this.isLoading = false,
    this.error,
  });

  LoyaltyState copyWith({
    LoyaltyAccount? loyaltyAccount,
    List<RewardTier>? rewardTiers,
    List<Voucher>? customerVouchers,
    List<RewardTier>? eligibleRewards,
    bool? isLoading,
    String? error,
  }) {
    return LoyaltyState(
      loyaltyAccount: loyaltyAccount ?? this.loyaltyAccount,
      rewardTiers: rewardTiers ?? this.rewardTiers,
      customerVouchers: customerVouchers ?? this.customerVouchers,
      eligibleRewards: eligibleRewards ?? this.eligibleRewards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// State Notifier
class LoyaltyNotifier extends Notifier<LoyaltyState> {
  late final GetLoyaltyAccount getLoyaltyAccountUseCase;
  late final AddLoyaltyPoints addLoyaltyPointsUseCase;
  late final RedeemVoucher redeemVoucherUseCase;
  late final GetRewardTiers getRewardTiersUseCase;
  late final GetEligibleRewards getEligibleRewardsUseCase;
  late final GetCustomerVouchers getCustomerVouchersUseCase;

  @override
  LoyaltyState build() {
    getLoyaltyAccountUseCase = ref.watch(getLoyaltyAccountUseCaseProvider);
    addLoyaltyPointsUseCase = ref.watch(addLoyaltyPointsUseCaseProvider);
    redeemVoucherUseCase = ref.watch(redeemVoucherUseCaseProvider);
    getRewardTiersUseCase = ref.watch(getRewardTiersUseCaseProvider);
    getEligibleRewardsUseCase = ref.watch(getEligibleRewardsUseCaseProvider);
    getCustomerVouchersUseCase = ref.watch(getCustomerVouchersUseCaseProvider);
    return LoyaltyState();
  }

  Future<void> fetchLoyaltyAccount(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getLoyaltyAccountUseCase(userId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (account) => state = state.copyWith(
        isLoading: false,
        loyaltyAccount: account,
      ),
    );
  }

  Future<void> addPoints({
    required String userId,
    required int points,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await addLoyaltyPointsUseCase(
      userId: userId,
      points: points,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (updatedAccount) => state = state.copyWith(
        isLoading: false,
        loyaltyAccount: updatedAccount,
      ),
    );
  }

  Future<void> redeemVoucher({
    required String userId,
    required String voucherId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await redeemVoucherUseCase(
      userId: userId,
      voucherId: voucherId,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (updatedAccount) => state = state.copyWith(
        isLoading: false,
        loyaltyAccount: updatedAccount,
      ),
    );
  }

  Future<void> fetchRewardTiers() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getRewardTiersUseCase();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (tiers) => state = state.copyWith(
        isLoading: false,
        rewardTiers: tiers,
      ),
    );
  }

  Future<void> fetchEligibleRewards(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getEligibleRewardsUseCase(userId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (rewards) => state = state.copyWith(
        isLoading: false,
        rewardTiers: rewards,
      ),
    );
  }

  Future<void> fetchCustomerVouchers(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getCustomerVouchersUseCase(userId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (vouchers) => state = state.copyWith(
        isLoading: false,
        customerVouchers: vouchers,
      ),
    );
  }
}

// Provider
final loyaltyProvider = NotifierProvider<LoyaltyNotifier, LoyaltyState>(() {
  return LoyaltyNotifier();
});

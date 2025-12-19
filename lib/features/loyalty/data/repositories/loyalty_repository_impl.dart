import 'package:dartz/dartz.dart';
import 'package:brewease_and_reward/core/error/failure.dart';
import 'package:brewease_and_reward/core/error/server_failure.dart' as server_failure;
import 'package:brewease_and_reward/features/loyalty/domain/entities/loyalty_account.dart';
import 'package:brewease_and_reward/features/loyalty/domain/entities/reward_tier.dart';
import 'package:brewease_and_reward/features/loyalty/domain/entities/voucher.dart';
import 'package:brewease_and_reward/features/loyalty/domain/repositories/loyalty_repository.dart';
import '../datasources/loyalty_remote_data_source.dart';

class LoyaltyRepositoryImpl implements LoyaltyRepository {
  final LoyaltyRemoteDataSource remoteDataSource;

  LoyaltyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LoyaltyAccount>> getLoyaltyAccount(
      String userId) async {
    try {
      final account = await remoteDataSource.getLoyaltyAccount(userId);
      return Right(account);
    } catch (e) {
      return Left(server_failure.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoyaltyAccount>> addPoints({
    required String userId,
    required int points,
  }) async {
    try {
      final updated =
          await remoteDataSource.addPoints(userId: userId, points: points);
      return Right(updated);
    } catch (e) {
      return Left(server_failure.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoyaltyAccount>> redeemVoucher({
    required String userId,
    required String voucherId,
  }) async {
    try {
      final updated = await remoteDataSource.redeemVoucher(
        userId: userId,
        voucherId: voucherId,
      );
      return Right(updated);
    } catch (e) {
      return Left(server_failure.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RewardTier>>> getRewardTiers() async {
    try {
      final tiers = await remoteDataSource.getRewardTiers();
      return Right(tiers);
    } catch (e) {
      return Left(server_failure.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RewardTier>> getRewardTier(String tierId) async {
    try {
      final tier = await remoteDataSource.getRewardTier(tierId);
      return Right(tier);
    } catch (e) {
      return Left(server_failure.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Voucher>>> getCustomerVouchers(
      String userId) async {
    try {
      final vouchers = await remoteDataSource.getCustomerVouchers(userId);
      return Right(vouchers);
    } catch (e) {
      return Left(server_failure.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Voucher>> createVoucher({
    required String rewardTierId,
    required String userId,
  }) async {
    try {
      final voucher = await remoteDataSource.createVoucher(
        rewardTierId: rewardTierId,
        userId: userId,
      );
      return Right(voucher);
    } catch (e) {
      return Left(server_failure.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RewardTier>>> getEligibleRewards(
      String userId) async {
    try {
      final rewards = await remoteDataSource.getEligibleRewards(userId);
      return Right(rewards);
    } catch (e) {
      return Left(server_failure.ServerFailure(e.toString()));
    }
  }
}

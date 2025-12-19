import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/loyalty_account.dart';
import '../repositories/loyalty_repository.dart';

class RedeemVoucher {
  final LoyaltyRepository repository;

  RedeemVoucher(this.repository);

  Future<Either<Failure, LoyaltyAccount>> call({
    required String userId,
    required String voucherId,
  }) {
    return repository.redeemVoucher(userId: userId, voucherId: voucherId);
  }
}

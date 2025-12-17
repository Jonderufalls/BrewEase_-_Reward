import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/voucher.dart';
import '../repositories/loyalty_repository.dart';

class GetCustomerVouchers {
  final LoyaltyRepository repository;

  GetCustomerVouchers(this.repository);

  Future<Either<Failure, List<Voucher>>> call(String userId) {
    return repository.getCustomerVouchers(userId);
  }
}

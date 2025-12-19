import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/order_repository.dart';

class CancelOrder {
  final OrderRepository repository;

  CancelOrder(this.repository);

  Future<Either<Failure, void>> call(String orderId) async {
    return await repository.cancelOrder(orderId);
  }
}

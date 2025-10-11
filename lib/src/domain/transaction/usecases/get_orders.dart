import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../../core/failure.dart';
import '../repositories/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call({
    required String userId,
    required bool isOwner,
  }) async {
    return isOwner
        ? await repository.getOrdersByOwner(userId)
        : await repository.getOrdersByCustomer(userId);
  }
}

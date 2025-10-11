import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../../core/failure.dart';
import '../repositories/order_repository.dart';

class GetOrderById {
  final OrderRepository repository;

  GetOrderById(this.repository);

  Future<Either<Failure, OrderEntity>> call(String orderId) async {
    return await repository.getOrderById(orderId);
  }
}

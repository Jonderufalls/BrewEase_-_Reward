import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../../core/failure.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder({
    required OrderEntity order,
  });

  Future<Either<Failure, List<OrderEntity>>> getOrdersByCustomer(String customerId);

  Future<Either<Failure, List<OrderEntity>>> getOrdersByOwner(String ownerId);

  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);

  Future<Either<Failure, void>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  });

  Future<Either<Failure, void>> cancelOrder(String orderId);
}

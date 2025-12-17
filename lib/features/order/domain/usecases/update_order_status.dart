import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/order_status.dart';
import '../repositories/order_repository.dart';

class UpdateOrderStatusParams {
  final String orderId;
  final OrderStatus status;
  final String? reason;

  UpdateOrderStatusParams({
    required this.orderId,
    required this.status,
    this.reason,
  });
}

class UpdateOrderStatus {
  final OrderRepository repository;

  UpdateOrderStatus(this.repository);

  Future<Either<Failure, Unit>> call(UpdateOrderStatusParams params) {
    return repository.updateOrderStatus(
      orderId: params.orderId,
      status: params.status,
      reason: params.reason,
    );
  }
}
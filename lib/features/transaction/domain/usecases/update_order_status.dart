import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../../../../core/error/failure.dart';
import '../repositories/order_repository.dart';

class UpdateOrderStatus {
  final OrderRepository repository;

  UpdateOrderStatus(this.repository);

  Future<Either<Failure, void>> call({
    required String orderId,
    required OrderStatus status,
  }) async {
    return await repository.updateOrderStatus(orderId: orderId, status: status);
  }
}

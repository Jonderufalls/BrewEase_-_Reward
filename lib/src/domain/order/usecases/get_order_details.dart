import 'package:dartz/dartz.dart' as dartz;

import '../../core/failure.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrderDetails {
  final OrderRepository repository;

  GetOrderDetails(this.repository);

  Future<dartz.Either<Failure, Order>> call(String orderId) {
    return repository.getOrder(orderId);
  }
}
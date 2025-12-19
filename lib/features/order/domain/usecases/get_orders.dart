import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../entities/order.dart';
import '../entities/order_status.dart';
import '../repositories/order_repository.dart';

class GetOrdersParams {
  final OrderStatus? status;
  final DateTime? from;
  final DateTime? to;
  final String? query;
  final int? limit;
  final int? offset;

  GetOrdersParams({
    this.status,
    this.from,
    this.to,
    this.query,
    this.limit,
    this.offset,
  });
}

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Future<dartz.Either<Failure, List<Order>>> call(GetOrdersParams params) {
    return repository.getOrders(
      status: params.status,
      from: params.from,
      to: params.to,
      query: params.query,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
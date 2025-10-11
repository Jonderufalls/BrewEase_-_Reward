import 'package:dartz/dartz.dart';

import '../../core/failure.dart';
import '../entities/order.dart';
import '../entities/order_status.dart';
import '../entities/order_summary.dart';

abstract class OrderRepository {
  /// Retrieve a list of orders with optional filters (status, date range, query, pagination)
  Future<Either<Failure, List<Order>>> getOrders({
    OrderStatus? status,
    DateTime? from,
    DateTime? to,
    String? query,
    int? limit,
    int? offset,
  });

  /// Retrieve full details for a single order
  Future<Either<Failure, Order>> getOrder(String orderId);

  /// Update order status (accept, preparing, ready, completed, cancelled). Reason optional for cancellations.
  Future<Either<Failure, Unit>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? reason,
  });

  /// Get summary for a day or range (can be implemented as daily summary)
  Future<Either<Failure, OrderSummary>> getSummary({required DateTime date});

  /// Export orders CSV for a date range; returns CSV content or a storage URL depending on impl
  Future<Either<Failure, String>> exportOrdersCsv({
    required DateTime from,
    required DateTime to,
  });
}
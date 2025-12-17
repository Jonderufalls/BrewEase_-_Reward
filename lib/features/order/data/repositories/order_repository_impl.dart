import 'package:dartz/dartz.dart' as dartz;
import 'package:brewease_and_reward/core/error/failure.dart';
import 'package:brewease_and_reward/core/error/server_failure.dart' as server_failure;
import 'package:brewease_and_reward/features/order/domain/entities/order.dart';
import 'package:brewease_and_reward/features/order/domain/entities/order_status.dart';
import 'package:brewease_and_reward/features/order/domain/entities/order_summary.dart';
import 'package:brewease_and_reward/features/order/domain/repositories/order_repository.dart';
import 'package:brewease_and_reward/features/order/data/datasources/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<dartz.Either<Failure, List<Order>>> getOrders({
    OrderStatus? status,
    DateTime? from,
    DateTime? to,
    String? query,
    int? limit,
    int? offset,
  }) async {
    try {
      final orders = await remoteDataSource.getOrders(
        status: status,
        from: from,
        to: to,
        query: query,
        limit: limit,
        offset: offset,
      );
      return dartz.Right(orders.map((model) => model.toDomain()).toList());
    } catch (e) {
      return dartz.Left(server_failure.ServerFailure(e.toString()));
    }
  }

  @override
  Future<dartz.Either<Failure, Order>> getOrder(String orderId) async {
    try {
      final order = await remoteDataSource.getOrder(orderId);
      return dartz.Right(order.toDomain());
    } catch (e) {
      return dartz.Left(server_failure.ServerFailure(e.toString()));
    }
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? reason,
  }) async {
    try {
      await remoteDataSource.updateOrderStatus(
        orderId: orderId,
        status: status,
        reason: reason,
      );
      return const dartz.Right(dartz.unit);
    } catch (e) {
      return dartz.Left(server_failure.ServerFailure(e.toString()));
    }
  }

  @override
  Future<dartz.Either<Failure, OrderSummary>> getSummary(
      {required DateTime date}) async {
    try {
      final summary = await remoteDataSource.getSummary(date: date);
      final summaryModel = OrderSummary(
        date: date,
        orderCount: (summary['totalOrders'] as num).toInt(),
        salesTotal: (summary['totalSales'] as num).toDouble(),
        topItems: (summary['topItems'] as Map<String, dynamic>?)
                ?.cast<String, int>() ??
            {},
        loyaltyRedemptions:
            (summary['loyaltyRedemptions'] as num?)?.toInt() ?? 0,
      );
      return dartz.Right(summaryModel);
    } catch (e) {
      return dartz.Left(server_failure.ServerFailure(e.toString()));
    }
  }

  @override
  Future<dartz.Either<Failure, String>> exportOrdersCsv({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final csv =
          await remoteDataSource.exportOrdersCsv(from: from, to: to);
      return dartz.Right(csv);
    } catch (e) {
      return dartz.Left(server_failure.ServerFailure(e.toString()));
    }
  }
}

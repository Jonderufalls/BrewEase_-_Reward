import 'package:dartz/dartz.dart' as dartz;
import 'package:brewease_and_reward/core/error/failure.dart';
import 'package:brewease_and_reward/core/error/server_failure.dart' as server_failure;
import 'package:brewease_and_reward/features/order/domain/entities/order.dart';
import 'package:brewease_and_reward/features/order/domain/entities/order_status.dart';
import 'package:brewease_and_reward/features/transaction/data/datasources/transaction_remote_data_source.dart';
import 'package:brewease_and_reward/features/transaction/data/models/order_entity_model.dart';

class TransactionRepositoryImpl {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  Future<dartz.Either<Failure, Order>> createOrder({
    required Order order,
  }) async {
    try {
      final model = OrderEntityModel.fromDomain(order);
      await remoteDataSource.createOrder(order: model);
      return dartz.Right(order);
    } catch (e) {
      return dartz.Left(server_failure.ServerFailure(e.toString()));
    }
  }

  Future<dartz.Either<Failure, List<Order>>> getOrdersByCustomer(
      String customerId) async {
    try {
      final models =
          await remoteDataSource.getOrdersByCustomer(customerId);
      return dartz.Right(models.map((m) => m.toDomain()).toList());
    } catch (e) {
      return dartz.Left(server_failure.ServerFailure(e.toString()));
    }
  }

  Future<dartz.Either<Failure, List<Order>>> getOrdersByOwner(
      String ownerId) async {
    try {
      final models = await remoteDataSource.getOrdersByOwner(ownerId);
      return dartz.Right(models.map((m) => m.toDomain()).toList());
    } catch (e) {
      return dartz.Left(server_failure.ServerFailure(e.toString()));
    }
  }

  Future<dartz.Either<Failure, Order>> getOrderById(String orderId) async {
    try {
      final model = await remoteDataSource.getOrderById(orderId);
      return dartz.Right(model.toDomain());
    } catch (e) {
      return dartz.Left(server_failure.ServerFailure(e.toString()));
    }
  }

  Future<dartz.Either<Failure, void>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      await remoteDataSource.updateOrderStatus(
        orderId: orderId,
        status: status,
      );
      return const dartz.Right(null);
    } catch (e) {
      return dartz.Left(server_failure.ServerFailure(e.toString()));
    }
  }

  Future<dartz.Either<Failure, void>> cancelOrder(String orderId) async {
    try {
      await remoteDataSource.cancelOrder(orderId);
      return const dartz.Right(null);
    } catch (e) {
      return dartz.Left(server_failure.ServerFailure(e.toString()));
    }
  }
}

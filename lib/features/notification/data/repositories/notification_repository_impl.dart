import 'package:dartz/dartz.dart';
import 'package:brewease_and_reward/core/error/failure.dart';
import 'package:brewease_and_reward/features/notification/domain/entities/promo.dart';
import 'package:brewease_and_reward/features/notification/domain/entities/push_notification.dart';
import 'package:brewease_and_reward/features/notification/domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/notification_models.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PushNotification>> sendNotificationToAll({
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      final notification = await remoteDataSource.sendNotificationToAll(
        title: title,
        body: body,
        imageUrl: imageUrl,
        data: data,
      );
      return Right(notification);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PushNotification>> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      final notification = await remoteDataSource.sendNotificationToUser(
        userId: userId,
        title: title,
        body: body,
        imageUrl: imageUrl,
        data: data,
      );
      return Right(notification);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Promo>>> getActivePromos() async {
    try {
      final promos = await remoteDataSource.getActivePromos();
      return Right(promos);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Promo>> getPromoById(String promoId) async {
    try {
      final promo = await remoteDataSource.getPromoById(promoId);
      return Right(promo);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Promo>> createPromo(Promo promo) async {
    try {
      final created = await remoteDataSource.createPromo(promo as PromoModel);
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Promo>> updatePromo(Promo promo) async {
    try {
      final updated = await remoteDataSource.updatePromo(promo as PromoModel);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deactivatePromo(String promoId) async {
    try {
      await remoteDataSource.deactivatePromo(promoId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PushNotification>>> getNotificationHistory(
      String userId) async {
    try {
      final notifications =
          await remoteDataSource.getNotificationHistory(userId);
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> markNotificationAsRead(
      String notificationId) async {
    try {
      await remoteDataSource.markNotificationAsRead(notificationId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

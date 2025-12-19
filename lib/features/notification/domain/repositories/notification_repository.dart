import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/promo.dart';
import '../entities/push_notification.dart';

abstract class NotificationRepository {
  /// Send push notification to all users
  Future<Either<Failure, PushNotification>> sendNotificationToAll({
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  });

  /// Send push notification to specific user
  Future<Either<Failure, PushNotification>> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  });

  /// Get all active promos
  Future<Either<Failure, List<Promo>>> getActivePromos();

  /// Get promo by ID
  Future<Either<Failure, Promo>> getPromoById(String promoId);

  /// Create a new promo (owner only)
  Future<Either<Failure, Promo>> createPromo(Promo promo);

  /// Update existing promo (owner only)
  Future<Either<Failure, Promo>> updatePromo(Promo promo);

  /// Deactivate promo (owner only)
  Future<Either<Failure, Unit>> deactivatePromo(String promoId);

  /// Get notification history for a user
  Future<Either<Failure, List<PushNotification>>> getNotificationHistory(String userId);

  /// Mark notification as read
  Future<Either<Failure, Unit>> markNotificationAsRead(String notificationId);
}

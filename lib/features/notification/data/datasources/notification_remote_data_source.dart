import '../models/notification_models.dart';

abstract class NotificationRemoteDataSource {
  Future<PushNotificationModel> sendNotificationToAll({
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  });

  Future<PushNotificationModel> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  });

  Future<List<PromoModel>> getActivePromos();

  Future<PromoModel> getPromoById(String promoId);

  Future<PromoModel> createPromo(PromoModel promo);

  Future<PromoModel> updatePromo(PromoModel promo);

  Future<void> deactivatePromo(String promoId);

  Future<List<PushNotificationModel>> getNotificationHistory(String userId);

  Future<void> markNotificationAsRead(String notificationId);
}

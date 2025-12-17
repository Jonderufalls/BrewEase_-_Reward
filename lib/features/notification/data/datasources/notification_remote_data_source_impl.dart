import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:brewease_and_reward/features/notification/domain/entities/push_notification.dart';
import '../models/notification_models.dart';
import 'notification_remote_data_source.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSourceImpl({required this.firestore});

  @override
  Future<PushNotificationModel> sendNotificationToAll({
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    final notifId = const Uuid().v4();
    final notification = PushNotificationModel(
      id: notifId,
      title: title,
      body: body,
      type: NotificationType.general,
      imageUrl: imageUrl,
      data: data,
      createdAt: DateTime.now(),
      sentAt: DateTime.now(),
      isSent: true,
    );

    await firestore
        .collection('notifications')
        .doc(notifId)
        .set(notification.toMap());

    // TODO: Send to FCM for all users
    return notification;
  }

  @override
  Future<PushNotificationModel> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    final notifId = const Uuid().v4();
    final notification = PushNotificationModel(
      id: notifId,
      title: title,
      body: body,
      type: NotificationType.general,
      imageUrl: imageUrl,
      data: data,
      createdAt: DateTime.now(),
      sentAt: DateTime.now(),
      isSent: true,
    );

    await firestore
        .collection('user_notifications')
        .doc(userId)
        .collection('notifications')
        .doc(notifId)
        .set(notification.toMap());

    // TODO: Send to FCM for specific user
    return notification;
  }

  @override
  Future<List<PromoModel>> getActivePromos() async {
    final now = DateTime.now();
    final snapshot = await firestore
        .collection('promos')
        .where('isActive', isEqualTo: true)
        .where('startDate', isLessThanOrEqualTo: now.toIso8601String())
        .where('endDate', isGreaterThanOrEqualTo: now.toIso8601String())
        .get();

    return snapshot.docs
        .map((doc) =>
            PromoModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }

  @override
  Future<PromoModel> getPromoById(String promoId) async {
    final doc = await firestore.collection('promos').doc(promoId).get();
    if (!doc.exists) throw Exception('Promo not found');
    return PromoModel.fromMap({'id': doc.id, ...doc.data()!});
  }

  @override
  Future<PromoModel> createPromo(PromoModel promo) async {
    await firestore
        .collection('promos')
        .doc(promo.id)
        .set(promo.toMap());
    return promo;
  }

  @override
  Future<PromoModel> updatePromo(PromoModel promo) async {
    await firestore
        .collection('promos')
        .doc(promo.id)
        .update(promo.toMap());
    return promo;
  }

  @override
  Future<void> deactivatePromo(String promoId) async {
    await firestore.collection('promos').doc(promoId).update({
      'isActive': false,
    });
  }

  @override
  Future<List<PushNotificationModel>> getNotificationHistory(
      String userId) async {
    final snapshot = await firestore
        .collection('user_notifications')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) =>
            PushNotificationModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    // TODO: Implement marking notification as read per user
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/push_notification.dart';
import '../repositories/notification_repository.dart';

class SendNotificationToUser {
  final NotificationRepository repository;

  SendNotificationToUser(this.repository);

  Future<Either<Failure, PushNotification>> call({
    required String userId,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) {
    return repository.sendNotificationToUser(
      userId: userId,
      title: title,
      body: body,
      imageUrl: imageUrl,
      data: data,
    );
  }
}

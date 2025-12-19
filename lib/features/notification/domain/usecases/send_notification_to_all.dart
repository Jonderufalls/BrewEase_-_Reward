import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/push_notification.dart';
import '../repositories/notification_repository.dart';

class SendNotificationToAll {
  final NotificationRepository repository;

  SendNotificationToAll(this.repository);

  Future<Either<Failure, PushNotification>> call({
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) {
    return repository.sendNotificationToAll(
      title: title,
      body: body,
      imageUrl: imageUrl,
      data: data,
    );
  }
}

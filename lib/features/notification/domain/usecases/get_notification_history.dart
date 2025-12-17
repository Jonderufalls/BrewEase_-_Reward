import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/push_notification.dart';
import '../repositories/notification_repository.dart';

class GetNotificationHistory {
  final NotificationRepository repository;

  GetNotificationHistory(this.repository);

  Future<Either<Failure, List<PushNotification>>> call(String userId) {
    return repository.getNotificationHistory(userId);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/promo.dart';
import '../repositories/notification_repository.dart';

class GetActivePromos {
  final NotificationRepository repository;

  GetActivePromos(this.repository);

  Future<Either<Failure, List<Promo>>> call() {
    return repository.getActivePromos();
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/promo.dart';
import '../repositories/notification_repository.dart';

class CreatePromo {
  final NotificationRepository repository;

  CreatePromo(this.repository);

  Future<Either<Failure, Promo>> call(Promo promo) {
    return repository.createPromo(promo);
  }
}

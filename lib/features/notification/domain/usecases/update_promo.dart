import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/promo.dart';
import '../repositories/notification_repository.dart';

class UpdatePromo {
  final NotificationRepository repository;

  UpdatePromo(this.repository);

  Future<Either<Failure, Promo>> call(Promo promo) {
    return repository.updatePromo(promo);
  }
}

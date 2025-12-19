import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';

class GetMenuItem {
  final MenuRepository repository;

  GetMenuItem(this.repository);

  Future<Either<Failure, MenuItem>> call(String itemId) {
    return repository.getMenuItem(itemId);
  }
}
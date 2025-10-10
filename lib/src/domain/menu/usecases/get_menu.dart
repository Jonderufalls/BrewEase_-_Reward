import 'package:dartz/dartz.dart';
import '../../core/failure.dart';
import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';

class GetMenu {
  final MenuRepository repository;

  GetMenu(this.repository);

  Future<Either<Failure, List<MenuItem>>> call(String storeId) {
    return repository.getMenu(storeId);
  }
}
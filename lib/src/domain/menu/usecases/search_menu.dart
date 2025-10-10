import 'package:dartz/dartz.dart';
import '../../core/failure.dart';
import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';

class SearchMenu {
  final MenuRepository repository;

  SearchMenu(this.repository);

  Future<Either<Failure, List<MenuItem>>> call({
    required String storeId,
    required String query,
  }) {
    return repository.searchMenu(storeId: storeId, query: query);
  }
}
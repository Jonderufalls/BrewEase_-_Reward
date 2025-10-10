import 'package:dartz/dartz.dart';
import '../../core/failure.dart';
import '../entities/custom_preset.dart';
import '../repositories/menu_repository.dart';

class GetCustomPresets {
  final MenuRepository repository;

  GetCustomPresets(this.repository);

  Future<Either<Failure, List<CustomPreset>>> call({
    required String userId,
    String? storeId,
  }) {
    return repository.getCustomPresets(userId: userId, storeId: storeId);
  }
}
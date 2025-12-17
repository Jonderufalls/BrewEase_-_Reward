import 'package:dartz/dartz.dart';
import 'package:brewease_and_reward/core/error/failure.dart';
import '../repositories/menu_repository.dart';

class DeleteCustomPreset {
  final MenuRepository repository;

  DeleteCustomPreset(this.repository);

  Future<Either<Failure, Unit>> call({
    required String presetId,
    required String userId,
  }) {
    return repository.deleteCustomPreset(presetId, userId);
  }
}
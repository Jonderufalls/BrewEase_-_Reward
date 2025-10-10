import 'package:dartz/dartz.dart';
import '../../core/failure.dart';
import '../entities/custom_preset.dart';
import '../repositories/menu_repository.dart';

class SaveCustomPreset {
  final MenuRepository repository;

  SaveCustomPreset(this.repository);

  Future<Either<Failure, CustomPreset>> call(CustomPreset preset) {
    return repository.saveCustomPreset(preset);
  }
}
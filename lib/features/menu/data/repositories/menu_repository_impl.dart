import 'package:dartz/dartz.dart';
import 'package:brewease_and_reward/core/error/failure.dart';
import 'package:brewease_and_reward/features/menu/domain/entities/menu_item.dart';
import 'package:brewease_and_reward/features/menu/domain/entities/custom_preset.dart';
import 'package:brewease_and_reward/features/menu/domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_data_source.dart';
import '../models/custom_preset_model.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MenuItem>>> getMenu(String storeId) async {
    try {
      final items = await remoteDataSource.getMenu(storeId);
      return Right(items.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MenuItem>> getMenuItem(String itemId) async {
    try {
      final item = await remoteDataSource.getMenuItem(itemId);
      return Right(item.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MenuItem>>> searchMenu({
    required String storeId,
    required String query,
  }) async {
    try {
      final items =
          await remoteDataSource.searchMenu(storeId: storeId, query: query);
      return Right(items.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomPreset>> saveCustomPreset(
      CustomPreset preset) async {
    try {
      final saved =
          await remoteDataSource.saveCustomPreset(preset as CustomPresetModel);
      return Right(saved);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCustomPreset(
      String presetId, String userId) async {
    try {
      await remoteDataSource.deleteCustomPreset(presetId, userId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CustomPreset>>> getCustomPresets({
    required String userId,
    String? storeId,
  }) async {
    try {
      final presets = await remoteDataSource.getCustomPresets(
        userId: userId,
        storeId: storeId,
      );
      return Right(presets);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

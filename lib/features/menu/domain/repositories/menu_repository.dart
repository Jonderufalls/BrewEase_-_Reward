import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/menu_item.dart';
import '../entities/custom_preset.dart';

abstract class MenuRepository {
  /// Fetch full menu for a store
  Future<Either<Failure, List<MenuItem>>> getMenu(String storeId);

  /// Fetch single menu item details
  Future<Either<Failure, MenuItem>> getMenuItem(String itemId);

  /// Search menu for a store
  Future<Either<Failure, List<MenuItem>>> searchMenu({
    required String storeId,
    required String query,
  });

  /// Save a user's custom preset
  Future<Either<Failure, CustomPreset>> saveCustomPreset(CustomPreset preset);

  /// Delete a user's custom preset
  /// Returns Unit on success
  Future<Either<Failure, Unit>> deleteCustomPreset(String presetId, String userId);

  /// Get all saved presets for a user (optionally scoped to store)
  Future<Either<Failure, List<CustomPreset>>> getCustomPresets({
    required String userId,
    String? storeId,
  });
}
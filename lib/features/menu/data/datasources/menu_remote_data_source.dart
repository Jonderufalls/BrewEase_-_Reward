import '../models/menu_item_model.dart';
import '../models/custom_preset_model.dart';

abstract class MenuRemoteDataSource {
  Future<List<MenuItemModel>> getMenu(String storeId);

  Future<MenuItemModel> getMenuItem(String itemId);

  Future<List<MenuItemModel>> searchMenu({
    required String storeId,
    required String query,
  });

  Future<CustomPresetModel> saveCustomPreset(CustomPresetModel preset);

  Future<void> deleteCustomPreset(String presetId, String userId);

  Future<List<CustomPresetModel>> getCustomPresets({
    required String userId,
    String? storeId,
  });
}

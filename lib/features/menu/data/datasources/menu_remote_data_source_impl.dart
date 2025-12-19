import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item_model.dart';
import '../models/custom_preset_model.dart';
import 'menu_remote_data_source.dart';

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final FirebaseFirestore firestore;

  MenuRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<MenuItemModel>> getMenu(String storeId) async {
    final snapshot = await firestore
        .collection('menus')
        .where('storeId', isEqualTo: storeId)
        .where('isAvailable', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) =>
            MenuItemModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }

  @override
  Future<MenuItemModel> getMenuItem(String itemId) async {
    final doc = await firestore.collection('menus').doc(itemId).get();
    if (!doc.exists) throw Exception('Menu item not found');
    return MenuItemModel.fromMap({'id': doc.id, ...doc.data()!});
  }

  @override
  Future<List<MenuItemModel>> searchMenu({
    required String storeId,
    required String query,
  }) async {
    final snapshot = await firestore
        .collection('menus')
        .where('storeId', isEqualTo: storeId)
        .where('isAvailable', isEqualTo: true)
        .get();
    final lowerQuery = query.toLowerCase();
    return snapshot.docs
        .where((doc) =>
            doc['name'].toString().toLowerCase().contains(lowerQuery) ||
            doc['description'].toString().toLowerCase().contains(lowerQuery))
        .map((doc) =>
            MenuItemModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }

  @override
  Future<CustomPresetModel> saveCustomPreset(CustomPresetModel preset) async {
    final docRef = firestore.collection('custom_presets').doc(preset.id);
    await docRef.set(preset.toMap());
    return preset;
  }

  @override
  Future<void> deleteCustomPreset(String presetId, String userId) async {
    await firestore.collection('custom_presets').doc(presetId).delete();
  }

  @override
  Future<List<CustomPresetModel>> getCustomPresets({
    required String userId,
    String? storeId,
  }) async {
    var query = firestore
        .collection('custom_presets')
        .where('userId', isEqualTo: userId);

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) =>
            CustomPresetModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }
}

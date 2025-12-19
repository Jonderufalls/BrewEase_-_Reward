import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/menu_item.dart';
import '../../domain/entities/custom_preset.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../domain/usecases/get_menu.dart';
import '../../domain/usecases/get_menu_item.dart';
import '../../domain/usecases/search_menu.dart';
import '../../domain/usecases/save_custom_preset.dart';
import '../../domain/usecases/delete_custom_preset.dart';
import '../../domain/usecases/get_custom_presets.dart';
import '../../data/datasources/menu_remote_data_source_impl.dart';
import '../../data/repositories/menu_repository_impl.dart';

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// Data Sources
final menuRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return MenuRemoteDataSourceImpl(firestore: firestore);
});

// Repository
final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final remoteDataSource = ref.watch(menuRemoteDataSourceProvider);
  return MenuRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Use Cases
final getMenuUseCaseProvider = Provider((ref) {
  final repository = ref.watch(menuRepositoryProvider);
  return GetMenu(repository);
});

final getMenuItemUseCaseProvider = Provider((ref) {
  final repository = ref.watch(menuRepositoryProvider);
  return GetMenuItem(repository);
});

final searchMenuUseCaseProvider = Provider((ref) {
  final repository = ref.watch(menuRepositoryProvider);
  return SearchMenu(repository);
});

final saveCustomPresetUseCaseProvider = Provider((ref) {
  final repository = ref.watch(menuRepositoryProvider);
  return SaveCustomPreset(repository);
});

final deleteCustomPresetUseCaseProvider = Provider((ref) {
  final repository = ref.watch(menuRepositoryProvider);
  return DeleteCustomPreset(repository);
});

final getCustomPresetsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(menuRepositoryProvider);
  return GetCustomPresets(repository);
});

// State
class MenuState {
  final List<MenuItem> menuItems;
  final MenuItem? selectedMenuItem;
  final List<MenuItem> searchResults;
  final List<CustomPreset> customPresets;
  final bool isLoading;
  final String? error;

  MenuState({
    this.menuItems = const [],
    this.selectedMenuItem,
    this.searchResults = const [],
    this.customPresets = const [],
    this.isLoading = false,
    this.error,
  });

  MenuState copyWith({
    List<MenuItem>? menuItems,
    MenuItem? selectedMenuItem,
    List<MenuItem>? searchResults,
    List<CustomPreset>? customPresets,
    bool? isLoading,
    String? error,
  }) {
    return MenuState(
      menuItems: menuItems ?? this.menuItems,
      selectedMenuItem: selectedMenuItem ?? this.selectedMenuItem,
      searchResults: searchResults ?? this.searchResults,
      customPresets: customPresets ?? this.customPresets,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// State Notifier
class MenuNotifier extends Notifier<MenuState> {
  late final GetMenu getMenuUseCase;
  late final GetMenuItem getMenuItemUseCase;
  late final SearchMenu searchMenuUseCase;
  late final SaveCustomPreset saveCustomPresetUseCase;
  late final DeleteCustomPreset deleteCustomPresetUseCase;
  late final GetCustomPresets getCustomPresetsUseCase;

  @override
  MenuState build() {
    getMenuUseCase = ref.watch(getMenuUseCaseProvider);
    getMenuItemUseCase = ref.watch(getMenuItemUseCaseProvider);
    searchMenuUseCase = ref.watch(searchMenuUseCaseProvider);
    saveCustomPresetUseCase = ref.watch(saveCustomPresetUseCaseProvider);
    deleteCustomPresetUseCase = ref.watch(deleteCustomPresetUseCaseProvider);
    getCustomPresetsUseCase = ref.watch(getCustomPresetsUseCaseProvider);
    return MenuState();
  }

  Future<void> fetchMenu(String storeId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getMenuUseCase(storeId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (items) => state = state.copyWith(
        isLoading: false,
        menuItems: items,
      ),
    );
  }

  Future<void> fetchMenuItem(String itemId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getMenuItemUseCase(itemId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (item) => state = state.copyWith(
        isLoading: false,
        selectedMenuItem: item,
      ),
    );
  }

  Future<void> search({required String storeId, required String query}) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await searchMenuUseCase(
      storeId: storeId,
      query: query,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (results) => state = state.copyWith(
        isLoading: false,
        searchResults: results,
      ),
    );
  }

  Future<void> savePreset(CustomPreset preset) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await saveCustomPresetUseCase(preset);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (savedPreset) {
        final updatedPresets = [
          ...state.customPresets,
          savedPreset,
        ];
        state = state.copyWith(
          isLoading: false,
          customPresets: updatedPresets,
        );
      },
    );
  }

  Future<void> deletePreset(String presetId, String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await deleteCustomPresetUseCase(
      presetId: presetId,
      userId: userId,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (_) {
        final updatedPresets = state.customPresets
            .where((p) => p.id != presetId)
            .toList();
        state = state.copyWith(
          isLoading: false,
          customPresets: updatedPresets,
        );
      },
    );
  }

  Future<void> fetchCustomPresets({
    required String userId,
    String? storeId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getCustomPresetsUseCase(
      userId: userId,
      storeId: storeId,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (presets) => state = state.copyWith(
        isLoading: false,
        customPresets: presets,
      ),
    );
  }
}

// Provider
final menuProvider = NotifierProvider<MenuNotifier, MenuState>(() {
  return MenuNotifier();
});

import 'package:brewease_and_reward/features/menu/domain/entities/modifier.dart';
import 'package:brewease_and_reward/features/menu/domain/entities/modifier_option.dart';
import 'package:brewease_and_reward/features/menu/domain/entities/price_variant.dart';
import 'package:brewease_and_reward/features/menu/domain/entities/menu_item.dart';
import 'package:equatable/equatable.dart';

ModifierType _parseModifierType(String type) {
  return ModifierType.values.firstWhere(
    (e) => e.toString().split('.').last == type,
    orElse: () => ModifierType.single,
  );
}

class MenuItemModel with EquatableMixin {
  final String id;
  final String storeId;
  final String name;
  final String? description;
  final String category;
  final List<String> images;
  final List<PriceVariant> variants;
  final List<Modifier> modifiers;
  final bool available;
  final bool inventoryTracked;

  const MenuItemModel({
    required this.id,
    required this.storeId,
    required this.name,
    this.description,
    required this.category,
    this.images = const [],
    this.variants = const [],
    this.modifiers = const [],
    this.available = true,
    this.inventoryTracked = false,
  });

  factory MenuItemModel.fromMap(Map<String, dynamic> map) {
    return MenuItemModel(
      id: map['id'] as String,
      storeId: map['storeId'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      category: map['category'] as String,
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
      variants: (map['variants'] as List<dynamic>?)
              ?.map((e) => PriceVariantModel.fromMap(e as Map<String, dynamic>).toDomain())
              .toList() ??
          [],
      modifiers: (map['modifiers'] as List<dynamic>?)
              ?.map((e) => ModifierModel.fromMap(e as Map<String, dynamic>).toDomain())
              .toList() ??
          [],
      available: map['available'] as bool? ?? true,
      inventoryTracked: map['inventoryTracked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storeId': storeId,
      'name': name,
      'description': description,
      'category': category,
      'images': images,
      'variants': variants.map((e) => (e as PriceVariantModel).toMap()).toList(),
      'modifiers': modifiers.map((e) => (e as ModifierModel).toMap()).toList(),
      'available': available,
      'inventoryTracked': inventoryTracked,
    };
  }

  MenuItem toDomain() {
    return MenuItem(
      id: id,
      storeId: storeId,
      name: name,
      description: description,
      category: category,
      images: images,
      variants: variants,
      modifiers: modifiers,
      available: available,
      inventoryTracked: inventoryTracked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        storeId,
        name,
        description,
        category,
        images,
        variants,
        modifiers,
        available,
        inventoryTracked,
      ];
}

class ModifierModel with EquatableMixin {
  final String id;
  final String name;
  final ModifierType type;
  final List<ModifierOption> options;
  final int? maxSelections;

  const ModifierModel({
    required this.id,
    required this.name,
    this.type = ModifierType.single,
    this.options = const [],
    this.maxSelections,
  });

  factory ModifierModel.fromMap(Map<String, dynamic> map) {
    return ModifierModel(
      id: map['id'] as String,
      name: map['name'] as String,
      type: _parseModifierType(map['type'] as String? ?? 'single'),
      options: (map['options'] as List<dynamic>?)
          ?.map((e) =>
              ModifierOptionModel.fromMap(e as Map<String, dynamic>).toDomain())
          .toList() ??
          [],
      maxSelections: (map['maxSelections'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'options':
          options.map((e) => (e as ModifierOptionModel).toMap()).toList(),
      'maxSelections': maxSelections,
    };
  }

  Modifier toDomain() {
    return Modifier(
      id: id,
      name: name,
      type: type,
      options: options,
      maxSelections: maxSelections,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        options,
        maxSelections,
      ];
}

class ModifierOptionModel with EquatableMixin {
  final String id;
  final String label;
  final double priceDelta;

  const ModifierOptionModel({
    required this.id,
    required this.label,
    this.priceDelta = 0.0,
  });

  factory ModifierOptionModel.fromMap(Map<String, dynamic> map) {
    return ModifierOptionModel(
      id: map['id'] as String,
      label: map['label'] as String,
      priceDelta: (map['priceDelta'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'priceDelta': priceDelta,
    };
  }

  ModifierOption toDomain() {
    return ModifierOption(
      id: id,
      label: label,
      priceDelta: priceDelta,
    );
  }

  @override
  List<Object?> get props => [id, label, priceDelta];
}

class PriceVariantModel with EquatableMixin {
  final String id;
  final String label;
  final double price;

  const PriceVariantModel({
    required this.id,
    required this.label,
    required this.price,
  });

  factory PriceVariantModel.fromMap(Map<String, dynamic> map) {
    return PriceVariantModel(
      id: map['id'] as String,
      label: map['label'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'price': price,
    };
  }

  PriceVariant toDomain() {
    return PriceVariant(
      id: id,
      label: label,
      price: price,
    );
  }

  @override
  List<Object?> get props => [id, label, price];
}

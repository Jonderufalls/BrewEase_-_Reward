import 'package:brewease_and_reward/features/menu/domain/entities/custom_preset.dart';
import 'package:equatable/equatable.dart';

class CustomPresetModel extends CustomPreset with EquatableMixin {
  const CustomPresetModel({
    required super.id,
    required super.userId,
    required super.storeId,
    required super.itemId,
    required super.name,
    super.selectedOptions = const {},
    super.quantity = 1,
    required super.createdAt,
  });

  factory CustomPresetModel.fromMap(Map<String, dynamic> map) {
    return CustomPresetModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      storeId: map['storeId'] as String,
      itemId: map['itemId'] as String,
      name: map['name'] as String,
      selectedOptions: (map['selectedOptions'] as Map<String, dynamic>?)?.cast<String, String>() ?? {},
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'storeId': storeId,
      'itemId': itemId,
      'name': name,
      'selectedOptions': selectedOptions,
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        storeId,
        itemId,
        name,
        selectedOptions,
        quantity,
        createdAt,
      ];
}

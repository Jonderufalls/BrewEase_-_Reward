import 'package:equatable/equatable.dart';

/// Represents a saved custom configuration for a menu item.
/// selectedOptions: map of modifierId -> selected optionId or textual value (for freeText).
class CustomPreset extends Equatable {
  final String id;
  final String userId;
  final String storeId;
  final String itemId;
  final String name;
  final Map<String, String> selectedOptions;
  final int quantity;
  final DateTime createdAt;

  const CustomPreset({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.itemId,
    required this.name,
    this.selectedOptions = const {},
    this.quantity = 1,
    required this.createdAt,
  });

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
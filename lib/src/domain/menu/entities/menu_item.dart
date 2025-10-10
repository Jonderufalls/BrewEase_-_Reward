import 'package:equatable/equatable.dart';
import 'modifier.dart';
import 'price_variant.dart';

class MenuItem extends Equatable {
  final String id;
  final String storeId;
  final String name;
  final String? description;
  final String category;
  final List<String> images; // urls
  final List<PriceVariant> variants;
  final List<Modifier> modifiers;
  final bool available;
  final bool inventoryTracked;

  const MenuItem({
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
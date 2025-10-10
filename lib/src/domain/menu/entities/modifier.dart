import 'package:equatable/equatable.dart';
import 'modifier_option.dart';

enum ModifierType { single, multiple, freeText }

class Modifier extends Equatable {
  final String id;
  final String name;
  final ModifierType type;
  final List<ModifierOption> options;
  final int? maxSelections; // null means unlimited (for multiple)

  const Modifier({
    required this.id,
    required this.name,
    this.type = ModifierType.single,
    this.options = const [],
    this.maxSelections,
  });

  @override
  List<Object?> get props => [id, name, type, options, maxSelections];
}
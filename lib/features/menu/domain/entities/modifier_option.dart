import 'package:equatable/equatable.dart';

class ModifierOption extends Equatable {
  final String id;
  final String label;
  final double priceDelta; // can be 0.0

  const ModifierOption({
    required this.id,
    required this.label,
    this.priceDelta = 0.0,
  });

  @override
  List<Object?> get props => [id, label, priceDelta];
}
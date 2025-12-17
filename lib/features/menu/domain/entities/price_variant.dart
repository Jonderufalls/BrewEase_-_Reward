import 'package:equatable/equatable.dart';

class PriceVariant extends Equatable {
  final String id;
  final String label;
  final double price;

  const PriceVariant({
    required this.id,
    required this.label,
    required this.price,
  });

  @override
  List<Object?> get props => [id, label, price];
}
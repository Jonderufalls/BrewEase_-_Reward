import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final Map<String, dynamic>? customizations; // e.g. size, toppings, notes

  const OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.customizations,
  });

  double get lineTotal => price * quantity;

  @override
  List<Object?> get props => [id, name, quantity, price, customizations];
}
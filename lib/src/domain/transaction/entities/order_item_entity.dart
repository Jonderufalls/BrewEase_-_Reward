import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String itemId;
  final String name;
  final int quantity;
  final double price;
  final Map<String, dynamic> customizations; 
  // e.g. {"size": "Large", "sugar": "50%", "ice": "Less", "toppings": ["Pearls"]}

  const OrderItemEntity({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.customizations,
  });

  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [itemId, name, quantity, price, customizations];
}

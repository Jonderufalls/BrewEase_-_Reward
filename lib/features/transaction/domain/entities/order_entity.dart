import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';

enum OrderStatus { pending, preparing, ready, completed, cancelled }

class OrderEntity extends Equatable {
  final String orderId;
  final String customerId;
  final String? customerName;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String paymentMethod; // "Cash on Pickup" or "GCash" (future)
  final DateTime createdAt;
  final DateTime? pickupTime;
  final OrderStatus status;
  final bool isScheduled;
  final String? pickupLocation;
  final String? notes;

  const OrderEntity({
    required this.orderId,
    required this.customerId,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.createdAt,
    required this.status,
    required this.isScheduled,
    this.customerName,
    this.pickupTime,
    this.pickupLocation,
    this.notes,
  });

  @override
  List<Object?> get props => [
        orderId,
        customerId,
        items,
        totalAmount,
        paymentMethod,
        createdAt,
        pickupTime,
        status,
        isScheduled,
        pickupLocation,
        notes,
        customerName,
      ];
}

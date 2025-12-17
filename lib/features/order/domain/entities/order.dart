import 'package:equatable/equatable.dart';
import 'order_item.dart';
import 'pickup_info.dart';
import 'order_status.dart';

class Order extends Equatable {
  final String id;
  final List<OrderItem> items;
  final double total;
  final OrderStatus status;
  final String customerName;
  final String customerContact;
  final PickupInfo pickup;
  final String paymentType; // e.g. cash_on_pickup, gcash
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;
  final bool loyaltyApplied;
  final String? paymentProofUrl;

  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.customerName,
    required this.customerContact,
    required this.pickup,
    required this.paymentType,
    required this.createdAt,
    this.updatedAt,
    this.notes,
    this.loyaltyApplied = false,
    this.paymentProofUrl,
  });

  @override
  List<Object?> get props => [
        id,
        items,
        total,
        status,
        customerName,
        customerContact,
        pickup,
        paymentType,
        createdAt,
        updatedAt,
        notes,
        loyaltyApplied,
        paymentProofUrl,
      ];
}
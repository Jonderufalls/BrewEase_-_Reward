import 'package:brewease_and_reward/features/order/domain/entities/order.dart';
import 'package:brewease_and_reward/features/order/domain/entities/order_status.dart';
import 'package:brewease_and_reward/features/order/domain/entities/pickup_info.dart';
import 'package:equatable/equatable.dart';

OrderStatus _parseOrderStatus(String status) {
  return OrderStatus.values.firstWhere(
    (e) => e.toString().split('.').last == status,
    orElse: () => OrderStatus.pending,
  );
}

class OrderEntityModel with EquatableMixin {
  final String id;
  final String customerId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final OrderStatus status;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? notes;

  const OrderEntityModel({
    required this.id,
    required this.customerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.completedAt,
    this.notes,
  });

  factory OrderEntityModel.fromMap(Map<String, dynamic> map) {
    return OrderEntityModel(
      id: map['id'] as String,
      customerId: map['customerId'] as String,
      items: (map['items'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [],
      totalAmount: (map['totalAmount'] as num).toDouble(),
      status: _parseOrderStatus(map['status'] as String? ?? 'pending'),
      paymentMethod: map['paymentMethod'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      notes: map['notes'] as String?,
    );
  }

  factory OrderEntityModel.fromDomain(Order order) {
    return OrderEntityModel(
      id: order.id,
      customerId: order.customerName,
      items: [],
      totalAmount: order.total,
      status: order.status,
      paymentMethod: order.paymentType,
      createdAt: order.createdAt,
      completedAt: order.updatedAt,
      notes: order.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'items': items,
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'notes': notes,
    };
  }

  Order toDomain() {
    return Order(
      id: id,
      items: [],
      total: totalAmount,
      status: status,
      customerName: customerId,
      customerContact: '',
      pickup: const PickupInfo(
        asap: true,
        locationId: '',
        instructions: '',
      ),
      paymentType: paymentMethod,
      createdAt: createdAt,
      updatedAt: completedAt,
      notes: notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        items,
        totalAmount,
        status,
        paymentMethod,
        createdAt,
        completedAt,
        notes,
      ];
}

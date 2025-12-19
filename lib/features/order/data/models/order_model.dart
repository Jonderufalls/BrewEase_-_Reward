import 'package:brewease_and_reward/features/order/domain/entities/order.dart';
import 'package:brewease_and_reward/features/order/domain/entities/order_item.dart';
import 'package:brewease_and_reward/features/order/domain/entities/pickup_info.dart';
import 'package:brewease_and_reward/features/order/domain/entities/order_status.dart';
import 'package:brewease_and_reward/features/order/domain/entities/order_summary.dart';
import 'package:equatable/equatable.dart';

OrderStatus _parseOrderStatus(String status) {
  return OrderStatus.values.firstWhere(
    (e) => e.toString().split('.').last == status,
    orElse: () => OrderStatus.pending,
  );
}

class OrderModel with EquatableMixin {
  final String id;
  final List<OrderItem> items;
  final double total;
  final OrderStatus status;
  final String customerName;
  final String customerContact;
  final PickupInfo pickup;
  final String paymentType;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;
  final bool loyaltyApplied;
  final String? paymentProofUrl;

  const OrderModel({
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

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      items: (map['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromMap(e as Map<String, dynamic>).toDomain())
              .toList() ??
          [],
      total: (map['total'] as num).toDouble(),
      status: _parseOrderStatus(map['status'] as String),
      customerName: map['customerName'] as String,
      customerContact: map['customerContact'] as String,
      pickup: PickupInfoModel.fromMap(
          map['pickup'] as Map<String, dynamic>).toDomain(),
      paymentType: map['paymentType'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      notes: map['notes'] as String?,
      loyaltyApplied: map['loyaltyApplied'] as bool? ?? false,
      paymentProofUrl: map['paymentProofUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((e) {
        // items are OrderItem domain entities, convert to map manually
        return {
          'itemId': e.id,
          'name': e.name,
          'quantity': e.quantity,
          'customizations': e.customizations ?? {},
          'price': e.price,
        };
      }).toList(),
      'total': total,
      'status': status.toString().split('.').last,
      'customerName': customerName,
      'customerContact': customerContact,
      'pickup': (pickup is PickupInfoModel) ? (pickup as PickupInfoModel).toMap() : {},
      'paymentType': paymentType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'notes': notes,
      'loyaltyApplied': loyaltyApplied,
      'paymentProofUrl': paymentProofUrl,
    };
  }

  Order toDomain() {
    return Order(
      id: id,
      items: items,
      total: total,
      status: status,
      customerName: customerName,
      customerContact: customerContact,
      pickup: pickup,
      paymentType: paymentType,
      createdAt: createdAt,
      updatedAt: updatedAt,
      notes: notes,
      loyaltyApplied: loyaltyApplied,
      paymentProofUrl: paymentProofUrl,
    );
  }

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

class OrderItemModel with EquatableMixin {
  final String itemId;
  final String name;
  final int quantity;
  final Map<String, dynamic> customizations;
  final double? price;

  const OrderItemModel({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.customizations,
    this.price,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      itemId: map['itemId'] as String,
      name: map['name'] as String,
      quantity: (map['quantity'] as num).toInt(),
      customizations:
          (map['customizations'] as Map<String, dynamic>?)?.cast<String, dynamic>() ?? {},
      price: (map['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'name': name,
      'quantity': quantity,
      'customizations': customizations,
      'price': price,
    };
  }

  OrderItem toDomain() {
    return OrderItem(
      id: itemId,
      name: name,
      quantity: quantity,
      price: price ?? 0.0,
      customizations: customizations,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        name,
        quantity,
        customizations,
        price,
      ];
}

class PickupInfoModel with EquatableMixin {
  final DateTime scheduledTime;
  final String locationId;
  final bool isASAP;

  const PickupInfoModel({
    required this.scheduledTime,
    required this.locationId,
    required this.isASAP,
  });

  factory PickupInfoModel.fromMap(Map<String, dynamic> map) {
    return PickupInfoModel(
      scheduledTime: DateTime.parse(map['scheduledTime'] as String),
      locationId: map['locationId'] as String,
      isASAP: map['isASAP'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'scheduledTime': scheduledTime.toIso8601String(),
      'locationId': locationId,
      'isASAP': isASAP,
    };
  }

  PickupInfo toDomain() {
    return PickupInfo(
      asap: isASAP,
      scheduledAt: scheduledTime,
      locationId: locationId,
      instructions: '',
    );
  }

  @override
  List<Object?> get props => [scheduledTime, locationId, isASAP];
}

class OrderSummaryModel with EquatableMixin {
  final DateTime date;
  final int totalOrders;
  final double totalSales;
  final Map<String, int> topItems;
  final int loyaltyRedemptions;

  const OrderSummaryModel({
    required this.date,
    required this.totalOrders,
    required this.totalSales,
    required this.topItems,
    required this.loyaltyRedemptions,
  });

  factory OrderSummaryModel.fromMap(Map<String, dynamic> map) {
    return OrderSummaryModel(
      date: DateTime.parse(map['date'] as String),
      totalOrders: (map['totalOrders'] as num).toInt(),
      totalSales: (map['totalSales'] as num).toDouble(),
      topItems: (map['topItems'] as Map<String, dynamic>?)
              ?.cast<String, int>() ??
          {},
      loyaltyRedemptions: (map['loyaltyRedemptions'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'totalOrders': totalOrders,
      'totalSales': totalSales,
      'topItems': topItems,
      'loyaltyRedemptions': loyaltyRedemptions,
    };
  }

  OrderSummary toDomain() {
    return OrderSummary(
      date: date,
      orderCount: totalOrders,
      salesTotal: totalSales,
      topItems: topItems,
      loyaltyRedemptions: loyaltyRedemptions,
    );
  }

  @override
  List<Object?> get props => [
        date,
        totalOrders,
        totalSales,
        topItems,
        loyaltyRedemptions,
      ];
}

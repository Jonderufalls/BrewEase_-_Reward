import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brewease_and_reward/features/order/data/models/order_model.dart';
import 'package:brewease_and_reward/features/order/domain/entities/order_status.dart';
import 'order_remote_data_source.dart';

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<OrderModel>> getOrders({
    OrderStatus? status,
    DateTime? from,
    DateTime? to,
    String? query,
    int? limit,
    int? offset,
  }) async {
    var queryRef =
        firestore.collection('orders') as Query<Map<String, dynamic>>;

    if (status != null) {
      queryRef = queryRef.where('status',
          isEqualTo: status.toString().split('.').last);
    }
    if (from != null) {
      queryRef = queryRef.where('createdAt',
          isGreaterThanOrEqualTo: from.toIso8601String());
    }
    if (to != null) {
      queryRef =
          queryRef.where('createdAt', isLessThanOrEqualTo: to.toIso8601String());
    }

    if (limit != null) {
      queryRef = queryRef.limit(limit);
    }

    final snapshot = await queryRef.get();
    return snapshot.docs
        .map((doc) => OrderModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }

  @override
  Future<OrderModel> getOrder(String orderId) async {
    final doc = await firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) throw Exception('Order not found');
    return OrderModel.fromMap({'id': doc.id, ...doc.data()!});
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? reason,
  }) async {
    await firestore.collection('orders').doc(orderId).update({
      'status': status.toString().split('.').last,
      'updatedAt': DateTime.now().toIso8601String(),
      if (reason != null) 'cancelReason': reason,
    });
  }

  @override
  Future<Map<String, dynamic>> getSummary({required DateTime date}) async {
    final startOfDay =
        DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await firestore
        .collection('orders')
        .where('createdAt',
            isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('createdAt', isLessThan: endOfDay.toIso8601String())
        .where('status', isEqualTo: 'completed')
        .get();

    double totalSales = 0;
    final topItems = <String, int>{};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      totalSales += (data['totalAmount'] as num?)?.toDouble() ?? 0;

      final items = data['items'] as List<dynamic>?;
      if (items != null) {
        for (var item in items) {
          final itemName = item['name'] as String?;
          if (itemName != null) {
            topItems[itemName] = (topItems[itemName] ?? 0) + 1;
          }
        }
      }
    }

    return {
      'date': date.toIso8601String(),
      'totalOrders': snapshot.docs.length,
      'totalSales': totalSales,
      'topItems': topItems.entries
          .toList()
          ..sort((a, b) => b.value.compareTo(a.value)),
      'loyaltyRedemptions': 0,
    };
  }

  @override
  Future<String> exportOrdersCsv({
    required DateTime from,
    required DateTime to,
  }) async {
    final snapshot = await firestore
        .collection('orders')
        .where('createdAt', isGreaterThanOrEqualTo: from.toIso8601String())
        .where('createdAt', isLessThanOrEqualTo: to.toIso8601String())
        .get();

    final buffer = StringBuffer();
    buffer.writeln(
        'Order ID,Customer ID,Status,Created At,Total Amount,Items Count');

    for (var doc in snapshot.docs) {
      final data = doc.data();
      buffer.writeln(
          '${doc.id},${data['customerId']},${data['status']},${data['createdAt']},${data['totalAmount'] ?? 0},${(data['items'] as List?)?.length ?? 0}');
    }

    return buffer.toString();
  }
}

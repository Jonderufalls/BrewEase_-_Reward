import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_entity_model.dart';
import 'package:brewease_and_reward/features/order/domain/entities/order_status.dart';
import 'transaction_remote_data_source.dart';

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;

  TransactionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<OrderEntityModel> createOrder({
    required OrderEntityModel order,
  }) async {
    final docRef = firestore.collection('transactions').doc(order.id);
    await docRef.set(order.toMap());
    return order;
  }

  @override
  Future<List<OrderEntityModel>> getOrdersByCustomer(String customerId) async {
    final snapshot = await firestore
        .collection('transactions')
        .where('customerId', isEqualTo: customerId)
        .get();
    return snapshot.docs
        .map((doc) =>
            OrderEntityModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }

  @override
  Future<List<OrderEntityModel>> getOrdersByOwner(String ownerId) async {
    final snapshot = await firestore
        .collection('transactions')
        .where('ownerId', isEqualTo: ownerId)
        .get();
    return snapshot.docs
        .map((doc) =>
            OrderEntityModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }

  @override
  Future<OrderEntityModel> getOrderById(String orderId) async {
    final doc = await firestore.collection('transactions').doc(orderId).get();
    if (!doc.exists) throw Exception('Order not found');
    return OrderEntityModel.fromMap({'id': doc.id, ...doc.data()!});
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    await firestore.collection('transactions').doc(orderId).update({
      'status': status.toString().split('.').last,
    });
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    await firestore.collection('transactions').doc(orderId).update({
      'status': 'cancelled',
      'cancelledAt': DateTime.now().toIso8601String(),
    });
  }
}

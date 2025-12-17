import '../models/order_entity_model.dart';
import 'package:brewease_and_reward/features/order/domain/entities/order_status.dart';

abstract class TransactionRemoteDataSource {
  Future<OrderEntityModel> createOrder({required OrderEntityModel order});

  Future<List<OrderEntityModel>> getOrdersByCustomer(String customerId);

  Future<List<OrderEntityModel>> getOrdersByOwner(String ownerId);

  Future<OrderEntityModel> getOrderById(String orderId);

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  });

  Future<void> cancelOrder(String orderId);
}

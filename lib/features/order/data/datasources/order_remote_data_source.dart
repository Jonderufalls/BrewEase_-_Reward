import 'package:brewease_and_reward/features/order/data/models/order_model.dart';
import 'package:brewease_and_reward/features/order/domain/entities/order_status.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders({
    OrderStatus? status,
    DateTime? from,
    DateTime? to,
    String? query,
    int? limit,
    int? offset,
  });

  Future<OrderModel> getOrder(String orderId);

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? reason,
  });

  Future<Map<String, dynamic>> getSummary({required DateTime date});

  Future<String> exportOrdersCsv({
    required DateTime from,
    required DateTime to,
  });
}

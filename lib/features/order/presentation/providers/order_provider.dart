import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/get_orders.dart';
import '../../domain/usecases/get_order_details.dart';
import '../../domain/usecases/update_order_status.dart';
import '../../domain/usecases/get_summary_report.dart';
import '../../data/datasources/order_remote_data_source_impl.dart';
import '../../data/repositories/order_repository_impl.dart';

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// Data Sources
final orderRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return OrderRemoteDataSourceImpl(firestore: firestore);
});

// Repository
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final remoteDataSource = ref.watch(orderRemoteDataSourceProvider);
  return OrderRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Use Cases
final getOrdersUseCaseProvider = Provider((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetOrders(repository);
});

final getOrderDetailsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetOrderDetails(repository);
});

final updateOrderStatusUseCaseProvider = Provider((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return UpdateOrderStatus(repository);
});

final getSummaryReportUseCaseProvider = Provider((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetSummaryReport(repository);
});

// State
class OrderState {
  final List<Order> orders;
  final Order? selectedOrder;
  final dynamic summary;
  final bool isLoading;
  final String? error;

  OrderState({
    this.orders = const [],
    this.selectedOrder,
    this.summary,
    this.isLoading = false,
    this.error,
  });

  OrderState copyWith({
    List<Order>? orders,
    Order? selectedOrder,
    dynamic summary,
    bool? isLoading,
    String? error,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// State Notifier
class OrderNotifier extends Notifier<OrderState> {
  late final GetOrders getOrdersUseCase;
  late final GetOrderDetails getOrderDetailsUseCase;
  late final UpdateOrderStatus updateOrderStatusUseCase;
  late final GetSummaryReport getSummaryReportUseCase;

  @override
  OrderState build() {
    getOrdersUseCase = ref.watch(getOrdersUseCaseProvider);
    getOrderDetailsUseCase = ref.watch(getOrderDetailsUseCaseProvider);
    updateOrderStatusUseCase = ref.watch(updateOrderStatusUseCaseProvider);
    getSummaryReportUseCase = ref.watch(getSummaryReportUseCaseProvider);
    return OrderState();
  }

  Future<void> fetchOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getOrdersUseCase(GetOrdersParams());

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (orders) => state = state.copyWith(
        isLoading: false,
        orders: orders,
      ),
    );
  }

  Future<void> fetchOrderDetails(String orderId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getOrderDetailsUseCase(orderId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (order) => state = state.copyWith(
        isLoading: false,
        selectedOrder: order,
      ),
    );
  }

  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    String? reason,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final params = UpdateOrderStatusParams(
      orderId: orderId,
      status: status,
      reason: reason,
    );
    final result = await updateOrderStatusUseCase(params);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (_) => state = state.copyWith(
        isLoading: false,
      ),
    );
  }

  Future<void> fetchSummaryReport(DateTime date) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getSummaryReportUseCase(date);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (summary) => state = state.copyWith(
        isLoading: false,
        summary: summary,
      ),
    );
  }
}

// Provider
final orderProvider = NotifierProvider<OrderNotifier, OrderState>(() {
  return OrderNotifier();
});

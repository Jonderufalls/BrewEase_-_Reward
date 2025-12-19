import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/order_entity.dart';
import '../../data/datasources/transaction_remote_data_source_impl.dart';
import '../../data/repositories/order_repository_impl.dart' as transaction_repo;

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// Data Sources
final transactionRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return TransactionRemoteDataSourceImpl(firestore: firestore);
});

// Repository
final transactionRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.watch(transactionRemoteDataSourceProvider);
  return transaction_repo.TransactionRepositoryImpl(remoteDataSource: remoteDataSource);
});

// State
class TransactionState {
  final List<OrderEntity> transactions;
  final OrderEntity? selectedTransaction;
  final bool isLoading;
  final String? error;

  TransactionState({
    this.transactions = const [],
    this.selectedTransaction,
    this.isLoading = false,
    this.error,
  });

  TransactionState copyWith({
    List<OrderEntity>? transactions,
    OrderEntity? selectedTransaction,
    bool? isLoading,
    String? error,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      selectedTransaction: selectedTransaction ?? this.selectedTransaction,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// State Notifier
class TransactionNotifier extends StateNotifier<TransactionState> {
  final transaction_repo.TransactionRepositoryImpl repository;

  TransactionNotifier({
    required this.repository,
  }) : super(TransactionState());

  Future<void> fetchTransactions(String customerId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await repository.getOrdersByCustomer(customerId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (transactions) => state = state.copyWith(
        isLoading: false,
        transactions: transactions,
      ),
    );
  }

  Future<void> fetchTransactionById(String transactionId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await repository.getOrderById(transactionId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (transaction) => state = state.copyWith(
        isLoading: false,
        selectedTransaction: transaction,
      ),
    );
  }

  Future<void> cancelTransaction(String transactionId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await repository.cancelOrder(transactionId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (_) {
        final updatedTransactions = state.transactions
            .where((t) => t.orderId != transactionId)
            .toList();
        state = state.copyWith(
          isLoading: false,
          transactions: updatedTransactions,
        );
      },
    );
  }

  Future<void> updateTransactionStatus(
    String transactionId,
    OrderStatus status,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await repository.updateOrderStatus(
      orderId: transactionId,
      status: status,
    );

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
}

// Provider
final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionNotifier(repository: repository);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/promo.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/create_promo.dart';
import '../../domain/usecases/update_promo.dart';
import '../../domain/usecases/get_active_promos.dart';
import '../../domain/usecases/send_notification_to_user.dart';
import '../../domain/usecases/send_notification_to_all.dart';
import '../../domain/usecases/get_notification_history.dart';
import '../../data/datasources/notification_remote_data_source_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// Data Sources
final notificationRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return NotificationRemoteDataSourceImpl(firestore: firestore);
});

// Repository
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Use Cases
final createPromoUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return CreatePromo(repository);
});

final updatePromoUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return UpdatePromo(repository);
});

final getActivePromosUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetActivePromos(repository);
});

final sendNotificationToUserUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return SendNotificationToUser(repository);
});

final sendNotificationToAllUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return SendNotificationToAll(repository);
});

final getNotificationHistoryUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetNotificationHistory(repository);
});

// State
class NotificationState {
  final List<Promo> activePromos;
  final List<Map<String, dynamic>> notificationHistory;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  NotificationState({
    this.activePromos = const [],
    this.notificationHistory = const [],
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  NotificationState copyWith({
    List<Promo>? activePromos,
    List<Map<String, dynamic>>? notificationHistory,
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return NotificationState(
      activePromos: activePromos ?? this.activePromos,
      notificationHistory: notificationHistory ?? this.notificationHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

// State Notifier
class NotificationNotifier extends Notifier<NotificationState> {
  late final CreatePromo createPromoUseCase;
  late final UpdatePromo updatePromoUseCase;
  late final GetActivePromos getActivePromosUseCase;
  late final SendNotificationToUser sendNotificationToUserUseCase;
  late final SendNotificationToAll sendNotificationToAllUseCase;
  late final GetNotificationHistory getNotificationHistoryUseCase;

  @override
  NotificationState build() {
    createPromoUseCase = ref.watch(createPromoUseCaseProvider);
    updatePromoUseCase = ref.watch(updatePromoUseCaseProvider);
    getActivePromosUseCase = ref.watch(getActivePromosUseCaseProvider);
    sendNotificationToUserUseCase = ref.watch(sendNotificationToUserUseCaseProvider);
    sendNotificationToAllUseCase = ref.watch(sendNotificationToAllUseCaseProvider);
    getNotificationHistoryUseCase = ref.watch(getNotificationHistoryUseCaseProvider);
    return NotificationState();
  }

  Future<void> createPromo(Promo promo) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    final result = await createPromoUseCase(promo);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (createdPromo) {
        final updatedPromos = [createdPromo, ...state.activePromos];
        state = state.copyWith(
          isLoading: false,
          activePromos: updatedPromos,
          successMessage: 'Promo created successfully',
        );
      },
    );
  }

  Future<void> updatePromo(Promo promo) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    final result = await updatePromoUseCase(promo);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (updatedPromo) {
        final updatedPromos = state.activePromos.map((p) {
          return p.id == updatedPromo.id ? updatedPromo : p;
        }).toList();

        state = state.copyWith(
          isLoading: false,
          activePromos: updatedPromos,
          successMessage: 'Promo updated successfully',
        );
      },
    );
  }

  Future<void> fetchActivePromos() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getActivePromosUseCase();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (promos) => state = state.copyWith(
        isLoading: false,
        activePromos: promos,
      ),
    );
  }

  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    final result = await sendNotificationToUserUseCase(
      userId: userId,
      title: title,
      body: body,
      data: data,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        successMessage: 'Notification sent successfully',
      ),
    );
  }

  Future<void> sendNotificationToAll({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    final result = await sendNotificationToAllUseCase(
      title: title,
      body: body,
      data: data,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        successMessage: 'Notification sent to all users successfully',
      ),
    );
  }

  Future<void> fetchNotificationHistory(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getNotificationHistoryUseCase(userId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (history) => state = state.copyWith(
        isLoading: false,
        notificationHistory: history.map((notification) => {
          'id': notification.id,
          'title': notification.title,
          'body': notification.body,
          'createdAt': notification.createdAt,
        }).toList(),
      ),
    );
  }
}

// Provider
final notificationProvider =
    NotifierProvider<NotificationNotifier, NotificationState>(() {
  return NotificationNotifier();
});

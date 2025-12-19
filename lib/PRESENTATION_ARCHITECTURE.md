# BrewEase Rewards - Presentation Layer Architecture

## Overview

This document describes the presentation layer implementation using **Riverpod** for state management and dependency injection. The architecture follows Clean Architecture principles with proper separation of concerns.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│        UI Layer (Future)                │
│    (Widgets & Screens)                  │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│      Presentation Layer (Current)       │
│  ┌───────────────────────────────────┐  │
│  │  Providers (Dependency Injection) │  │
│  │  - Firebase instances             │  │
│  │  - Data sources                   │  │
│  │  - Repositories                   │  │
│  │  - Use cases                      │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │  State Notifiers (State Management)│  │
│  │  - Feature states                 │  │
│  │  - State logic                    │  │
│  │  - Use case orchestration         │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│       Domain Layer                      │
│  ┌───────────────────────────────────┐  │
│  │  Use Cases                        │  │
│  │  Repositories (Abstract)          │  │
│  │  Entities                         │  │
│  │  Failures                         │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│       Data Layer                        │
│  ┌───────────────────────────────────┐  │
│  │  Remote Data Sources (Firebase)   │  │
│  │  Repository Implementations       │  │
│  │  Data Models                      │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

## Features

### 1. User Feature (`user_provider.dart`)

**State:**
- `user`: Current authenticated user
- `isLoading`: Loading state during operations
- `error`: Error messages from failed operations
- `isAuthenticated`: Authentication status

**Use Cases Integrated:**
- `SignUp`: Register new users
- `SignIn`: Authenticate users
- `SignOut`: Logout users
- `GetCurrentUser`: Fetch current user
- `UpdateProfile`: Update user profile
- `SendPasswordReset`: Send password reset email

**Dependencies:**
- Firebase Auth
- Firebase Firestore
- UserRepository

### 2. Menu Feature (`menu_provider.dart`)

**State:**
- `menuItems`: List of menu items from store
- `selectedMenuItem`: Currently selected item
- `searchResults`: Results from search
- `customPresets`: User's saved drink presets
- `isLoading`: Loading state
- `error`: Error messages

**Use Cases Integrated:**
- `GetMenu`: Fetch menu for a store
- `GetMenuItem`: Get details of single item
- `SearchMenu`: Search menu items
- `SaveCustomPreset`: Save user's preset
- `DeleteCustomPreset`: Delete a preset
- `GetCustomPresets`: Fetch user's presets

**Dependencies:**
- Firebase Firestore
- MenuRepository

### 3. Loyalty Feature (`loyalty_provider.dart`)

**State:**
- `loyaltyAccount`: User's loyalty account details
- `rewardTiers`: Available reward tiers
- `eligibleRewards`: Rewards user can redeem
- `customerVouchers`: User's vouchers
- `isLoading`: Loading state
- `error`: Error messages

**Use Cases Integrated:**
- `GetLoyaltyAccount`: Fetch loyalty account
- `AddLoyaltyPoints`: Add points to account
- `RedeemVoucher`: Redeem a voucher
- `GetRewardTiers`: Fetch reward tiers
- `GetEligibleRewards`: Get redemption options
- `GetCustomerVouchers`: Fetch user's vouchers

**Dependencies:**
- Firebase Firestore
- LoyaltyRepository

### 4. Order Feature (`order_provider.dart`)

**State:**
- `orders`: List of user's orders
- `selectedOrder`: Currently selected order
- `summary`: Order summary/report
- `isLoading`: Loading state
- `error`: Error messages

**Use Cases Integrated:**
- `CreateOrder`: Place new order
- `GetOrders`: Fetch user's orders
- `GetOrderDetails`: Get single order details
- `UpdateOrderStatus`: Update order status
- `GetSummaryReport`: Get order statistics

**Dependencies:**
- Firebase Firestore
- OrderRepository

### 5. Transaction Feature (`transaction_provider.dart`)

**State:**
- `transactions`: List of transactions
- `selectedTransaction`: Currently selected transaction
- `isLoading`: Loading state
- `error`: Error messages

**Use Cases Integrated:**
- `CreateOrder`: Create transaction
- `GetOrders`: Fetch transactions
- `GetOrderById`: Get transaction details
- `CancelOrder`: Cancel transaction
- `UpdateOrderStatus`: Update transaction status

**Dependencies:**
- Firebase Firestore
- OrderRepository

### 6. Notification Feature (`notification_provider.dart`)

**State:**
- `activePromos`: Currently active promotions
- `notificationHistory`: User's notification history
- `isLoading`: Loading state
- `error`: Error messages
- `successMessage`: Success feedback

**Use Cases Integrated:**
- `CreatePromo`: Create new promotion
- `UpdatePromo`: Update promotion
- `GetActivePromos`: Fetch active promos
- `SendNotificationToUser`: Send to single user
- `SendNotificationToAll`: Broadcast notification
- `GetNotificationHistory`: Fetch notification log

**Dependencies:**
- Firebase Firestore
- NotificationRepository

## Pattern: StateNotifier + Provider

Each feature follows this pattern:

```dart
// 1. Define State class
class FeatureState {
  final bool isLoading;
  final String? error;
  // ... feature-specific fields
}

// 2. Define StateNotifier
class FeatureNotifier extends StateNotifier<FeatureState> {
  // All use cases as constructor parameters
  final UseCase1 useCase1;
  final UseCase2 useCase2;
  
  // Methods that orchestrate use cases
  Future<void> action1() async {
    // Use case calls with error handling
  }
}

// 3. Expose StateNotifierProvider
final featureProvider = StateNotifierProvider<FeatureNotifier, FeatureState>((ref) {
  // Wire up all dependencies
  return FeatureNotifier(
    useCase1: ref.watch(useCase1Provider),
    useCase2: ref.watch(useCase2Provider),
  );
});
```

## Dependency Injection Flow

```
Providers (Bottom)
├── Firebase Instances
│   ├── firebaseAuthProvider
│   └── firebaseFirestoreProvider
├── Data Sources
│   ├── userRemoteDataSourceProvider
│   ├── menuRemoteDataSourceProvider
│   └── ...
├── Repositories
│   ├── userRepositoryProvider
│   ├── menuRepositoryProvider
│   └── ...
└── Use Cases
    ├── signUpUseCaseProvider
    ├── getMenuUseCaseProvider
    └── ...
         ↓
State Notifiers (Consumers)
├── userProvider
├── menuProvider
├── loyaltyProvider
├── orderProvider
├── transactionProvider
└── notificationProvider
```

## Usage Examples

### Consuming Providers in UI (Future)

```dart
// Access user state
final userState = ref.watch(userProvider);

// Call user actions
ref.read(userProvider.notifier).signUp(
  email: 'user@example.com',
  password: 'password123',
);

// Watch specific state properties
final isLoading = ref.watch(userProvider.select((state) => state.isLoading));
final error = ref.watch(userProvider.select((state) => state.error));
```

### Error Handling Pattern

All state notifiers implement consistent error handling:

```dart
result.fold(
  (failure) => state = state.copyWith(
    isLoading: false,
    error: failure.toString(),  // Handle as error
  ),
  (data) => state = state.copyWith(
    isLoading: false,
    data: data,  // Update with successful data
  ),
);
```

## Best Practices

1. **Immutable States**: All state classes are immutable with `copyWith` methods
2. **Error Handling**: Using `Either<Failure, T>` from domain layer
3. **Separation of Concerns**: Each feature has isolated providers
4. **Dependency Injection**: All dependencies injected through providers
5. **Single Responsibility**: Each StateNotifier handles one feature
6. **No Direct Imports**: Use centralized `presentation_providers.dart` for imports

## File Structure

```
lib/
├── features/
│   ├── user/
│   │   └── presentation/
│   │       └── providers/
│   │           └── user_provider.dart
│   ├── menu/
│   │   └── presentation/
│   │       └── providers/
│   │           └── menu_provider.dart
│   ├── loyalty/
│   │   └── presentation/
│   │       └── providers/
│   │           └── loyalty_provider.dart
│   ├── order/
│   │   └── presentation/
│   │       └── providers/
│   │           └── order_provider.dart
│   ├── transaction/
│   │   └── presentation/
│   │       └── providers/
│   │           └── transaction_provider.dart
│   └── notification/
│       └── presentation/
│           └── providers/
│               └── notification_provider.dart
└── presentation_providers.dart  (Central export)
```

## Adding New Features

To add a new feature:

1. Create `features/[feature_name]/presentation/providers/[feature_name]_provider.dart`
2. Define `[Feature]State` class
3. Define `[Feature]Notifier` extending `StateNotifier`
4. Wire up all use cases as constructor parameters
5. Expose `[feature_name]Provider` as `StateNotifierProvider`
6. Add export to `presentation_providers.dart`

## Testing Considerations

Each provider is testable through:
- Mocking use cases
- Testing state transitions
- Testing error handling
- Using `ProviderContainer` for isolated testing

Example:
```dart
test('user sign up success', () async {
  final container = ProviderContainer();
  final notifier = container.read(userProvider.notifier);
  
  await notifier.signUp(
    email: 'test@example.com',
    password: 'password123',
  );
  
  final state = container.read(userProvider);
  expect(state.isAuthenticated, true);
});
```

## Future: UI Layer Integration

When UI screens are created, they will:
1. Import from `presentation_providers.dart`
2. Use `ConsumerWidget` or `ConsumerStatefulWidget`
3. Call provider methods through `ref.read()`
4. Rebuild automatically when watched state changes
5. Display loading/error states from providers

This completes the presentation layer foundation for the BrewEase Rewards app.

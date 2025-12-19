# Quick Reference Guide - Presentation Layer Providers

## Feature Providers Quick Access

### 1. User (Authentication & Profile)
**Provider**: `userProvider`
**State Type**: `UserState`

**Available Actions**:
```dart
ref.read(userProvider.notifier).signUp(
  email: 'email@example.com',
  password: 'password123',
  name: 'John Doe',
  role: UserRole.customer,
);

ref.read(userProvider.notifier).signIn(
  email: 'email@example.com',
  password: 'password123',
);

ref.read(userProvider.notifier).signOut();
ref.read(userProvider.notifier).getCurrentUser();
ref.read(userProvider.notifier).updateProfile(appUser);
ref.read(userProvider.notifier).sendPasswordReset('email@example.com');
```

**State Fields**:
- `user: AppUser?` - Current user or null
- `isLoading: bool` - Loading during operations
- `error: String?` - Error message if failed
- `isAuthenticated: bool` - Auth status

---

### 2. Menu (Browse & Save Presets)
**Provider**: `menuProvider`
**State Type**: `MenuState`

**Available Actions**:
```dart
ref.read(menuProvider.notifier).fetchMenu('store_id');

ref.read(menuProvider.notifier).fetchMenuItem('item_id');

ref.read(menuProvider.notifier).search(
  storeId: 'store_id',
  query: 'cappuccino',
);

ref.read(menuProvider.notifier).savePreset(customPreset);

ref.read(menuProvider.notifier).deletePreset('preset_id', 'user_id');

ref.read(menuProvider.notifier).fetchCustomPresets(
  userId: 'user_id',
  storeId: 'store_id', // optional
);
```

**State Fields**:
- `menuItems: List<MenuItem>` - Store menu
- `selectedMenuItem: MenuItem?` - Selected item
- `searchResults: List<MenuItem>` - Search results
- `customPresets: List<CustomPreset>` - User's presets
- `isLoading: bool` - Loading state
- `error: String?` - Error message

---

### 3. Loyalty (Points & Rewards)
**Provider**: `loyaltyProvider`
**State Type**: `LoyaltyState`

**Available Actions**:
```dart
ref.read(loyaltyProvider.notifier).fetchLoyaltyAccount('user_id');

ref.read(loyaltyProvider.notifier).addPoints(
  userId: 'user_id',
  points: 50,
);

ref.read(loyaltyProvider.notifier).redeemVoucher(
  userId: 'user_id',
  voucherId: 'voucher_id',
);

ref.read(loyaltyProvider.notifier).fetchRewardTiers();

ref.read(loyaltyProvider.notifier).fetchEligibleRewards('user_id');

ref.read(loyaltyProvider.notifier).fetchCustomerVouchers('user_id');
```

**State Fields**:
- `loyaltyAccount: LoyaltyAccount?` - User's loyalty account
- `rewardTiers: List<RewardTier>` - Available tiers
- `eligibleRewards: List<Reward>` - Available rewards
- `customerVouchers: List<Voucher>` - User's vouchers
- `isLoading: bool` - Loading state
- `error: String?` - Error message

---

### 4. Order (Place & Manage Orders)
**Provider**: `orderProvider`
**State Type**: `OrderState`

**Available Actions**:
```dart
ref.read(orderProvider.notifier).createOrder(orderEntity);

ref.read(orderProvider.notifier).fetchOrders('user_id');

ref.read(orderProvider.notifier).fetchOrderDetails('order_id');

ref.read(orderProvider.notifier).updateOrderStatus(
  orderId: 'order_id',
  status: 'completed',
);

ref.read(orderProvider.notifier).fetchSummaryReport(DateTime.now());
```

**State Fields**:
- `orders: List<OrderEntity>` - User's orders
- `selectedOrder: OrderEntity?` - Selected order
- `summary: OrderSummary?` - Summary report
- `isLoading: bool` - Loading state
- `error: String?` - Error message

---

### 5. Transaction (Payments)
**Provider**: `transactionProvider`
**State Type**: `TransactionState`

**Available Actions**:
```dart
ref.read(transactionProvider.notifier).createTransaction(orderEntity);

ref.read(transactionProvider.notifier).fetchTransactions('user_id');

ref.read(transactionProvider.notifier).fetchTransactionById('transaction_id');

ref.read(transactionProvider.notifier).cancelTransaction('transaction_id');

ref.read(transactionProvider.notifier).updateTransactionStatus(
  transactionId: 'transaction_id',
  status: 'pending',
);
```

**State Fields**:
- `transactions: List<OrderEntity>` - User's transactions
- `selectedTransaction: OrderEntity?` - Selected transaction
- `isLoading: bool` - Loading state
- `error: String?` - Error message

---

### 6. Notification (Promos & Alerts)
**Provider**: `notificationProvider`
**State Type**: `NotificationState`

**Available Actions**:
```dart
ref.read(notificationProvider.notifier).createPromo(promo);

ref.read(notificationProvider.notifier).updatePromo(promo);

ref.read(notificationProvider.notifier).fetchActivePromos();

ref.read(notificationProvider.notifier).sendNotificationToUser(
  userId: 'user_id',
  title: 'Special Offer',
  message: '20% off today!',
  data: {'offerType': 'discount'},
);

ref.read(notificationProvider.notifier).sendNotificationToAll(
  title: 'New Menu Item',
  message: 'Try our new Matcha Latte!',
);

ref.read(notificationProvider.notifier).fetchNotificationHistory('user_id');
```

**State Fields**:
- `activePromos: List<Promo>` - Active promotions
- `notificationHistory: List<Map>` - Notification log
- `isLoading: bool` - Loading state
- `error: String?` - Error message
- `successMessage: String?` - Success feedback

---

## Common Patterns

### Watching State in UI
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProvider);
    
    if (state.isLoading) {
      return CircularProgressIndicator();
    }
    
    if (state.error != null) {
      return Text('Error: ${state.error}');
    }
    
    return Text('User: ${state.user?.name}');
  }
}
```

### Calling Actions
```dart
ElevatedButton(
  onPressed: () {
    ref.read(userProvider.notifier).signIn(
      email: 'user@example.com',
      password: 'password123',
    );
  },
  child: Text('Sign In'),
)
```

### Selective Watching (Performance Optimization)
```dart
// Only rebuild when isLoading changes
final isLoading = ref.watch(
  userProvider.select((state) => state.isLoading)
);

// Only rebuild when error changes
final error = ref.watch(
  userProvider.select((state) => state.error)
);
```

### Listen for Changes
```dart
ref.listen(userProvider, (previous, next) {
  if (next.isAuthenticated && previous?.isAuthenticated != true) {
    // User just logged in
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Welcome back!')),
    );
  }
});
```

---

## Error Handling Pattern

All providers use `Either<Failure, T>` pattern. Errors are automatically converted to `error` field in state:

```dart
// In any provider action
result.fold(
  (failure) => state = state.copyWith(
    isLoading: false,
    error: failure.toString(),  // Captured here
  ),
  (data) => state = state.copyWith(
    isLoading: false,
    data: data,
  ),
);
```

Display in UI:
```dart
if (state.error != null) {
  showErrorDialog(context, state.error!);
}
```

---

## Import Everything

```dart
// Single import gets all providers
import 'presentation_providers.dart';
```

Or import individual features:
```dart
import 'package:brewease_and_reward/features/user/presentation/providers/user_provider.dart';
import 'package:brewease_and_reward/features/menu/presentation/providers/menu_provider.dart';
// ... etc
```

---

## Testing Example

```dart
test('sign up creates user', () async {
  final container = ProviderContainer();
  final notifier = container.read(userProvider.notifier);
  
  await notifier.signUp(
    email: 'test@example.com',
    password: 'password123',
  );
  
  final state = container.read(userProvider);
  expect(state.isAuthenticated, isTrue);
  expect(state.user, isNotNull);
});
```

---

**For detailed architecture info, see**: `PRESENTATION_ARCHITECTURE.md`

# BrewEase Rewards - Presentation Layer Index

## 📋 Quick Navigation

### 🎯 Getting Started
1. **First Time?** → Start with [IMPLEMENTATION_COMPLETE.txt](IMPLEMENTATION_COMPLETE.txt)
2. **Need Details?** → Read [PRESENTATION_ARCHITECTURE.md](PRESENTATION_ARCHITECTURE.md)
3. **Building UI?** → Use [PROVIDERS_QUICK_REFERENCE.md](PROVIDERS_QUICK_REFERENCE.md)
4. **Planning Work?** → Follow [DEVELOPER_CHECKLIST.md](DEVELOPER_CHECKLIST.md)

---

## 📁 Project Structure

```
BrewEase_-_Reward/
├── lib/
│   ├── features/
│   │   ├── user/
│   │   │   └── presentation/providers/
│   │   │       └── user_provider.dart          ⭐ Authentication
│   │   ├── menu/
│   │   │   └── presentation/providers/
│   │   │       └── menu_provider.dart          ⭐ Menu & Presets
│   │   ├── loyalty/
│   │   │   └── presentation/providers/
│   │   │       └── loyalty_provider.dart       ⭐ Points & Rewards
│   │   ├── order/
│   │   │   └── presentation/providers/
│   │   │       └── order_provider.dart         ⭐ Order Management
│   │   ├── transaction/
│   │   │   └── presentation/providers/
│   │   │       └── transaction_provider.dart   ⭐ Payment Handling
│   │   └── notification/
│   │       └── presentation/providers/
│   │           └── notification_provider.dart  ⭐ Promotions & Alerts
│   │
│   └── presentation_providers.dart             📦 Central Export
│
├── IMPLEMENTATION_COMPLETE.txt                 📋 Summary & Status
├── PRESENTATION_ARCHITECTURE.md                📚 Full Architecture Guide
├── PRESENTATION_LAYER_SUMMARY.md               📊 Implementation Stats
├── PROVIDERS_QUICK_REFERENCE.md                🔧 API Reference
└── DEVELOPER_CHECKLIST.md                      ✅ Development Tasks
```

---

## 🔗 Provider Features

### User Provider
**File**: `lib/features/user/presentation/providers/user_provider.dart`
- **Manages**: Authentication & User Profile
- **Use Cases**: 6 (SignUp, SignIn, SignOut, GetCurrentUser, UpdateProfile, SendPasswordReset)
- **Key State**: user, isLoading, error, isAuthenticated
- **Usage**: `ref.watch(userProvider)` / `ref.read(userProvider.notifier)`

### Menu Provider
**File**: `lib/features/menu/presentation/providers/menu_provider.dart`
- **Manages**: Menu Browsing & Custom Presets
- **Use Cases**: 6 (GetMenu, GetMenuItem, SearchMenu, SaveCustomPreset, DeleteCustomPreset, GetCustomPresets)
- **Key State**: menuItems, searchResults, customPresets
- **Usage**: `ref.watch(menuProvider)` / `ref.read(menuProvider.notifier)`

### Loyalty Provider
**File**: `lib/features/loyalty/presentation/providers/loyalty_provider.dart`
- **Manages**: Loyalty Points & Rewards
- **Use Cases**: 6 (GetLoyaltyAccount, AddLoyaltyPoints, RedeemVoucher, GetRewardTiers, GetEligibleRewards, GetCustomerVouchers)
- **Key State**: loyaltyAccount, rewardTiers, eligibleRewards, customerVouchers
- **Usage**: `ref.watch(loyaltyProvider)` / `ref.read(loyaltyProvider.notifier)`

### Order Provider
**File**: `lib/features/order/presentation/providers/order_provider.dart`
- **Manages**: Order Lifecycle
- **Use Cases**: 5 (CreateOrder, GetOrders, GetOrderDetails, UpdateOrderStatus, GetSummaryReport)
- **Key State**: orders, selectedOrder, summary
- **Usage**: `ref.watch(orderProvider)` / `ref.read(orderProvider.notifier)`

### Transaction Provider
**File**: `lib/features/transaction/presentation/providers/transaction_provider.dart`
- **Manages**: Payment Transactions
- **Use Cases**: 5 (CreateOrder, GetOrders, GetOrderById, CancelOrder, UpdateOrderStatus)
- **Key State**: transactions, selectedTransaction
- **Usage**: `ref.watch(transactionProvider)` / `ref.read(transactionProvider.notifier)`

### Notification Provider
**File**: `lib/features/notification/presentation/providers/notification_provider.dart`
- **Manages**: Promotions & Notifications
- **Use Cases**: 6 (CreatePromo, UpdatePromo, GetActivePromos, SendNotificationToUser, SendNotificationToAll, GetNotificationHistory)
- **Key State**: activePromos, notificationHistory, successMessage
- **Usage**: `ref.watch(notificationProvider)` / `ref.read(notificationProvider.notifier)`

---

## 📖 Documentation Files

| File | Purpose | Read Time |
|------|---------|-----------|
| [IMPLEMENTATION_COMPLETE.txt](IMPLEMENTATION_COMPLETE.txt) | Visual summary of what was created | 5 min |
| [PRESENTATION_ARCHITECTURE.md](PRESENTATION_ARCHITECTURE.md) | Detailed architecture and patterns | 15 min |
| [PROVIDERS_QUICK_REFERENCE.md](PROVIDERS_QUICK_REFERENCE.md) | API reference with code examples | 10 min |
| [PRESENTATION_LAYER_SUMMARY.md](PRESENTATION_LAYER_SUMMARY.md) | Stats and implementation details | 8 min |
| [DEVELOPER_CHECKLIST.md](DEVELOPER_CHECKLIST.md) | Tasks for UI development phases | 10 min |

---

## 🚀 Common Tasks

### I need to...

**Display user profile**
```dart
final userState = ref.watch(userProvider);
Text('${userState.user?.name}');
```

**Sign user in**
```dart
await ref.read(userProvider.notifier).signIn(
  email: 'user@example.com',
  password: 'password123',
);
```

**Load menu items**
```dart
await ref.read(menuProvider.notifier).fetchMenu('store_id');
```

**Search menu**
```dart
await ref.read(menuProvider.notifier).search(
  storeId: 'store_id',
  query: 'cappuccino',
);
```

**Get loyalty points**
```dart
await ref.read(loyaltyProvider.notifier).fetchLoyaltyAccount('user_id');
```

**Create order**
```dart
await ref.read(orderProvider.notifier).createOrder(orderEntity);
```

**Send notification**
```dart
await ref.read(notificationProvider.notifier).sendNotificationToUser(
  userId: 'user_id',
  title: 'Special Offer',
  message: '20% off today!',
);
```

---

## 💡 Design Patterns Used

### StateNotifier Pattern
Each feature has:
- **State class**: Immutable data container with `copyWith()`
- **StateNotifier**: Business logic orchestrating use cases
- **Provider**: Dependency injection and state exposure

### Error Handling
- All use cases return `Either<Failure, T>`
- Errors automatically captured in state
- Display errors through `state.error`

### Reactive UI
- Watch state changes with `ref.watch()`
- Selective updates with `.select()`
- Automatic rebuilds on state changes

### Dependency Injection
```
Firebase → Data Sources → Repositories → Use Cases → State Notifiers → UI
```

---

## 🧪 Testing Examples

### Test a provider action
```dart
test('user sign up creates account', () async {
  final container = ProviderContainer();
  final notifier = container.read(userProvider.notifier);
  
  await notifier.signUp(
    email: 'test@example.com',
    password: 'password123',
  );
  
  final state = container.read(userProvider);
  expect(state.isAuthenticated, isTrue);
});
```

---

## ⚙️ Configuration

### Enable Riverpod (in pubspec.yaml)
```yaml
dependencies:
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.2.0

dev_dependencies:
  riverpod_generator: ^2.3.0
  build_runner: ^2.4.0
```

### Firebase Setup (in main.dart)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}
```

---

## 🎯 Quick Checklist

Before building UI:
- [ ] Read IMPLEMENTATION_COMPLETE.txt
- [ ] Review PRESENTATION_ARCHITECTURE.md
- [ ] Bookmark PROVIDERS_QUICK_REFERENCE.md
- [ ] Understand StateNotifier pattern
- [ ] Know how to watch providers
- [ ] Know how to call actions
- [ ] Understand error handling

---

## 📞 Support Resources

### Need Help With...

**Riverpod patterns?**
- Check [PRESENTATION_ARCHITECTURE.md](PRESENTATION_ARCHITECTURE.md)
- Example code in [PROVIDERS_QUICK_REFERENCE.md](PROVIDERS_QUICK_REFERENCE.md)

**Specific provider API?**
- Lookup in [PROVIDERS_QUICK_REFERENCE.md](PROVIDERS_QUICK_REFERENCE.md)
- Check provider file directly

**Architecture questions?**
- See [PRESENTATION_ARCHITECTURE.md](PRESENTATION_ARCHITECTURE.md)
- Review [DEVELOPER_CHECKLIST.md](DEVELOPER_CHECKLIST.md)

**Implementation status?**
- Check [PRESENTATION_LAYER_SUMMARY.md](PRESENTATION_LAYER_SUMMARY.md)
- View [IMPLEMENTATION_COMPLETE.txt](IMPLEMENTATION_COMPLETE.txt)

**Planning next phase?**
- Follow [DEVELOPER_CHECKLIST.md](DEVELOPER_CHECKLIST.md)
- Create screens using template

---

## 🎉 You're All Set!

The presentation layer is production-ready. All 34 use cases are integrated, all state management is set up, and comprehensive documentation is provided.

**Start building screens!** 🚀

---

**Last Updated**: December 17, 2025
**Status**: ✅ Complete & Ready for UI Development
**Architecture**: Clean Architecture + Riverpod
**Quality**: Production-Ready

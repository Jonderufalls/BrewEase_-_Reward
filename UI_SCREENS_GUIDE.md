# UI Screens & Navigation Guide

## Overview

This document provides a comprehensive guide to all UI screens created for the BrewEase Rewards application. All screens are built using:

- **State Management:** flutter_riverpod (ConsumerWidget/ConsumerStatefulWidget)
- **Form Handling:** flutter_form_builder with validators
- **Styling:** BrewEaseTheme (lib/core/theme/theme.dart)
- **Architecture:** Clean Architecture with proper separation of concerns

## Features & Screens

### 1. User Feature (Authentication & Profile)

#### SignInScreen
**Path:** `lib/features/user/presentation/screens/sign_in_screen.dart`
**Route:** `/sign-in`
**Purpose:** User login

**Key Features:**
- Email & password input with validation
- Form validation using FormBuilder
- Error handling with snackbars
- Navigation to sign up screen
- "Forgot Password" link
- Loading state management

**Provider Used:** `userProvider`
**State Listener:** Redirects to `/home` on successful login

**Code Example:**
```dart
Navigator.of(context).pushReplacementNamed('/sign-in');
```

---

#### SignUpScreen
**Path:** `lib/features/user/presentation/screens/sign_up_screen.dart`
**Route:** `/sign-up`
**Purpose:** User registration

**Key Features:**
- Full name, email, password validation
- Password confirmation matching
- Email format validation
- Password visibility toggle
- Success feedback
- Auto-navigation on account creation

**Provider Used:** `userProvider`
**Form Fields:**
- `name` (required, min 2 chars)
- `email` (required, valid email format)
- `password` (required, min 6 chars)
- `confirmPassword` (must match password)

**Code Example:**
```dart
userNotifier.signUp(
  email: formData['email'],
  password: formData['password'],
  name: formData['name'],
);
```

---

#### ProfileScreen
**Path:** `lib/features/user/presentation/screens/profile_screen.dart`
**Route:** `/profile`
**Purpose:** User profile view & management

**Key Features:**
- User avatar with initials
- Contact information display
- Account details
- Edit profile button
- Change password option
- Sign out functionality
- Confirmation dialog for logout

**Provider Used:** `userProvider`

**UI Sections:**
1. Profile header with avatar
2. Contact Information (Email, Phone)
3. Account section (Role, Member Since)
4. Action buttons (Change Password, Sign Out)

**Code Example:**
```dart
Text(user?.name ?? 'User')
```

---

### 2. Menu Feature (Browse & Customize)

#### MenuScreen
**Path:** `lib/features/menu/presentation/screens/menu_screen.dart`
**Route:** `/menu`
**Purpose:** Browse coffee menu

**Key Features:**
- Search functionality with real-time filtering
- Category filtering (All, Coffee, Tea, Pastries, Beverages)
- Menu item cards with prices
- "Popular" badges
- Item availability status
- Navigation to item details

**Provider Used:** `menuProvider`
**Methods Called:**
- `fetchMenu('store_1')`
- `search(storeId: 'store_1', query: value)`

**UI Components:**
- SearchBar with clear button
- Category FilterChips
- Menu ItemCards with:
  - Item image placeholder
  - Name & description
  - Price
  - Popular indicator

**Code Example:**
```dart
ref.read(menuProvider.notifier).fetchMenu('store_1');
ref.read(menuProvider.notifier).search(
  storeId: 'store_1',
  query: searchValue,
);
```

---

#### MenuDetailScreen
**Path:** `lib/features/menu/presentation/screens/menu_detail_screen.dart`
**Route:** `/menu-detail`
**Parameters:** `MenuItem item`
**Purpose:** View item details and customize

**Key Features:**
- Large item image
- Detailed description
- Availability status with badge
- Quantity selector (+/- buttons)
- Add to cart button
- Responsive layout

**Provider Used:** None (stateful only)
**State Variables:**
- `_quantity` (int)
- `_selectedModifiers` (Map<String, String>)

**UI Flow:**
1. Image section
2. Item info (name, category, price)
3. Availability badge
4. Quantity selector
5. Add to cart action

---

### 3. Loyalty Feature (Points & Rewards)

#### LoyaltyScreen
**Path:** `lib/features/loyalty/presentation/screens/loyalty_screen.dart`
**Route:** `/loyalty`
**Purpose:** View loyalty account & rewards

**Key Features:**
- Points display in gradient card
- Current tier badge
- Progress bar to next tier
- Quick action buttons (Vouchers, Rewards)
- Reward tiers list
- Voucher display (recent 3)
- Loading state management

**Provider Used:** `loyaltyProvider`
**Methods Called:**
- `fetchLoyaltyAccount('customer_1')`
- `fetchRewardTiers()`
- `fetchEligibleRewards('customer_1')`
- `fetchCustomerVouchers('customer_1')`

**UI Sections:**
1. **Loyalty Card** (gradient background)
   - Points counter
   - Current tier
   - Progress bar

2. **Quick Actions**
   - Vouchers button
   - Rewards button

3. **Reward Tiers**
   - Tier cards with benefits
   - Discount percentage

4. **My Vouchers**
   - Recent vouchers
   - Redemption status

**Code Example:**
```dart
ref.read(loyaltyProvider.notifier).fetchLoyaltyAccount('customer_1');
ref.read(loyaltyProvider.notifier).fetchRewardTiers();
```

---

### 4. Order Feature (Place & Track)

#### OrdersScreen
**Path:** `lib/features/order/presentation/screens/orders_screen.dart`
**Route:** `/orders`
**Purpose:** View order history

**Key Features:**
- Order list with details
- Status badges (color-coded)
- Order date display
- Total amount
- Error handling with retry
- Empty state
- Navigation to order details

**Provider Used:** `orderProvider`
**Method Called:** `fetchOrders()`

**UI Components:**
- OrderCard with:
  - Order ID
  - Date
  - Status (completed, pending, cancelled)
  - Total amount

**Status Colors:**
- Completed: Green (BrewEaseTheme.successGreen)
- Pending: Orange
- Cancelled: Red (BrewEaseTheme.warningRed)

**Code Example:**
```dart
ref.read(orderProvider.notifier).fetchOrders();
```

---

### 5. Transaction Feature (Payment History)

#### TransactionsScreen
**Path:** `lib/features/transaction/presentation/screens/transactions_screen.dart`
**Route:** `/transactions`
**Purpose:** View transaction history

**Key Features:**
- Transaction list with icons
- Status indication with color coding
- Amount display
- Date tracking
- Quick navigation to details
- Error handling

**Provider Used:** `transactionProvider`
**Method Called:** `fetchTransactions('customer_1')`

**UI Components:**
- TransactionCard with:
  - Status icon (check, schedule, cancel)
  - Transaction ID
  - Date
  - Amount
  - Status badge

**Status Icons:**
- Completed: check_circle
- Pending: schedule
- Cancelled: cancel
- Default: info

**Code Example:**
```dart
ref.read(transactionProvider.notifier).fetchTransactions('customer_1');
```

---

### 6. Notification Feature (Promos & Alerts)

#### NotificationsScreen
**Path:** `lib/features/notification/presentation/screens/notifications_screen.dart`
**Route:** `/notifications`
**Purpose:** View promos and notification history

**Key Features:**
- Active promotions section
- Notification history with timestamps
- Gradient promo cards
- Status indication
- Promo details with discount
- Empty states

**Provider Used:** `notificationProvider`
**Methods Called:**
- `fetchActivePromos()`
- `fetchNotificationHistory('customer_1')`

**UI Sections:**
1. **Active Promotions**
   - Gradient cards
   - Discount percentage
   - Validity dates
   - "Learn More" button

2. **Recent Notifications**
   - Notification icon
   - Title & body
   - Timestamp
   - Message preview

**Code Example:**
```dart
ref.read(notificationProvider.notifier).fetchActivePromos();
ref.read(notificationProvider.notifier).fetchNotificationHistory('customer_1');
```

---

## Navigation Setup

### Route Configuration

Add the following routes to your main.dart:

```dart
GoRouter(
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(
      path: '/menu-detail',
      builder: (context, state) => MenuDetailScreen(
        item: state.extra as MenuItem,
      ),
    ),
    GoRoute(
      path: '/loyalty',
      builder: (context, state) => const LoyaltyScreen(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => const TransactionsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ],
)
```

### Or using Navigator.pushNamed:

```dart
// Navigation examples
Navigator.of(context).pushNamed('/menu');
Navigator.of(context).pushNamed('/profile');
Navigator.of(context).pushReplacementNamed('/sign-in');
Navigator.of(context).pushNamed('/loyalty');
```

---

## Form Validation Patterns

All screens using forms follow the flutter_form_builder pattern:

### Example from SignInScreen:

```dart
FormBuilder(
  key: _formKey,
  child: Column(
    children: [
      FormBuilderTextField(
        name: 'email',
        decoration: InputDecoration(
          labelText: 'Email Address',
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
          FormBuilderValidators.email(context),
        ]),
        keyboardType: TextInputType.emailAddress,
      ),
      FormBuilderTextField(
        name: 'password',
        decoration: InputDecoration(
          labelText: 'Password',
          prefixIcon: const Icon(Icons.lock_outline),
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
          FormBuilderValidators.minLength(context, 6),
        ]),
        obscureText: true,
      ),
    ],
  ),
);
```

### Form Submission:

```dart
if (_formKey.currentState?.saveAndValidate() ?? false) {
  final formData = _formKey.currentState!.value;
  userNotifier.signIn(
    email: formData['email'],
    password: formData['password'],
  );
}
```

---

## Theming

All screens use `BrewEaseTheme` for consistent styling:

### Color Palette Used:
- **Primary:** `BrewEaseTheme.primaryBrown` (#6F4E37)
- **Accent:** `BrewEaseTheme.accentOrange` (#E8956A)
- **Background:** `BrewEaseTheme.backgroundColor` (#FAF7F2)
- **Text:** `BrewEaseTheme.textDark` (#2C2416)
- **Success:** `BrewEaseTheme.successGreen`
- **Error:** `BrewEaseTheme.warningRed`

### Text Styles:
```dart
Theme.of(context).textTheme.displaySmall
Theme.of(context).textTheme.headlineMedium
Theme.of(context).textTheme.titleLarge
Theme.of(context).textTheme.bodyMedium
```

---

## Error Handling Pattern

All screens implement consistent error handling:

```dart
if (state.error != null) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          size: 64,
          color: BrewEaseTheme.warningRed,
        ),
        const SizedBox(height: 16),
        Text(state.error!),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            ref.read(provider.notifier).fetch();
          },
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
```

---

## State Listening Pattern

Screens listen to state changes for feedback:

```dart
ref.listen(provider, (previous, next) {
  if (next.error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(next.error!),
        backgroundColor: BrewEaseTheme.warningRed,
      ),
    );
  }
  if (next.isSuccessful && previous?.isSuccessful != true) {
    // Handle success
  }
});
```

---

## Dependencies

### Required Packages in pubspec.yaml:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  flutter_form_builder: ^7.8.0
  form_builder_validators: ^9.1.0
  google_fonts: ^6.1.0
```

---

## Next Steps

1. ✅ **UI Screens Created** - All feature screens implemented
2. ✅ **State Management** - StateNotifierProvider integration
3. ✅ **Form Handling** - flutter_form_builder setup
4. ✅ **Theming** - BrewEaseTheme applied throughout
5. ⏭️ **Navigation Setup** - Configure routes in main.dart
6. ⏭️ **Testing** - Create widget tests for each screen
7. ⏭️ **Polish** - Add animations and transitions

---

**Status:** Ready for navigation setup and integration testing ✅

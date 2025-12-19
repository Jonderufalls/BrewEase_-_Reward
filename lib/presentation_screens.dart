/// Presentation Layer - UI Screens Index
/// 
/// This file exports all presentation screens for the BrewEase Rewards application.
/// Screens are organized by feature and follow a consistent structure using:
/// - ConsumerWidget/ConsumerStatefulWidget from flutter_riverpod
/// - StateNotifierProvider for state management
/// - flutter_form_builder for form handling
/// - BrewEaseTheme for consistent styling
library;

// User Feature Screens
export 'features/user/presentation/screens/sign_in_screen.dart';
export 'features/user/presentation/screens/sign_up_screen.dart';
export 'features/user/presentation/screens/profile_screen.dart';

// Menu Feature Screens
export 'features/menu/presentation/screens/menu_screen.dart';
export 'features/menu/presentation/screens/menu_detail_screen.dart';

// Loyalty Feature Screens
export 'features/loyalty/presentation/screens/loyalty_screen.dart';

// Order Feature Screens
export 'features/order/presentation/screens/orders_screen.dart';

// Transaction Feature Screens
export 'features/transaction/presentation/screens/transactions_screen.dart';

// Notification Feature Screens
export 'features/notification/presentation/screens/notifications_screen.dart';

# Quick Start Guide 🚀

## Installation & Setup (5 minutes)

### Step 1: Install Dependencies

```bash
cd c:\Users\Johnd\OneDrive\Desktop\Com_Prog-grouptask\grouptask4\Grouptask4-project-data\Grouptask4-Feature4\BrewEase_-_Reward

flutter pub get
```

**What this does**: Downloads and installs all packages specified in `pubspec.yaml` including:
- flutter_riverpod (state management)
- flutter_form_builder (forms)
- go_router (navigation)
- firebase_core (backend)
- And all other dependencies

### Step 2: Run the Application

```bash
flutter run -d web
```

**What this does**: Builds and launches the Flutter web application in your default browser.

### Step 3: Test the Navigation

1. **App opens** → Sign-in screen appears ✓
2. **Enter test credentials**:
   - Email: `test@example.com`
   - Password: `123456`
3. **Click "Sign In"** → Redirects to menu screen ✓
4. **Click bottom nav tabs** → Each screen loads ✓
5. **Try sign-out** → Returns to sign-in screen ✓

---

## File Structure Overview

```
BrewEase_-_Reward/
├── lib/
│   ├── main.dart ........................... Entry point
│   ├── app.dart ............................ Router configuration
│   ├── presentation_screens.dart ......... Screen exports
│   ├── features/
│   │   ├── user/
│   │   │   └── presentation/screens/
│   │   │       ├── sign_in_screen.dart
│   │   │       ├── sign_up_screen.dart
│   │   │       └── profile_screen.dart
│   │   ├── menu/
│   │   │   └── presentation/screens/
│   │   │       ├── menu_screen.dart
│   │   │       └── menu_detail_screen.dart
│   │   ├── loyalty/
│   │   │   └── presentation/screens/
│   │   │       └── loyalty_screen.dart
│   │   ├── order/
│   │   │   └── presentation/screens/
│   │   │       └── orders_screen.dart
│   │   ├── transaction/
│   │   │   └── presentation/screens/
│   │   │       └── transactions_screen.dart
│   │   └── notification/
│   │       └── presentation/screens/
│   │           └── notifications_screen.dart
│   └── core/
│       └── theme/
│           └── theme.dart
├── pubspec.yaml ............................ Dependencies
├── COMPLETE_UI_IMPLEMENTATION.md ....... Full documentation
├── NAVIGATION_SETUP_COMPLETE.md ........ Navigation guide
└── UI_SCREENS_GUIDE.md ................... Screen details

```

---

## Screen Map

### Authentication Screens (No Auth Required)

| Screen | Path | Route | Key Features |
|--------|------|-------|--------------|
| Sign In | `/sign-in` | `/sign-in` | Email/password form, forgot password link |
| Sign Up | `/sign-up` | `/sign-up` | Registration with name, email, password |

### Main Screens (Auth Required - Bottom Navigation)

| Tab | Screen | Path | Key Features |
|-----|--------|------|--------------|
| 🏠 Home | Menu | `/home` | Search, filter by category, browse items |
| 🛍️ Orders | Orders | `/orders` | Order history, status tracking |
| ⭐ Loyalty | Loyalty | `/loyalty` | Points, tiers, vouchers |
| 🔔 Promos | Notifications | `/notifications` | Active promos, notification history |
| 👤 Profile | Profile | `/profile` | User info, settings, logout |

---

## Form Validation Reference

### Sign-In Form
- **Email**: Required, valid format
- **Password**: Required, minimum 6 characters

**Example Valid Input**:
```
Email: user@example.com
Password: password123
```

### Sign-Up Form
- **Name**: Required, minimum 2 characters
- **Email**: Required, valid format
- **Password**: Required, minimum 6 characters
- **Confirm Password**: Must match password field

**Example Valid Input**:
```
Name: John Doe
Email: john@example.com
Password: SecurePass123
Confirm Password: SecurePass123
```

### Validation Rules
- ✅ **Required**: Fields marked as required cannot be empty
- ✅ **Email**: Must be valid email format (user@domain.com)
- ✅ **Min Length**: Password minimum 6 characters, name minimum 2
- ✅ **Match**: Confirm password must exactly match password field

---

## Color Palette (BrewEaseTheme)

```
Primary Brown:      #6F4E37 (Coffee color)
Accent Orange:      #E8956A (Warm accent)
Background Cream:   #FAF6F1 (Light cream)
Dark Text:          #2C2C2C (Dark brown)
Light Text:         #999999 (Light grey)

Status Colors:
├─ Success Green:   #4CAF50 (Completed orders)
├─ Warning Orange:  #FF9800 (Pending items)
└─ Error Red:        #F44336 (Cancelled)
```

---

## Common Tasks

### Navigate Between Screens

```dart
// From any screen
context.go('/loyalty');          // Replace current
context.push('/menu-detail');    // Add to stack
context.pop();                   // Go back
```

### Watch Provider State

```dart
final state = ref.watch(menuProvider);

if (state.isLoading) {
  // Show loading spinner
}
if (state.hasError) {
  // Show error message
}
if (state.hasValue) {
  // Show data
}
```

### Listen for Changes

```dart
ref.listen(userProvider, (previous, next) {
  if (next.hasError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${next.error}')),
    );
  }
});
```

### Submit a Form

```dart
ElevatedButton(
  onPressed: () {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      ref.read(userProvider.notifier).signIn(
        formData['email'],
        formData['password'],
      );
    }
  },
  child: Text('Sign In'),
)
```

---

## Testing Scenarios

### Scenario 1: Sign Up and Sign In
1. Click "Sign Up" on sign-in screen
2. Fill in name, email, password (must match)
3. Click "Register" button
4. Should return to sign-in
5. Enter same email/password
6. Click "Sign In"
7. Should redirect to home (menu screen)

### Scenario 2: Browse Menu
1. After signing in, see MenuScreen
2. Type in search box → filters items
3. Click category FilterChips → filters by category
4. Click on menu item card → goes to detail screen
5. Adjust quantity with +/- buttons
6. Click "Add to Cart" → shows snackbar

### Scenario 3: View Profile
1. Click Profile tab at bottom
2. See user avatar, info sections
3. Click "Sign Out" button
4. Confirm logout in dialog
5. Should return to sign-in screen

### Scenario 4: Check Loyalty Points
1. Click Loyalty tab at bottom
2. See points card with progress bar
3. See reward tiers list
4. See vouchers section
5. All data loads without errors

---

## Troubleshooting

### Issue: "Target of URI doesn't exist" error
**Cause**: Dependencies not installed
**Solution**:
```bash
flutter pub get
flutter pub upgrade
```

### Issue: "The name 'GoRouter' isn't a type" error
**Cause**: go_router not in pubspec.yaml
**Solution**: Verify `pubspec.yaml` has:
```yaml
go_router: ^13.0.0
```
Then run `flutter pub get`

### Issue: Form fields not validating
**Cause**: autovalidateMode not set
**Solution**: Ensure FormBuilder has:
```dart
FormBuilder(
  autovalidateMode: AutovalidateMode.onUserInteraction,
  // ...
)
```

### Issue: Buttons disabled after form submission
**Cause**: Loading state from provider
**Solution**: This is expected! Button re-enables when:
- Success: Navigation occurs
- Error: Snackbar shows, button re-enables

### Issue: App won't hot reload
**Solution**: Use `r` for hot reload, `R` for hot restart
```
Press 'r' to hot reload, 'R' to hot restart, 'q' to quit
```

---

## Development Workflow

### Making Changes

1. **Edit a screen file**:
   ```
   lib/features/[feature]/presentation/screens/[screen].dart
   ```

2. **Save the file** (Ctrl+S)

3. **Hot reload** (Press 'r' in terminal)
   - Changes appear instantly
   - App state preserved
   - Fast feedback loop

4. **Hot restart** (Press 'R' in terminal)
   - Full app restart
   - State reset
   - Use when hot reload fails

### Adding a New Screen

1. Create file in `lib/features/[feature]/presentation/screens/`
2. Import it in `lib/presentation_screens.dart`
3. Add route to `lib/app.dart`
4. Add navigation link from existing screen

Example:
```dart
// 1. Create new screen file
GoRoute(
  path: '/new-screen',
  builder: (context, state) => const NewScreen(),
),

// 2. Navigate to it
context.go('/new-screen');
```

---

## Documentation Files

| File | Purpose | Read Time |
|------|---------|-----------|
| [COMPLETE_UI_IMPLEMENTATION.md](COMPLETE_UI_IMPLEMENTATION.md) | Full technical details | 15 min |
| [NAVIGATION_SETUP_COMPLETE.md](NAVIGATION_SETUP_COMPLETE.md) | Router configuration | 10 min |
| [UI_SCREENS_GUIDE.md](UI_SCREENS_GUIDE.md) | Individual screen specs | 12 min |
| [QUICK_START.md](QUICK_START.md) ← You are here | Fast reference | 3 min |

---

## Key Commands Reference

```bash
# Installation
flutter pub get              # Install dependencies
flutter pub upgrade          # Upgrade to latest versions

# Development
flutter run -d web           # Run on web
flutter run -d windows       # Run on Windows
flutter run -d chrome        # Run on Chrome browser

# Hot reload/restart
# In running terminal:
r                            # Hot reload (fastest)
R                            # Hot restart
w                            # Show widget inspector
q                            # Quit

# Cleaning
flutter clean                # Clean build files
flutter pub cache clean      # Clear pub cache

# Building
flutter build web            # Build for web deployment
flutter build apk            # Build for Android
flutter build ios            # Build for iOS
```

---

## Next Steps After Setup

### ✅ Completed
- [x] All 9 UI screens created
- [x] Navigation system configured
- [x] Form validation implemented
- [x] State management integrated
- [x] Theme applied throughout
- [x] Documentation created

### 🔄 To Do
1. [ ] **Run** `flutter pub get`
2. [ ] **Test** with `flutter run -d web`
3. [ ] **Verify** sign-in screen loads
4. [ ] **Test** form validation
5. [ ] **Check** bottom navigation works

### 📋 Future Work
- [ ] Connect Firebase database
- [ ] Create detail screens
- [ ] Add animations
- [ ] Implement cart system
- [ ] Add payment processing
- [ ] Create unit tests
- [ ] Deploy to production

---

## Need Help?

### Documentation
- **Full Details**: See [COMPLETE_UI_IMPLEMENTATION.md](COMPLETE_UI_IMPLEMENTATION.md)
- **Navigation Flows**: See [NAVIGATION_SETUP_COMPLETE.md](NAVIGATION_SETUP_COMPLETE.md)
- **Screen Specs**: See [UI_SCREENS_GUIDE.md](UI_SCREENS_GUIDE.md)

### Common Issues
- **Compilation Errors**: Run `flutter pub get` then `flutter clean`
- **Hot Reload Not Working**: Press 'R' for hot restart
- **Firebase Errors**: Check [firebase_options.dart](lib/firebase_options.dart)
- **Form Not Validating**: Check FormBuilder `autovalidateMode` setting

### Resources
- Flutter Docs: https://flutter.dev/docs
- Riverpod Docs: https://riverpod.dev
- GoRouter Docs: https://pub.dev/packages/go_router
- flutter_form_builder: https://pub.dev/packages/flutter_form_builder

---

## Success Checklist

After running `flutter run -d web`, you should see:

- ✅ Sign-in screen loads
- ✅ Sign-up link works
- ✅ Email validation works (try "invalid-email")
- ✅ Password length validation works (try 5 chars)
- ✅ Forgot password link works (navigates away)
- ✅ After signing in, menu screen appears
- ✅ Bottom navigation bar visible with 5 tabs
- ✅ Can switch between tabs
- ✅ Can search menu items
- ✅ Can view order history, loyalty, etc.
- ✅ Profile screen has sign-out button
- ✅ Sign-out redirects to sign-in

**If all checkmarks are green, the UI is fully functional! 🎉**

---

**Status**: ✅ **READY TO USE**

**Version**: 1.0.0

**Last Updated**: Today

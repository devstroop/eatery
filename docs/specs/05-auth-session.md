# Specs 05 — Auth & Session

## 1. Authentication Flow

```
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│  Login   │────►│  Verify PIN  │────►│  Create       │
│  Page    │     │  (against    │     │  Session      │
│          │     │   Staff.pin) │     │  (Riverpod)   │
└──────────┘     └──────────────┘     └──────┬───────┘
                                             │
                                             ▼
                                    ┌──────────────────┐
                                    │  Route Guard     │
                                    │  checks role     │
                                    └──────┬───┬───────┘
                                           │   │
                              ┌────────────┘   └────────────┐
                              ▼                             ▼
                      ┌──────────────┐             ┌──────────────┐
                      │  Allowed     │             │  Denied      │
                      │  (show page) │             │  (redirect)  │
                      └──────────────┘             └──────────────┘
```

## 2. AuthSession Provider

```dart
@riverpod
class AuthSession extends _$AuthSession {
  @override
  AuthSessionState build() => const AuthSessionState.unauthenticated();

  void login(Staff staff) {
    state = AuthSessionState.authenticated(staff);
  }

  void logout() {
    state = const AuthSessionState.unauthenticated();
  }
}

sealed class AuthSessionState {
  const AuthSessionState();
  const factory AuthSessionState.unauthenticated() = _Unauthenticated;
  const factory AuthSessionState.authenticated(Staff staff) = _Authenticated;
}

class _Unauthenticated implements AuthSessionState {
  const _Unauthenticated();
}

class _Authenticated implements AuthSessionState {
  final Staff staff;
  const _Authenticated(this.staff);
}
```

## 3. Route Guard (GoRouter Redirect)

```dart
GoRouter createAppRouter() {
  return GoRouter(
    redirect: (context, state) {
      final auth = ref.read(authSessionProvider);
      final location = state.matchedLocation;

      return auth.when(
        unauthenticated: () {
          // Allow access to login and public routes only
          if (location == '/login' || location == '/' || location == '/create-company') {
            return null;
          }
          return '/login';
        },
        authenticated: (staff) {
          // Allow if the route is in the staff's permission map
          if (_isRouteAllowed(staff.type, location)) return null;
          // Otherwise redirect to dashboard
          return '/dashboard';
        },
      );
    },
    // ... routes
  );
}
```

## 4. Route Permission Matrix

| Route | admin | waiter | chef | driver |
|-------|-------|--------|------|--------|
| `/dashboard` | ✓ | ✓ | ✓ | ✓ |
| `/pos` | ✓ | ✓ | ✗ | ✗ |
| `/cart` | ✓ | ✓ | ✗ | ✗ |
| `/order-confirmation` | ✓ | ✓ | ✗ | ✗ |
| `/orders` | ✓ | ✓ | ✗ | ✗ |
| `/orders/view` | ✓ | ✓ | ✓ | ✗ |
| `/orders/edit` | ✓ | ✓ | ✗ | ✗ |
| `/payments` | ✓ | ✓ | ✗ | ✗ |
| `/kds` | ✓ | ✗ | ✓ | ✗ |
| `/customers` | ✓ | ✓ | ✗ | ✗ |
| `/staffs` | ✓ | ✗ | ✗ | ✗ |
| `/staffs/add` | ✓ | ✗ | ✗ | ✗ |
| `/staffs/edit` | ✓ | ✗ | ✗ | ✗ |
| `/settings` | ✓ | ✗ | ✗ | ✗ |
| `/dining-tables` | ✓ | ✓ | ✗ | ✗ |
| `/dining-tables/add` | ✓ | ✗ | ✗ | ✗ |
| `/dining-tables/edit` | ✓ | ✗ | ✗ | ✗ |
| `/product-categories` | ✓ | ✗ | ✗ | ✗ |
| `/kitchen-dishes` | ✓ | ✗ | ✓ | ✗ |
| `/inventory-items` | ✓ | ✗ | ✗ | ✗ |
| `/data` | ✓ | ✗ | ✗ | ✗ |
| `/upgrade` | ✓ | ✓ | ✓ | ✓ |

## 5. Login Page (Rewritten)

```dart
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Form(
        child: Column(
          children: [
            // Staff phone/name input
            TextFormField(
              label: 'Staff ID / Phone',
              onChanged: (v) => _identifier = v,
            ),
            // PIN input
            TextFormField(
              label: 'PIN',
              obscureText: true,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'PIN is required';
                if (v.length < 4) return 'PIN must be at least 4 digits';
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () => _login(ref, context),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _login(WidgetRef ref, BuildContext context) {
    final staffRepo = ref.read(staffRepositoryProvider);
    final staff = staffRepo.getStaffByPhone(_identifier);
    if (staff == null || staff.pin != _hashPin(_pin)) {
      AppDialog.showMessage(context, message: 'Invalid credentials');
      return;
    }
    ref.read(authSessionProvider.notifier).login(staff);
    context.goNamed('dashboard');
  }
}
```

## 6. Logout

```dart
class LogoutPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Clear session
    ref.read(authSessionProvider.notifier).logout();
    // Navigate to login, remove all history
    return Redirector('/login') as Widget;
  }
}
```

## 7. PIN Reset Flow

The current `ResetPinScreen` is a stub. Rewritten flow:

1. Staff enters their phone number
2. If found, show "Enter new PIN" + "Confirm PIN"
3. Save new PIN (hashed) to `Staff.pin`
4. Navigate to `/login`

```dart
class ResetPinScreen extends ConsumerStatefulWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Step 1: identify staff by phone
    // Step 2: enter + confirm new PIN
    // Step 3: update Staff.pin, hash it
    // Step 4: show success, navigate to /login
  }
}
```

## 8. Migration from Company PIN

On first launch after Phase 1 migration:

1. If `Company.password` is set and no admin staff exists:
   - Create `Staff(name: company.name, phone: company.phone, type: admin, pin: company.password)`
   - Set `Staff.pin` with hashed value
2. Remove `Company.password` (or ignore it going forward)
3. Login page now queries `Staff` instead of `Company`

## 9. PIN Hashing

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

String _hashPin(String pin) {
  final bytes = utf8.encode(pin);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
```

Note: For production, use bcrypt or PBKDF2. The current `encrypt` package in dependencies can be leveraged.

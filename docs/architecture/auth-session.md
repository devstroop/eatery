# Auth & Session

## Current State

Authentication uses a single PIN stored on the `Company` model (`Company.password`). The login page compares the entered PIN against this value.

## Planned: Per-Staff PIN Authentication

Migration target — each `Staff` member has their own PIN (`Staff.pin` field, already added via schema migration v1).

### AuthSession Provider

`packages/eatery_core/lib/providers/auth_session.dart`:

```dart
final authSessionProvider = StateProvider<Staff?>((ref) => null);

Staff? authenticateStaff(EateryStore store, String loginId, String pin) {
  // Try phone match first, then name match
  var staff = findByPhone(store, loginId);
  staff ??= findByName(store, loginId);
  if (staff == null) return null;
  if (staff.pin == null || staff.pin != pin) return null;
  return staff;
}
```

- `null` = unauthenticated
- `Staff` object = authenticated session

### Login Flow (target)

```
Login Page -> enter phone/name + PIN -> authenticateStaff()
  -> success: set authSessionProvider -> GoRouter redirect -> dashboard
  -> failure: show error dialog
```

### Logout

Clears `authSessionProvider` to null and redirects to `/login`.

## Route Guards

`lib/core/router/app_router.dart`:

```dart
const _publicRoutes = {'login', 'mainScreen', 'createCompany', 'resetPin', 'setup'};

GoRouter createAppRouter(...) {
  redirect: (context, state) {
    final authStaff = container.read(authSessionProvider);
    final isPublic = _publicRoutes.contains(state.name) || location == '/';
    if (authStaff == null && !isPublic) return '/login';
    if (authStaff != null && isPublic && location == '/login') return '/dashboard';
    return null;
  }
}
```

Note: Auth redirect is partially implemented. The GoRouter redirect exists but the permission-based route matrix (role-based access) is not yet enforced. Currently any authenticated staff can access any route.

## Permission Matrix (Planned)

| Route | admin | waiter | chef | driver |
|-------|-------|--------|------|--------|
| `/dashboard` | yes | yes | yes | yes |
| `/pos`, `/cart`, `/order-confirmation` | yes | yes | no | no |
| `/orders` | yes | yes | no | no |
| `/orders/view` | yes | yes | yes | no |
| `/orders/edit` | yes | yes | no | no |
| `/payments` | yes | yes | no | no |
| `/kds` | yes | no | yes | no |
| `/customers` | yes | yes | no | no |
| `/staffs`, `/staffs/add`, `/staffs/edit` | yes | no | no | no |
| `/settings` | yes | no | no | no |
| `/dining-tables`, `/product-categories` | yes | yes | no | no |
| `/kitchen-dishes` | yes | no | yes | no |
| `/inventory-items`, `/data` | yes | no | no | no |
| `/upgrade` | yes | yes | yes | yes |

## PIN Migration (Company.password -> Staff.pin)

On first launch after migration:
1. If `Company.password` is set and no admin staff exists, create `Staff(name: company.name, phone: company.phone, type: admin, pin: company.password)`
2. Login page queries `Staff` instead of `Company`
3. `Company.password` is deprecated but kept for backward compatibility

## Security Notes

- PINs should be hashed with SHA-256 (currently plain text comparison)
- Production should use bcrypt or PBKDF2 via the existing `encrypt` package
- No session timeout or token refresh implemented yet

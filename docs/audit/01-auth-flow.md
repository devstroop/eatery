# Audit 01 — Authentication Flow

## Current Flow

```
App start → Router reads Company.password → password set? → /login
                                                              ↓
                                User enters PIN → compare with Company.password
                                                              ↓
                                match? → set companyProvider → /dashboard
                                no match? → show error
```

## Issues

### A1 — Login bypass when PIN is null [CRITICAL]

**File:** `login.page.dart:43`  
**Code:** `if (company!.password == null || _controllerPassword.text == company!.password)`

If the user never set a PIN during company creation, `Company.password` is null. The first condition `password == null` evaluates to true, so **any input is accepted as valid**.

**Fix:** `if (company!.password != null && _controllerPassword.text == company!.password)`

---

### A2 — Flash of empty state on login [HIGH]

**File:** `login.page.dart:30-34`  
**Code:**
```dart
Future.delayed(Duration.zero, () {
  company = ref.read(companyRepositoryProvider).getCurrentCompany();
});
```

The company is loaded asynchronously in `initState()`, but the widget builds immediately. The user sees a progress indicator briefly, then the login form appears.

**Fix:** Use `FutureBuilder` or `AsyncValue` to handle loading state.

---

### A3 — Reset PIN page is a skeleton [HIGH]

**File:** `reset-pin.dart` (entire file)

The Reset PIN page has an AppBar with title "Reset PIN" but **zero functionality**. The user lands on an empty white page with no form, no fields, no way to actually reset a PIN.

**Fix:** Implement full flow: identify staff → enter new PIN → confirm → save.

---

### A4 — Destructive delete without backup [MEDIUM]

**File:** `login.page.dart:96-113`

The "Delete Company" action in the app bar menu calls `ref.read(appDatabaseProvider).deleteAll()` which destroys all data permanently. No backup is created beforehand.

**Fix:** Backup data before deletion, or require confirmation with typed "DELETE".

---

### A5 — Logout doesn't clear session [MEDIUM]

**File:** `logout.page.dart` (entire file)

Logout just navigates to `/login` with `GoRouter.of(context).goNamed('logout')`. No session state is cleared, no PIN is re-prompted. If the user presses back, they see the dashboard again.

**Fix:** Clear `AuthSession` state, use `pushReplacement` or `go()` with no history.

---

### A6 — Router reads stale password [MEDIUM]

**File:** `app_router.dart:62-69`

```dart
password = repo.getCurrentCompany()?.password;
```

The router reads Company.password synchronously at construction time. In a sync scenario where the company is modified on another device, this cached value becomes stale.

**Fix:** Make the router redirect depend on a provider that updates reactively.

---

### A7 — No PIN complexity rules [LOW]

**File:** `login.page.dart:236-237`

The validator only checks `isNumericOnly` and `isNotEmpty`. No minimum length, no complexity requirements.

**Fix:** Add minimum PIN length (4 digits), reject sequential/repeating patterns.

---

### A8 — Route guard doesn't exist [HIGH]

**File:** `app_router.dart`

There is **no authentication redirect** in the GoRouter configuration. Any user who knows a URL can navigate directly to any page without logging in, because there's no session state to check.

**Fix:** Add GoRouter `redirect` that checks `AuthSessionState`.

---

### A9 — Single PIN for all users [CRITICAL]

**File:** `company.dart:14` + `login.page.dart`

The entire restaurant shares one PIN (`Company.password`). There's no way to distinguish which staff member is logged in, which waiter placed which order, or which chef acknowledged which ticket.

**Fix:** Implement per-staff PIN authentication (Phase 1).

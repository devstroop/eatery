# Audit 06 — Customer & Staff Flow

## Customer Issues

### CS1 — Customers page loads all on every build [HIGH]

**File:** `customers.page.dart:42-52`

```dart
ref.read(customerRepositoryProvider).getAllCustomers()  // called 3 times!
```

`getAllCustomers()` is called separately for the `isNotEmpty` check, the `itemCount`, and each `itemBuilder` index. With 500+ customers, this means 503+ redundant SQLite queries per frame.

**Fix:** Cache the list in a local variable.

---

### CS2 — Customer CRUD uses `.delete()` without OpLog [MEDIUM]

**File:** `customers.page.dart:166-168`

```csharp
c.delete()  // Direct model method, not through repository
```

The delete uses a direct model method `c.delete()` instead of going through the repository. This bypasses any sync/OpLog integration.

**Fix:** Use `customerRepositoryProvider.deleteCustomer(c)`.

---

### CS3 — Customer card uses dynamic type [MEDIUM]

**File:** `customers.page.dart:83`

```dart
final dynamic customer;
```

Same pattern as the orders page — `dynamic` instead of `Customer`.

**Fix:** `final Customer customer;`

---

### CS4 — Customer outstanding amount is order.grandTotal, not actual outstanding [MEDIUM]

**File:** `cart.page.dart:391`

```dart
'${ref.read(cartProvider).activeOrder?.grandTotal ?? 0}',  // Shows full total, not outstanding
```

The "Previous" row shows the active order's full `grandTotal`, not the outstanding balance (`grandTotal - paidTotal`). A customer who paid $80 of a $100 order would see "Previous: $100" instead of "Previous: $20".

**Fix:** `order.grandTotal - (order.paidTotal ?? 0)`

---

## Staff Issues

### CS5 — Staff list uses dynamic type [MEDIUM]

**File:** `staffs.page.dart:92`

```dart
final dynamic staff;
```

Same pattern as customers and orders.

**Fix:** `final Staff staff;`

---

### CS6 — Staff delete uses model method [MEDIUM]

**File:** `staffs.page.dart:147`

```csharp
s.delete()  // Model method, bypasses repository
```

Same issue as customer delete.

**Fix:** Use `staffRepositoryProvider.deleteStaff(s)`.

---

### CS7 — Staff edit page opens but likely has empty fields [HIGH]

**File:** `edit.staff.page.dart` (not fully reviewed)

Given the pattern of other edit pages (edit.order.page.dart, edit.customer etc.), the staff edit page likely also has empty/missing field values.

**Fix:** Verify and fix if needed.

---

### CS8 — No staff PIN management UI [HIGH]

**File:** `add.staff.page.dart` + `edit.staff.page.dart`

The staff CRUD pages don't have a PIN field. Staff can be created with a name, phone, photo, and type — but no PIN. This blocks the per-staff auth feature entirely.

**Fix:** Add PIN field (and confirm PIN) to add/edit staff pages.

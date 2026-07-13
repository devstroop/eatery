# Audit 05 — Payment Flow

## Current Flow

```
/payments → ListView of all payments (no pagination)
  ↓ tap → /view-payment
  ↓ FAB → /add-payment → select order → select mode → enter amount → save
```

## Issues

### PM1 — Payments page loads everything [MEDIUM]

**File:** `payments.page.dart:23-25`

```dart
List<Payment> payments = ref.read(paymentRepositoryProvider).getAllPayments();
payments.sort((a, b) => b.date.compareTo(a.date));
```

Loads all payments into memory, then sorts in Dart. No pagination, no server-side sorting.

**Fix:** Add pagination and SQL-level ORDER BY.

---

### PM2 — Order selection in AddPayment shows all orders [MEDIUM]

**File:** `add.payment.page.dart:93`

```dart
orders: ref.read(orderRepositoryProvider).getAllOrders(),
```

The order search delegate for payment attachment loads all orders, including completed/voided ones. Typically you only want to add payments against active orders with outstanding balance.

**Fix:** Filter to orders with `grandTotal > paidTotal` (or allow filter toggling).

---

### PM3 — Payment validation gap [LOW]

**File:** `add.payment.page.dart:207-211`

```dart
if (order == null)
  AppDialog.showMessage(context, message: 'Please select an order');
// NOTE: No return here! Falls through to the validate block below.
```

When `order` is null, the error dialog is shown but execution continues to the `if (_formKey.currentState!.validate())` block. If the form is valid, a payment with null `orderId` gets created.

**Fix:** Add `return;` after the error dialog.

---

### PM4 — No split payment support [LOW]

**File:** `add.payment.page.dart`

Payments are single-mode. A bill of $100 can't be split as $60 cash + $40 card.

**Fix:** Support adding multiple payments against one order, track partial payments.

---

### PM5 — Payment doesn't update order status [HIGH]

**File:** `add.payment.page.dart:235-237`

After saving a payment, the code updates `order.paidTotal` but does NOT update `order.status` to `completed` when fully paid.

```dart
order?.paidTotal = (order?.paidTotal ?? 0) + double.parse(_controllerAmount.text);
```

If `paidTotal >= grandTotal`, the status should transition to `completed`.

**Fix:** After updating `paidTotal`, check if fully paid and update status.

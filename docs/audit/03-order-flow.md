# Audit 03 — Order Management Flow

## Current Flow

```
/dashboard → Orders → ListView of all orders (no pagination)
  ↓ tap order card → /view-order (read-only, missing data)
  ↓ tap edit → /edit-order (empty form, labels only)
  ↓
Also accessible from POS as "view existing order on occupied table"
```

## Issues

### O1 — Edit order page is a complete stub [CRITICAL]

**File:** `edit.order.page.dart:33-82`

```
Order ID: 42           ✓
Table:                 ╳ (no value)
Order Status:          ╳ (no value)
Order Date:            ╳ (no value)
Order Time:            ╳ (no value)
Order Total:           ╳ (no value)
Order Items:           ╳ (no value)
```

Every data field is an empty label with no value. The "done" button just calls `Navigator.pop()`. This page is completely non-functional.

**Fix:** Implement the full edit form: display current values, allow quantity/price changes, add/remove items, recalculate totals.

---

### O2 — View order missing table name [HIGH]

**File:** `view.order.page.dart:52-55`

```dart
Text('Table: '),  // No table name fetched or displayed
```

The table name is never looked up from the dining table repository.

**Fix:** Query dining table by `order.diningTableId` or `diningTable.orderId` and display its name.

---

### O3 — Order status shows "NA" [HIGH]

**File:** `view.order.page.dart:64-66`

```dart
Text('Order Status: NA'),  // Literal "NA" rendered
```

The `Order.status` field exists but is never read for display.

**Fix:** `Text('Order Status: ${order.status}')`

---

### O4 — Order items not rendered [HIGH]

**File:** `view.order.page.dart:100-114`

The "Order Items" header is displayed but the actual items list is inside a commented-out block (in `previewWidget` lines 115-144), and `previewWidget` is not used in the build method at all.

**Fix:** Query `orderRepository.getOrderProducts(order.id)` and render the list.

---

### O5 — getAllOrders() loads everything into memory [MEDIUM]

**File:** `orders.page.dart:54`

```dart
List<Order> orders = ref.read(orderRepositoryProvider).getAllOrders();
```

Loads the entire orders table. A busy restaurant with thousands of orders over months will see significant performance degradation. No `LIMIT`, `OFFSET`, or server-side filtering.

**Fix:** Add pagination (limit/offset), date range filtering on the query side.

---

### O6 — dynamic type instead of Order [MEDIUM]

**File:** `orders.page.dart:119`

```dart
class _OrderCard extends StatelessWidget {
  final dynamic order;  // Should be Order
```

The `_OrderCard` accepts `dynamic` instead of `Order`, losing all type safety. A wrong object type would crash at runtime.

**Fix:** `final Order order;`

---

### O7 — Order confirmation page is dead code [MEDIUM]

**File:** `order.confirmation.page.dart` (entire file)

- Receipt preview (lines 59-145): fully commented out
- Print button (lines 202-209): empty async function
- Share button (lines 219-226): also a stub
- The page renders an empty shell with three non-functional buttons

**Fix:** Either implement (render order items, connect print/share) or remove the page and its route.

---

### O8 — Order.status is a raw string [MEDIUM]

**File:** `order.dart:19`

```dart
String status; // "active", "completed", "voided", "refunded"
```

No enum, no validation, no state machine. Any string can be assigned.

**Fix:** Change to `OrderStatus` enum with validated transitions.

---

### O9 — Nullable ID [LOW]

**File:** `order.dart:8`

`int? id` on Order makes it impossible to distinguish a not-yet-saved order from a saved one at the type level.

**Fix:** Could use a separate `NewOrder` type for unsaved orders, or enforce non-null after save.

---

### O10 — Search order delegate missing functionality [LOW]

**File:** `search.order.delegate.dart`

Search delegates exist but the order search doesn't filter by status, date range, or waiter. It's a simple text search.

**Fix:** Add advanced search filters.

---

### O11 — No date range filter on orders page [LOW]

**File:** `orders.page.dart:25-26`

```dart
DateTime? filterFrom;
DateTime? filterTill;
```

Filter fields are declared but never used in the query. The UI to set them doesn't exist.

**Fix:** Add date range picker UI, pass filters to repository query.

---

### O12 — Order list doesn't show status or waiter [LOW]

**File:** `orders.page.dart:153-171`

The `_OrderCard` shows date, customer phone, quantity, totals, but **not** the order status or assigned waiter. This makes it hard to find active vs completed orders.

**Fix:** Add status badge and waiter name to the card.

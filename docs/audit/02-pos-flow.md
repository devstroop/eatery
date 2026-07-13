# Audit 02 — POS Flow

## Current Flow

```
/pos → Show order type bottom sheet (dine/delivery/takeout)
  ↓ (dine only)
Show dining table search delegate
  ↓
Show customer search delegate (optional)
  ↓
Browse products by category → add to cart (List<Product> with duplicates)
  ↓
/cart → Review items, see price breakdown → Checkout
  ↓
Confirm dialog → Place order → Print KOT/Invoice → /order-print
```

## Issues

### P1 — Nested async chain with no error handling [CRITICAL]

**File:** `pos.page.dart:82-139`

```dart
void initState() {
  Future.delayed(Duration.zero, () {
    initOrderType().then((orderType) {
      if (orderType == null) { Navigator.pop(context); return; }
      initDiningTableIfDine().then((diningTable) {
        if (dine && diningTable == null) { Navigator.pop(context); return; }
        initCustomerIfNull().then((customer) { ... });
      });
    });
  });
}
```

Three sequential async operations are chained with nested callbacks — **no error handling anywhere**. If any step throws (DB failure, null pointer), the entire POS page enters an undefined state.

**Fix:** Use async/await with try/catch, or extract to a well-defined initialization method.

---

### P2 — Order type dismissal loses state [HIGH]

**File:** `pos.page.dart:84-88`

If the user dismisses the order type bottom sheet without selecting (presses back/swipes down), the POS page silently pops itself. Any previous context is lost without confirmation.

**Fix:** Only pop if there's no existing session state; otherwise, return to previous session.

---

### P3 — Table dismissal has no user feedback [HIGH]

**File:** `pos.page.dart:92-97`

Same pattern: if no dining table selected for dine-in, the page silently closes with no message explaining why.

**Fix:** Show a snackbar/toast: "Please select a table to start a dine-in order."

---

### P4 — getAllProducts() called on every build [HIGH]

**File:** `pos.page.dart:149`

```dart
List<Product> products = productsRepo.getAllProducts().where(...);
```

`getAllProducts()` queries SQLite on every single frame rebuild (setState, provider update, scroll). With 500+ products, this causes repeated UI jank.

**Fix:** Cache the product list in a provider, or use `riverpod`'s `AsyncNotifierProvider` to cache.

---

### P5 — Order creation logic in UI page [MEDIUM]

**File:** `cart.page.dart:550-676`

The entire `placeOrder()` method (~130 lines) lives in the CartPage widget: order creation, product iteration, tax calculation, table status update, print logic. This should be in a repository or use case.

**Fix:** Extract to `OrderRepository.createOrder()` or a dedicated service.

---

### P6 — Order edit matches on wrong ID [MEDIUM]

**File:** `cart.page.dart:553-600`

```dart
var existing = ref.read(orderRepositoryProvider)
    .getOrderProducts(order.id!)
    .where((element) => element.id == product.id)  // BUG: comparing OrderProduct.id with Product.id
    .firstOrNull;
```

When editing an existing order, the code matches cart products `Product.id` against `OrderProduct.id` — different ID spaces. The first `OrderProduct` that happens to match gets its quantity incremented, even if it's a completely different product.

**Fix:** Compare `element.productId == product.id`.

---

### P7 — totalQuantity calculation [MEDIUM]

**File:** `cart.page.dart:649`

```dart
totalQuantity: cart.length,
```

`totalQuantity` is set to `cart.length` (number of cart entries). With a flat list of duplicate products, 3 of the same item = 3 entries = totalQuantity of 3. This happens to be correct, but only because of the duplicate-list approach.

**Fix:** Sum quantities: `cart.fold(0, (sum, p) => sum + 1)` (or use a proper quantity map).

---

### P8 — Cart as List<Product> with duplicates [MEDIUM]

**File:** `cart.provider.dart:64-75`

```dart
void addToCart(Product product) {
  state = state.copyWith(cart: [...state.cart, product]);
}
void removeFromCart(Product product) {
  final idx = state.cart.indexOf(product);  // O(n) identity lookup
}
```

The cart stores each product addition as a separate entry. Quantity is implied by count of duplicates. This is O(n) for lookups and any product property change breaks `.indexOf()`.

**Fix:** Use a `Map<int, CartItem>` where `CartItem` has `productId`, `quantity`, `unitPrice`.

---

### P9 — Context may be unmounted after Navigator.pop [MEDIUM]

**File:** `pos.page.dart:198-203`

```dart
onTap: () {
  Navigator.pop(context);  // closes popup menu
  showDialog(context: context, ...);  // same context, may be unmounted
}
```

The "Close Order" menu item pops the context (menu) and then immediately uses the same context to show a dialog. The `BuildContext` may no longer be valid.

**Fix:** Use `this.context` (the widget's context) instead of the menu's context.

---

### P10 — Dead QR code button [LOW]

**File:** `pos.page.dart:180`

Commented out with note "dead button; qrscan plugin removed (abandoned)". Dead code and dead comment in the production app bar.

**Fix:** Remove the commented icon and the dead-button comment.

---

### P11 — Cart button hidden without customer [LOW]

**File:** `pos.page.dart:561`

```dart
if (session.activeCustomer != null)
  PosCartInformation(onTap: ..., cart: session.cart);
```

The cart button in the bottom bar only appears after selecting a customer. New users may think there's no way to proceed.

**Fix:** Always show the cart button, or show a disabled version with prompt.

---

### P12 — Product detail sheet state inconsistency [LOW]

**File:** `pos.page.dart:788-817`

The `_showProductDetails` bottom sheet doesn't update the `selectedProductCategory` state after returning. If the user adds a product from a different category, the category filter doesn't reflect the change.

**Fix:** Add `setState` callback after bottom sheet returns.

---

### P13 — Waiter selection view is empty [LOW]

**File:** `waiterSelection.view.dart` (entire file)

The `WaiterSelectionView` widget exists in the POS views but renders only an AppBar with title "Select Waiter" and a thin divider line. No staff list, no selection mechanism.

**Fix:** Implement the waiter selection: list staff with `StaffType.waiter`, allow selection, set `PosSession.staffId`.

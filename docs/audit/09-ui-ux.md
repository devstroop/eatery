# Audit 09 — UI/UX Issues

## Issues

### U1 — POS page has no tablet-adaptive layout [HIGH]

**File:** `pos.page.dart:515-531`

```dart
Responsive.isMobile(context)
    ? _buildMobileBody(...)
    : _buildDesktopBody(...)
```

Only two layouts: mobile (vertical categories bar + product grid) and desktop (sidebar categories + product grid). Tablets in landscape get the desktop layout, which may be too cramped.

**Fix:** Add a tablet layout with adjustable split pane.

---

### U2 — Dashboard grid items are hardcoded [HIGH]

**File:** `dashboard.page.dart:30-123`

The dashboard tiles (Sales, Products, People, System) are hardcoded. There's no customization, no role-based filtering (a waiter would see Settings/Data which they shouldn't access), and no way to reorder.

**Fix:** Make navigation data-driven and role-filtered.

---

### U3 — AppBar color may have contrast issues [MEDIUM]

**File:** `pos.page.dart:163-164`

```dart
Color pageColor = Color(session.activeOrderType?.color ?? AppColors.primary.value);
```

The AppBar color is derived from the order type's color:
- Dine: `#E0855E` (salmon)
- Delivery: `#705EE0` (purple)
- Takeout: `#4AC3A1` (teal)

White text on these backgrounds may have insufficient contrast ratio, especially for the purple and salmon colors.

**Fix:** Add text color calculation based on luminance.

---

### U4 — Mobile POS bar is cramped with 3 items [MEDIUM]

**File:** `pos.page.dart:326-398`

The AppBar bottom shows customer info, outstanding amount, and dining table name in a 54px bar. On mobile, text truncation makes some of these unreadable.

**Fix:** Use collapsible sections or a more responsive layout for the POS bar.

---

### U5 — Cart button hidden when no customer selected [MEDIUM]

**File:** `pos.page.dart:561`

```dart
if (session.activeCustomer != null)
  PosCartInformation(...)
```

The cart button in the bottom bar is only rendered when a customer is selected. A first-time user may add items to their cart and then wonder why there's no visible "go to cart" button.

**Fix:** Always show the cart button. Disable checkout if no customer is selected instead.

---

### U6 — Empty menu buttons on orders page [LOW]

**File:** `orders.page.dart:77-81`

```dart
IconButton(
  icon: const Icon(Icons.barcode_reader),
  onPressed: () async {},  // Empty callback
),
IconButton(
  icon: const Icon(Icons.more_vert),
  onPressed: () async {},  // Empty callback
),
```

Two IconButtons in the AppBar with empty `onPressed` callbacks. They render clickable buttons that do nothing.

**Fix:** Remove, implement, or disable them.

---

### U7 — `_OrderCard.onTap` does nothing [LOW]

**File:** `orders.page.dart:174`

```dart
onTap: () {},  // Tapping an order card in the list does nothing
```

Tapping an order card in the list has no action. The only way to view order details is through the search.

**Fix:** Navigate to `viewOrder` on tap.

---

### U8 — POS cart checkout doesn't work on mobile orientation change [LOW]

**File:** `cart.page.dart`

The CartPage uses `AppPageShell` which likely depends on `Responsive` utilities. If the device rotates, the layout may break as the state isn't rebuilt properly.

**Fix:** Test and fix orientation changes.

# Audit 04 — Dining Table Flow

## Issues

### D1 — Unsafe dynamic cast to access categories [CRITICAL]

**File:** `dining.tables.page.dart:70-71`

```dart
if ((ref.read(diningTableRepositoryProvider) as dynamic)
    .getAllCategories()
    .isNotEmpty)
```

`getAllCategories()` is NOT on the `DiningTableRepository` interface — it's only on `SqliteDiningTableRepository`. The `as dynamic` cast bypasses type safety entirely. If the provider is swapped to a different implementation, this crashes at runtime.

**Fix:** Either add `getAllCategories()` to the interface, or provide a separate `DiningTableCategoryRepository`.

---

### D2 — DiningTable.category always null in SQLite [HIGH]

**File:** `dining.table.repository.sqlite.dart:128-131`

```dart
// category is a Hive-backed object; leave null for now; the model
// already handles nullable category and pages work without it set.
```

The `_toTable()` mapping method intentionally leaves `DiningTable.category` as null. This means **table categories never display** in any page using the SQLite repository.

**Fix:** Look up and set the category from the `dining_table_category` table.

---

### D3 — Incomplete repository interface [MEDIUM]

**File:** `dining.table.repository.dart`

`DiningTableRepository` doesn't declare `getAllCategories()`, `getCategoryById()`, or `saveCategory()`. The SQLite implementation adds them as extra methods, forcing callers to cast to the concrete type.

**Fix:** Add category methods to the interface.

---

### D4 — No floor plan visualization [MEDIUM]

**File:** All dining table pages

Tables are displayed as a plain `ListView`. There's no visual layout showing table positions in the restaurant. The model doesn't have x/y coordinates.

**Fix:** Add `posX`/`posY` to `DiningTable`, build a positioned widget overlay.

---

### D5 — Stale orderId link [LOW]

**File:** `dining.tables.page.dart:127`

```dart
Order? order = diningTable.orderId != null
    ? ref.read(orderRepositoryProvider).getOrderById(diningTable.orderId!)
    : null;
```

If a table's `orderId` references a voided/deleted order, `getOrderById()` returns null and the link disappears silently. The table remains marked as "occupied" with no way to clear it.

**Fix:** Show a "Clear table" option when the linked order is not found.

---

### D6 — Table capacity not enforced in POS [MEDIUM]

**File:** No capacity check anywhere

When selecting a table for a dine-in order, there's no check that the party size fits the table's capacity. A group of 6 can be seated at a 2-person table.

**Fix:** Show capacity on table selection, warn if exceeded.

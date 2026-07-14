# Audit 07 — Product Management

## Issues

### PR1 — getAllProducts() called redundantly [HIGH]

**File:** `kitchen.dishes.page.dart:165`

```dart
if (repo.getProductsByType(ProductType.kitchenDish).isEmpty)
```

**File:** `kitchen.dishes.page.dart:187-188`

```dart
...repo.getProductsByType(ProductType.kitchenDish)  // called again!
```

`getProductsByType()` is called twice — once for the empty check, once for the map. With the current sync implementation, this means two full SQLite queries to the `product` table.

**Fix:** Cache the result: `final dishes = repo.getProductsByType(...);`

---

### PR2 — No pagination on product lists [MEDIUM]

**File:** `product_repository_sqlite.dart:31`

```dart
List<Product> getAllProducts() =>
    _store.query('SELECT * FROM product').map(_toProduct).toList();
```

**File:** `product_repository_sqlite.dart:35-38`

```dart
List<Product> getProductsByType(ProductType type) => _store
    .query('SELECT * FROM product WHERE type = ?', [type.index])
    .map(_toProduct).toList();
```

All product queries load the entire result set. With 10,000 products this becomes a problem.

**Fix:** Add limit/offset support to repository methods.

---

### PR3 — No stock count fields on Product [MEDIUM]

**File:** `product.dart`

The `Product` model doesn't have `stockQuantity` or `lowStockThreshold` fields. Inventory items can't be tracked for stock levels.

**Fix:** Add fields (Phase 7).

---

### PR4 — Product type distinction (kitchenDish vs inventoryItem) not enforced [LOW]

**File:** `product.dart:15`

```dart
ProductType type;  // kitchenDish, inventoryItem
```

Products have a type, but nothing prevents a `kitchenDish` from being sold when it's out of stock as an `inventoryItem`.

**Fix:** When adding to cart, check if `type == inventoryItem` and verify stock.

---

### PR5 — No search debounce [LOW]

**File:** `product_repository_sqlite.dart:57-64`

```dart
List<Product> searchProducts(String query) {
  final q = query.toLowerCase().trim();
  return _store.query("SELECT * FROM product WHERE lower(name) LIKE ?", ['%$q%'])
      .map(_toProduct).toList();
}
```

The search runs on every keystroke with no debounce. Fast typing triggers N+1 queries.

**Fix:** Add debounce in the search delegate (300ms).

---

### PR6 — Product category list fetched without cache [LOW]

**File:** `pos.page.dart:596`

```dart
...productsRepo.getAllCategories().map((each) { ... }),
```

`getAllCategories()` is called in the build method (inside `_buildCategoriesSidebar` and `_buildCategoriesHorizontalBar`), meaning it re-queries SQLite on every frame.

**Fix:** Cache categories in a provider.

---

### PR7 — Sample data URL is a third-party GitHub repo [LOW]

**File:** `data_management.page.dart:384`

```dart
String baseUrl = 'https://raw.githubusercontent.com/devstroop/eatery_sample_data/main';
```

The demo data download function pulls JSON from a third-party GitHub account (`devstroop`). If this account goes private or is deleted, the demo data feature breaks.

**Fix:** Bundle sample data as JSON assets, or self-host.

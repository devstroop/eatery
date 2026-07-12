# Dev Tooling & Tests

> Developer-only features and test infrastructure. Accessible via **Settings > Developer** menu (debug builds only).

---

## Developer Menu

Visible in `lib/pages/dashboard/settings/settings.page.dart`:

```dart
if (const bool.fromEnvironment('dart.vm.product') == false) [
  // "Load Sample Data" button
  // "Database Inspector" link
]
```

Two tools:
1. **Load Sample Data** — Populates all Hive boxes with demo data
2. **Database Inspector** — Debug view showing box counts + "Clear All Data" button

---

## Sample Data

### Seed Data

[View source](../../lib/dev/seed_data.dart)

```dart
const SeedData.defaultData = SeedData(
  productCategories: [...],  // 5 categories
  products: [...],            // 6 products
  customers: [...],           // 2 customers
  diningTableCategories: [...], // 2 categories
  diningTables: [...],        // 4 tables
  staffs: [...],              // 2 staff
  taxSlabs: [...],            // 4 slabs (0%, 5%, 12%, 18%)
);
```

### Seed Loader

[View source](../../lib/dev/seed_loader.dart)

```dart
Future<void> loadSeedData(WidgetRef ref) async {
  final db = ref.read(appDatabaseProvider);
  // Populates: TaxSlab, ProductCategory, Product, DiningTableCategory,
  //            DiningTable, Staff, Customer boxes
}
```

Called from the Settings > Developer menu. Populates all 7 entity boxes with sequential IDs.

---

## Database Inspector

[View source](../../lib/dev/database_inspector.dart)

`DatabaseInspector` is a `ConsumerWidget` that shows:
- Count of items in each of 14 Hive boxes
- A "Clear All Data" button (with confirmation dialog)

---

## Test Suite

### Test Files

| File | Tests | Type |
|------|-------|------|
| `test/extensions_test.dart` | 3 | Unit (toPrecision, isNumericOnly) |
| `test/order_calculations_test.dart` | 3 | Unit (calculateRoundOff, calculateSubtotal) |
| `test/widget_test.dart` | 1 | Widget placeholder |

**Total: 7 tests, all passing.**

### Running Tests

```bash
flutter test
# or with coverage
flutter test --coverage
```

### Coverage Target

> **Target:** >40% line coverage after full test suite is implemented.

Current coverage is low — only extension methods and pure calculation functions are tested. Repository unit tests (mocking EateryDatabase) and widget smoke tests for critical pages (login, POS, order view) are planned.

---

## Debug Image Loading

Images are decoded at 200×200 via `ResizeImage.resizeIfNeeded()` in:
- `lib/services/utility/library_image.dart` (all product thumbnails)
- `lib/widgets/bottomSheets/productInternalView.bottomsheet.dart` (product detail)

---

## Related Specs

- [Architecture Overview](architecture.md)
- [Data Layer](data-layer.md) — Box structure

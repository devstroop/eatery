# Dev Tooling & Tests

Developer-only features accessible via **Settings > Developer** menu (debug builds only).

## Developer Menu

Visible in `lib/pages/dashboard/settings/settings.page.dart`:

```dart
if (const bool.fromEnvironment('dart.vm.product') == false) [
  // "Load Sample Data" button
  // "Database Inspector" link
]
```

Two tools:
1. **Load Sample Data** — Populates all SQLite tables with demo data
2. **Database Inspector** — Debug view showing table row counts + "Clear All Data" button

## Seed Data System

### SeedData (`lib/dev/seed_data.dart`)

```dart
const SeedData.defaultData = SeedData(
  productCategories: [...],     // 5 categories
  products: [...],               // 6 products
  customers: [...],              // 2 customers
  diningTableCategories: [...],  // 2 categories
  diningTables: [...],           // 4 tables
  staffs: [...],                 // 2 staff
  taxSlabs: [...],               // 4 slabs (0%, 5%, 12%, 18%)
);
```

### SeedLoader (`lib/dev/seed_loader.dart`)

```dart
Future<void> loadSeedData(WidgetRef ref) async {
  final db = ref.read(appDatabaseProvider);
  // Populates: TaxSlab, ProductCategory, Product, DiningTableCategory,
  //            DiningTable, Staff, Customer boxes
}
```

Called from the Settings > Developer menu. Populates all entity tables with sequential IDs.

## Database Inspector

`lib/dev/database_inspector.dart` — a `ConsumerWidget` that shows:
- Count of items in each SQLite table
- A "Clear All Data" button (with confirmation dialog)

## Test Suite

### Test Files (`packages/eatery_core/test/`)

| File | Tests | Type |
|------|-------|------|
| `op_log_service_test.dart` | — | Unit (OpLog service) |
| `op_log_service_fake_test.dart` | — | Unit (fake store) |
| `sync_message_test.dart` | — | Unit (message serialization) |
| `sync_coordinator_apply_entry_test.dart` | — | Unit (entry application) |
| `sync_e2e_test.dart` | — | Integration (end-to-end sync) |
| `mutation_hook_test.dart` | — | Unit (hook pattern) |
| `mutation_tracker_test.dart` | — | Unit (tracker helpers) |
| `mdns_service_test.dart` | — | Unit (discovery) |
| `eatery_core_test.dart` | — | Placeholder |
| `fake_eatery_store.dart` | — | Test helper |

Root `test/` directory (legacy):
- `extensions_test.dart` — 3 tests (toPrecision, isNumericOnly)
- `order_calculations_test.dart` — 3 tests (calculateRoundOff, calculateSubtotal)
- `widget_test.dart` — 1 test (placeholder)

### Running Tests

```bash
flutter test
flutter test --coverage
```

### Coverage Target

Target: >40% line coverage after full test suite is implemented. Current coverage is low  only extension methods and pure calculation functions are tested. Repository unit tests (using `FakeEateryStore` from `packages/eatery_core/test/fake_eatery_store.dart`) and widget smoke tests are planned.

## Debug Image Loading

Images are decoded at 200x200 via `ResizeImage.resizeIfNeeded()` in:
- `lib/services/utility/library_image.dart` (all product thumbnails)
- `lib/widgets/bottomSheets/productInternalView.bottomsheet.dart` (product detail)

## Analyze Command

```bash
flutter analyze
```

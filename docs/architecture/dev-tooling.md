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

Static `load(EateryStore)` method that populates all SQLite tables with demo data:

- **Staff:** Admin (PIN `1234`), Waiter 1 (PIN `1111`), Chef 1 (PIN `2222`)
- **Company:** "Demo Restaurant" (USD, no tax)
- **Product categories:** Beverages, Starters, Main Course, Desserts
- **Products:** 10 items across all categories (coffee, tea, soda, nachos, spring rolls, burger, pizza, pasta, ice cream, cheesecake)
- **Dining tables:** 8 tables across 3 categories (Window, Patio, Bar)
- **Tax slabs:** GST 5%, GST 12%
- **Customers:** John Doe, Jane Smith
- **KDS stations:** 2 stations

Called from the **Settings > Developer** menu. Idempotent — safe to call multiple times (checks `SELECT COUNT(*) FROM product` first).

### SeedLoader (legacy — removed)

The Hive-based `SeedLoader` class (`lib/dev/seed_loader.dart`) was removed during the SQLite migration. Its functionality was replaced by `SeedData.load()` above.

## Database Inspector

`lib/dev/database_inspector.dart` — a `ConsumerWidget` that shows:
- Count of items in each SQLite table
- A "Clear All Data" button (with confirmation dialog)

→ *Note: this route is registered as `databaseInspector` at `/dev/db-inspector` in the GoRouter.*

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

Root `test/` directory:
| File | Tests | Notes |
|------|-------|-------|
| `extensions_test.dart` | 3 | `toPrecision`, `isNumericOnly` |
| `order_calculations_test.dart` | 3 | `calculateRoundOff`, `calculateSubtotal` |
| `widget_test.dart` | 1 | Placeholder / smoke |

### Running Tests

```bash
# Root package tests (admin app logic)
flutter test

# Core library tests (models, sync, repositories, database)
flutter test packages/eatery_core/test/

# Coverage (root only)
flutter test --coverage
```

> ℹ️ Core tests are run separately because `packages/eatery_core` is a `path:` dependency.

### Coverage Target

Target: >40% line coverage after full test suite is implemented. Current coverage is low — only extension methods and pure calculation functions are tested. Repository unit tests (using `FakeEateryStore` from `packages/eatery_core/test/fake_eatery_store.dart`) and widget smoke tests are planned.

## Debug Image Loading

Images are decoded at 200x200 via `ResizeImage.resizeIfNeeded()` in:
- `lib/services/utility/library_image.dart` (all product thumbnails)
- `lib/widgets/bottomSheets/productInternalView.bottomsheet.dart` (product detail)

## Analyze Command

```bash
flutter analyze
```

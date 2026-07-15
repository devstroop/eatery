# Testing Strategy

## Current State

The project has **7 tests** across 4 test files:

| Test File | Type | Count |
|-----------|------|-------|
| `test/extensions_test.dart` | Unit (extensions) | 3 |
| `test/order_calculations_test.dart` | Unit (calculations) | 3 |
| `test/widget_test.dart` | Widget (smoke) | 1 (placeholder) |
| `test/router_regression_test.dart` | Widget (router) | 0 (placeholder) |

**Current line coverage:** ~5% (target: >40%)

## Test Pyramid

```
        ╱╲
       ╱ E2E ╲          2-3 critical paths per app (future)
      ╱────────╲
     ╱Integration╲      Full flows: auth, POS, sync (in progress)
    ╱──────────────
   ╱   Widget Tests  ╲    Key pages with mock data
  ╱────────────────────╲
 ╱    Unit Tests        ╲   Models, repositories, services, extensions
╱──────────────────────────╲
```

## Unit Tests

Test pure functions and repository logic in isolation.

### What to Unit Test

| Module | What | Framework |
|--------|------|-----------|
| Extensions | `toPrecision`, `isNumericOnly`, etc. | `flutter_test` |
| Calculations | `OrderFunction`: tax calc, round-off, subtotals | `flutter_test` |
| Data models | `toMap()`/`fromMap()` round-trip for all models | `flutter_test` |
| Repositories | CRUD against in-memory SQLite (`EateryStore.open(':memory:')`) | `flutter_test` + `mocktail` |
| OpLogService | Commit, query, `getEntriesSince()`, `applyBatch()` | `flutter_test` |
| SyncService | Role transitions, heartbeat, host loss detection | `flutter_test` |
| DTOs | Serialization/deserialization round-trip | `flutter_test` |
| AuthSession | State transitions, route guard logic | `flutter_test` |

### Repository Test Pattern

```dart
void main() {
  late EateryStore store;
  late SqliteProductRepository repo;

  setUp(() {
    store = EateryStore.open(':memory:');
    initEaterySchema(store, schemaSql);
    repo = SqliteProductRepository(store, FakeOpLog());
  });

  tearDown(() => store.close());

  test('create and retrieve product', () {
    final id = repo.saveProduct(Product(name: 'Test', mrpPrice: 10.0, ...));
    final loaded = repo.getProductById(id);
    expect(loaded?.name, 'Test');
  });
}
```

## Widget Tests

Test critical pages by wrapping them in `ProviderScope` with mocked dependencies.

### Pages to Test

| Page | What to Verify |
|------|----------------|
| `LoginPage` | Renders logo, PIN field, login button |
| `DashboardPage` | Renders company name, nav tiles |
| `POSPage` | Shows order type selection, product grid |
| `CartPage` | Cart items, price breakdown, checkout |
| `ViewOrderPage` | Order details display |
| `DiningTablesPage` | Table list with status |
| `StaffCard` | Name, role, edit/delete buttons |

### Widget Test Setup

```dart
Widget createTestWidget(Widget child) {
  return ProviderScope(
    overrides: [
      staffRepositoryProvider.overrideWithValue(MockStaffRepository()),
      orderRepositoryProvider.overrideWithValue(MockOrderRepository()),
      // ...
    ],
    child: MaterialApp(home: child),
  );
}
```

## Integration Tests

Test real user flows through multiple screens.

| Scenario | Steps |
|----------|-------|
| Full POS flow | Select dine-in → Pick table → Add 3 items → Checkout |
| Auth flow | Create staff → Login → Navigate → Logout |
| Order edit | Create order → Add items → Update quantities |
| Payment flow | Create order → Add payment → Verify paid |
| Customer CRUD | Add → View → Edit → Delete |

## E2E Tests (Future Goal)

| Scenario | Steps |
|----------|-------|
| Multi-device sync | Admin (host) + Waiter (leaf) → Create order on Waiter → Verify on Admin and KDS |
| Host failure | Admin killed → Waiter detects loss → Election → New host serves |
| Offline resume | Waiter creates orders offline → Reconnects → Orders sync |
| Conflict resolution | Two waiters edit same order → Higher clock wins |

## Running Tests

```bash
# All tests
flutter test

# Single file
flutter test test/extensions_test.dart

# Coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Melos (all packages)
melos run test
```

## Test Infrastructure

| Resource | Tool |
|----------|------|
| Test runner | `flutter test` |
| Mocking | `mocktail` |
| In-memory SQLite | `EateryStore.open(':memory:')` |
| Code coverage | `flutter test --coverage` + `lcov` |
| Widget test framework | `flutter_test` + `ProviderScope` wrappers |
| CI | GitHub Actions (planned) |

## Test File Conventions

- Place test files next to source: `lib/foo/bar.dart` → `test/foo/bar_test.dart`
- Name: `*_test.dart`
- One `main()` per file, grouped by feature with `group()`

## Coverage Target

**>40% line coverage** across the project. Priority order:
1. Core domain logic (`OrderFunction`, calculations, validators)
2. Repository implementations (in-memory SQLite tests)
3. Data models (serialization round-trips)
4. Sync (OpLog, SyncService)
5. Widget smoke tests for critical pages

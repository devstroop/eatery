# Specs 08 — Testing Strategy

## 1. Test Pyramid

```
        ╱╲
       ╱ E2E ╲          2-3 critical paths per app
      ╱────────╲
     ╱Integration╲      Multi-device sync, auth flow, POS flow
    ╱──────────────╲
   ╱   Widget Tests  ╲    Key pages with mock data
  ╱────────────────────╲
 ╱    Unit Tests        ╲   Models, services, repositories, sync
╱──────────────────────────╲
```

## 2. Unit Tests (eatery_core)

| Module | What to Test | Framework |
|--------|-------------|-----------|
| Data models | `toMap()/fromMap()` round-trip for every model | `flutter_test` |
| Data models | Default values, null handling | `flutter_test` |
| Enums | `.index`, `.name`, valid values | `flutter_test` |
| `OrderFunction` | Tax calculation (inclusive, exclusive), round-off, totals | `flutter_test` |
| `OrderFunction` | Edge cases: zero tax, 100% tax, very large values | `flutter_test` |
| `OpLogService` | Commit, query, `getEntriesSince()`, `rebuildState()`, `applyBatch()` | `flutter_test` |
| `OpLogService` | Clock initialization, advance, concurrent writes | `flutter_test` |
| `SyncService` | Role transitions: becomeHost/Leaf/Standalone | `flutter_test` |
| `SyncService` | Heartbeat timer, host loss detection, election | `flutter_test` |
| `SyncMessage` | Serialization/deserialization (JSON round-trip) | `flutter_test` |
| `Sqlite*Repository` | CRUD operations against in-memory SQLite | `flutter_test` |
| `Sqlite*Repository` | OpLog integration — verify entry written on create | `flutter_test` |
| `SqliteOrderRepository` | Status transition validation | `flutter_test` |
| `AuthSession` | State transitions (unauthenticated → authenticated → logout) | `flutter_test` |
| `PosSession` | `copyWith()`, add/remove from cart, clear | `flutter_test` |
| `SchemaMigrator` | Migration from v0 to v1, v2 — verify columns added | `flutter_test` |

### Example: OrderFunction test

```dart
void main() {
  group('OrderFunction', () {
    test('calculateProductPriceWithoutTax with inclusive tax', () {
      final product = Product(
        name: 'Test', mrpPrice: 118.0, salePrice: 118.0,
        type: ProductType.kitchenDish, isActive: true, taxSlabId: 1,
      );
      // Setup: tax_slab with id=1, rate=18%, type=inclusive
      // Expected: 118 / 1.18 = 100.0
      expect(OrderFunction.calculateProductPriceWithoutTax(product), 100.0);
    });

    test('calculateProductPriceWithoutTax with exclusive tax', () {
      final product = Product(
        name: 'Test', mrpPrice: 100.0, salePrice: 100.0,
        type: ProductType.kitchenDish, isActive: true, taxSlabId: 2,
      );
      // Setup: tax_slab with id=2, rate=18%, type=exclusive
      // Expected: 100.0 (price without tax = base price for exclusive)
      expect(OrderFunction.calculateProductPriceWithoutTax(product), 100.0);
    });
  });
}
```

## 3. Widget Tests

| Page | What to Test | Notes |
|------|-------------|-------|
| `LoginPage` | Renders logo, PIN field, login button | `ProviderScope` wrapper |
| `LoginPage` | Shows error on invalid PIN | Mock `StaffRepository` |
| `LoginPage` | Navigates to dashboard on valid PIN | |
| `DashboardPage` | Renders company name, nav tiles | |
| `POSPage` | Shows order type selection, product grid | |
| `CartPage` | Shows cart items, price breakdown | |
| `CartPage` | Checkout button disabled when cart empty | |
| `ViewOrderPage` | Shows order details (after fix) | |
| `DiningTablesPage` | Shows table list with status | |
| `StaffCard` | Shows name, role, edit/delete buttons | |

### Widget test setup

```dart
Widget createTestWidget(Widget child) {
  return ProviderScope(
    overrides: [
      // Mock all repository providers
      staffRepositoryProvider.overrideWithValue(MockStaffRepository()),
      orderRepositoryProvider.overrideWithValue(MockOrderRepository()),
      // ...
    ],
    child: MaterialApp(home: child),
  );
}
```

## 4. Integration Tests

| Scenario | Steps | Verification |
|----------|-------|-------------|
| Full POS flow | Select dine-in → Pick table → Add 3 items → Checkout | Order in DB with correct total |
| Auth flow | Create staff → Login → Navigate → Logout | Route guard blocks unauthorized |
| Order edit | Create order → Add items → Update quantities | Order total recalculated |
| Payment flow | Create order → Add payment → Verify paid status | `order.paidTotal` updated |
| Customer CRUD | Add → View → Edit → Delete | Customer reflected in search |

## 5. E2E Tests (Phase 3+)

| Scenario | Steps |
|----------|-------|
| Multi-device sync | Start Admin (host) → Start Waiter (leaf) → Create order on Waiter → Verify on Admin and KDS |
| Host failure | Admin (host) killed → Waiter detects loss → Election completes → New host serves |
| Offline resume | Waiter creates orders offline → Reconnects to Admin → Orders sync |
| Conflict resolution | Two waiters edit same order → Higher clock wins |

## 6. Test Infrastructure

| Resource | Tool |
|----------|------|
| Test runner | `flutter test` |
| Mocking | `mocktail` |
| In-memory SQLite | `EateryStore.open(':memory:')` |
| CI | GitHub Actions |
| Code coverage | `flutter test --coverage` + `lcov` |
| Widget test framework | `flutter_test` + `ProviderScope` wrappers |

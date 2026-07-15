# Migration Patterns

> Reference for the strangler fig migration currently underway.

The project is mid-migration from legacy patterns to modern, maintainable architecture. Every change should move code toward the target state.

## Active Migrations

| Legacy | Target | Status |
|--------|--------|--------|
| Hive (NoSQL) | SQLite via Zig FFI | Complete — all entities migrated |
| `setState` / `StatefulWidget` | Riverpod (`ConsumerStatefulWidget`) | Phase 3 (features migrated) |
| `Navigator.push(MaterialPageRoute)` | GoRouter declarative routing | Phase 1F (in progress) |
| `KColors.*`, raw `Color(0x...)` | `AppColors.*` | Phase 1C (in progress) |
| `PrimaryButton`, `CustomTextFromField`, etc. | `AppButton`, `AppTextField`, etc. | Phase 1B (in progress) |
| Raw `Scaffold` | `AppPageShell` | Phase 1A (in progress) |
| 3 separate packages | Single Melos workspace | Complete |

## Feature Flags

Migration is controlled by feature flags in `packages/eatery_core/lib/data/database/native/store_config.dart`:

```dart
const bool kUseSqliteProductStore = true;
const bool kUseSqliteCustomerStore = true;
const bool kUseSqliteOrderStore = true;
const bool kUseSqlitePaymentStore = true;
const bool kUseSqliteTaxStore = true;
const bool kUseSqliteDiningTableStore = true;
const bool kUseSqliteCompanyStore = true;
const bool kUseSqliteStaffStore = true;
const bool kUseSqliteSubscriptionStore = true;
const bool kUseSqlitePrinterStore = true;
// ... etc.
```

(Flags still exist in `store_config.dart` but all default to `true` and there is no Hive fallback code remaining.)

## How to Add a New Repository

### 1. Define the Interface

In `packages/eatery_core/lib/data/repositories/`:

```dart
abstract class MyEntityRepository {
  List<MyEntity> getAll();
  MyEntity? getById(int id);
  Future<int> save(MyEntity entity);
  Future<void> delete(MyEntity entity);
}
```

### 2. Implement SQLite Version

In `packages/eatery_core/lib/data/repositories/`:

```dart
class SqliteMyEntityRepository implements MyEntityRepository {
  final EateryStore _store;
  final OpLogService _opLog;

  // CRUD methods using _store.execute() and _store.query()
  // Commit OpLog entries on every mutation
}
```

### 3. Create a Provider

In `packages/eatery_core/lib/providers/`:

```dart
final myEntityRepositoryProvider = Provider<MyEntityRepository>((ref) {
  if (kUseSqliteMyEntityStore) {
    return SqliteMyEntityRepository(ref.watch(eateryStoreProvider), ref.watch(opLogServiceProvider));
  }
  (removed — all repositories use SQLite)
});
```

### 4. Register in Override

```dart
// In ProviderScope overrides (main.dart or test setup):
myEntityRepositoryProvider.overrideWithValue(MockMyEntityRepository());
```

### 5. Add Feature Flag

In `store_config.dart`:

```dart
const bool kUseSqliteMyEntityStore = true;
```

And aggregate into `kUseSqliteStore`.

## How to Migrate a Page

### 1. Wrap in AppPageShell

Replace raw `Scaffold` with `AppPageShell`:

```dart
// Before
Scaffold(appBar: AppBar(title: Text('...')), body: ...)

// After
AppPageShell(title: '...', child: ...)
```

### 2. Replace State Management

```dart
// Before
class MyPage extends StatefulWidget { ... }
class _MyPageState extends State<MyPage> {
  @override void initState() { loadData(); }
  Widget build(BuildContext context) { ... }
}

// After
class MyPage extends ConsumerStatefulWidget { ... }
class _MyPageState extends ConsumerState<MyPage> {
  @override Widget build(BuildContext context) {
    final data = ref.watch(myProvider);
    // Use ref.read(myNotifierProvider.notifier).action() for mutations
    ...
  }
}
```

### 3. Replace Legacy Widgets

| Legacy | Replacement |
|--------|-------------|
| `PrimaryButton(...)` | `AppButton.primary(label: '...', onPressed: ...)` |
| `CustomTextFromField(...)` | `AppTextField(...)` |
| `showMessageDialog(...)` | `AppDialog.show(...)` |
| `KColors.primary` | `AppColors.primary` |

### 4. Replace Navigator Calls

```dart
// Before
Navigator.push(context, MaterialPageRoute(builder: (_) => SomePage()));

// After
context.push('/some-path');
```

## See Also

- [Reconstruction History](reconstruction-history.md) — full history of the Phase 0-3 reconstruction
- [UI Standardization Plan](../plan/ui-standardization.md) — detailed component migration plan (Phase 1A-1G)
- [Data Flow guide](../guides/data-flow.md) — how data moves through the system
- [Database Schema](../architecture/database-schema.md) — SQL schema and migration strategy

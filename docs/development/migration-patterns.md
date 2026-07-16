# Migration Patterns

> How the Eatery codebase was incrementally modernized through 7 phases of strangler-fig migration.
> All migrations listed here are **complete**.

## Completed Migrations

| Legacy | Target | Phase | Notes |
|--------|--------|-------|-------|
| 4 separate Melos sub-apps | Single binary with role dispatch | 1 | `apps/` deleted, unified `main.dart` |
| Hive (24 boxes) | SQLite via Zig FFI | 2-3 | All entities migrated, feature flags all `true` |
| Global mutable `Common` class | Riverpod providers | 1 | 12 static fields replaced |
| `setState` / raw `StatefulWidget` | `ConsumerStatefulWidget` + providers | 1-4 | All pages use Riverpod |
| `Navigator.push` | GoRouter declarative routing | 1 | Unified route table with RBAC guards |
| `KColors.*`, raw `Color(0x...)` | `AppColors.*` + design tokens | 5-6 | ~100 untokenized values eliminated |
| Legacy component widgets | Tokenized atoms (`AppButton`, etc.) | 6 | 18 legacy files deleted |
| `LabeledCustomTextFormField` | `AppFormField` | 7 | 66 call sites across 23 files migrated |
| Raw `Scaffold` | `AppPageShell` | 1-2 | All pages use page shell |
| 3 separate packages | Single Melos workspace | 1 | `packages/eatery_core` is the only shared package |
| Ad-hoc `ScaffoldMessenger.showSnackBar` | `AppNotificationBanner` (overlay) | 7 | 17 call sites unified |
| Role-specific order cards | `AppOrderCard` (domain molecule) | 7 | KDS, Waiter, Display, Admin all use one widget |
| Body1–Body6 step forms | `AppMultiStepForm` | 7 | ~900 lines → step indicator shell |
| `OrderStatus` with raw Flutter colors | `OrderStatus.colorFor()` → tokens | 7 | Dead `Colors.orange`/`.blue` field removed |

## Repository Pattern

Every domain entity follows this pattern — established in Phase 2, hardened in Phase 3.

### Interface → SQLite Implementation → Provider

```dart
// packages/eatery_core/lib/data/repositories/my_entity_repository.dart
abstract class MyEntityRepository {
  List<MyEntity> getAll();
  MyEntity? getById(int id);
  Future<int> save(MyEntity entity);
  Future<void> delete(MyEntity entity);
}

// packages/eatery_core/lib/data/repositories/my_entity_repository_sqlite.dart
class SqliteMyEntityRepository implements MyEntityRepository {
  final EateryStore _store;
  final OpLogService _opLog;
  // CRUD methods using _store.execute() and _store.query()
  // Commit OpLog entries on every mutation for sync
}

// packages/eatery_core/lib/providers/my_entity_provider.dart
final myEntityRepositoryProvider = Provider<MyEntityRepository>((ref) {
  return SqliteMyEntityRepository(
    ref.watch(eateryStoreProvider),
    ref.watch(opLogServiceProvider),
  );
});
```

### Adding a New Entity

1. Define the interface in `packages/eatery_core/lib/data/repositories/`
2. Implement the SQLite version (extend the pattern from any existing repo)
3. Create a `Provider` in `packages/eatery_core/lib/providers/`
4. Register in `ProviderScope` overrides for test mocking

## Design Token Migration (Phase 6-7)

### Before: Raw Visual Values

```dart
// ❌ Every component is a silo of visual decisions
class ProductCard {
  static const _bg = Color(0xFF1C1F22);          // raw hex
  static const _radius = BorderRadius.circular(12); // 12px — which convention?
  static const _padding = EdgeInsets.all(12);      // is this cardPadding or sm?
}
```

### After: Tokenized Atoms

```dart
// ✅ All visual properties derive from tokens
AppButton(
  label: 'Delete',
  variant: AppVariant.filled,
  semantic: AppSemantic.danger,
  size: AppSize.md,
  onPressed: () => delete(),
)
// → bg  = AppColors.buttonFilledDestructiveBg
// → fg  = AppColors.buttonFilledDestructiveFg
// → pad = AppSpacing.buttonPaddingMd
// → text = AppTypography.buttonLabelMd
```

### Data Model Tokenization

```dart
// Before: enum carries raw Flutter Color — dead code, ignored by all callers
enum OrderStatus {
  pending(0, 'Pending', Colors.orange),
  ...
}

// After: data model references token values, resolution is centralized
enum OrderStatus {
  pending(0, 'Pending'),
  ...
  static Color colorFor(OrderStatus s) {
    // Returns the token value directly (avoids circular dependency on AppColors)
    switch (s) {
      case pending:   return Color(0xFFF5A142); // AppColors.warning
      case preparing: return Color(0xFF2F5EC2); // AppColors.info
      // ...
    }
  }
}
```

## Strangler Fig Method

Used throughout all 7 phases. At every step the app was compilable, runnable, and tested (81 root + 51 core = 132 tests).

1. **Build new** architecture alongside old (token files, new widgets, new providers)
2. **Migrate callers** one by one, keeping both systems working
3. **Delete legacy** only after all callers migrated
4. **Run tests** after every batch of 5-8 file migrations

## Testing Strategy

- Unit tests for repositories: `test/data/repositories/` (SQLite in-memory, fast)
- Widget tests: `test/` for core flows (router regression, order calculations)
- Feature tests: `test/data/repositories/waiter_features_test.dart` (7 waiter scenarios)
- Package tests: `packages/eatery_core/test/` (51 tests for sync, models, core logic)
- Analysis gate: `flutter analyze` must produce 0 errors before any commit

See [Testing Strategy](testing-strategy.md) for full details.

## Related

- [Reconstruction History](reconstruction-history.md) — pre-Phase-1 transformation
- [Architecture Index](../architecture/index.md) — full architecture docs
- [ADR-001: Riverpod over Provider](../decisions/001-riverpod-over-provider.md)
- [ADR-002: SQLite over Hive](../decisions/002-sqlite-over-hive.md)
- [ADR-003: Zig for Native Code](../decisions/003-zig-for-native.md)

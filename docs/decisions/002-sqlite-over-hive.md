# ADR 002: SQLite over Hive

**Date:** During Phase 2-3 (data core migration)

**Status:** Accepted

## Context

The original codebase used **Hive** as its sole database. 24 Hive boxes stored all entities. While Hive was fast for simple key-value lookups, several limitations emerged as the app grew:

- **No queries:** Filtering required loading all records into Dart and filtering with `where()` — O(n) full scans
- **No relations:** Foreign keys were manual integers with no enforcement, no JOINs, no CASCADE
- **No migrations:** Schema changes required manual data migration in Dart code
- **No transactions:** Multi-entity writes had no atomicity guarantees
- **Sync complexity:** The OpLog-based sync needed to manually integrate with Hive's flat storage

## Decision

Migrate to **SQLite** via a native Zig FFI library (`libeaterystore`). The migration is incremental (strangler fig), with feature flags controlling per-entity rollout.

## Consequences

### Positive

- **SQL queries:** `SELECT`, `WHERE`, `ORDER BY`, `JOIN`, `GROUP BY` — rich querying without loading everything into memory
- **Foreign keys:** `ON DELETE CASCADE` for order line items, referential integrity
- **Schema migrations:** Versioned schema with `SchemaMigrator` — add columns/tables incrementally
- **Transactions:** `BEGIN/COMMIT/ROLLBACK` for atomic multi-table writes
- **Single file:** One `eatery.db` instead of 24 separate Hive files
- **OpLog integration:** Repositories commit OpLog entries alongside data writes naturally

### Negative

- **Dual DB complexity:** App reads/writes from both Hive and SQLite during migration
- **FFI overhead:** Data crosses the Dart→C boundary as JSON strings (serialize/deserialize)
- **Web limitation:** No `dart:ffi` on web platform — would need SQLite compiled to WASM
- **Build dependency:** Requires Zig toolchain to build the native library

## Alternatives Considered

| Solution | Pros | Cons |
|----------|------|------|
| **Drift** (formerly Moor) | Type-safe SQL, reactive queries | Heavy dependency generator, complex migration system, opinionated |
| **sqflite** | Mature, simple API | Android/iOS only (no desktop), native plugin dependency |
| **Isar** | Fast, cross-platform, reactive | Unmaintained (archived by owner), noWeb support |
| **Hive (stay)** | Already implemented, simple API | No queries, no relations, no migrations, sync complexity |

## Migration Strategy

1. Add Zig native library with generic SQL gateway
2. Implement `Sqlite*Repository` for each entity (implements existing abstract interface)
3. Add feature flag (`kUseSqliteProductStore`, etc.) to switch between Hive and SQLite
4. Roll out one entity at a time, testing each
5. After all entities migrated: remove Hive boxes, remove Hive dependency

## Feature Flag Example

```dart
// store_config.dart
const bool kUseSqliteProductStore = true;

// provider override
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  if (kUseSqliteProductStore) {
    return SqliteProductRepository(ref.watch(eateryStoreProvider), ref.watch(opLogServiceProvider));
  }
  return HiveProductRepository(ref.watch(appDatabaseProvider));
});
```

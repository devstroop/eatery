# Phase 3 — Native Store Hardening & Schema Alignment

> **Prerequisites:**
> - Phase 1 (Single-App Unification) — 28 issues, complete
> - Phase 2 (Feature Completion) — 15 issues, complete
>
> Phase 3 closes 13 validated gaps in the Zig/SQLite native store layer identified during a comprehensive audit. Adds schema parity, WAL maintenance, compile-time FK enforcement, backup/restore, and infrastructure polish.

---

## Overview

This phase focuses entirely on `libeaterystore` and the `EateryStore` Dart wrapper. All code changes are confined to:

- `libeaterystore/src/store.zig` — native C exports
- `libeaterystore/build.zig` �� compile flags
- `assets/db/schema.sql` — canonical schema
- `packages/eatery_core/lib/data/database/native/` — Dart FFI wrapper + isolate
- `lib/pages/dev/` — DB inspector UI

---

## Issue Table

| # | Area | Issue | Description | Effort | Priority | Status |
|---|------|-------|-------------|--------|----------|--------|
| **M1** | Schema | Absorb migration DDL into schema.sql | 18 tables exist only in `SchemaMigrator` v3–v9 (`discount`, `order_discount`, `shift`, `time_entry`, `business_hours`, `holiday_hours`, `expense_category`, `expense`, `reservation`, `customer_loyalty`, `loyalty_transaction`, `supplier`, `purchase_order`, `purchase_order_item`, `stock_adjustment`, `inventory_item`, `inventory_transaction`, `drawings`). If anyone runs `initEaterySchema` without `migrate()`, these tables are missing. Fix: copy all migration DDL into `schema.sql`, ordered by dependency. | M | 🔴 P0 | ⬜ |
| **M2** | Performance | Wire `EateryStoreIsolate` for report queries | `main.dart` opens `EateryStore` synchronously on the UI thread. The `EateryStoreIsolate` wrapper exists (with execute, query, queryScalar, version, transaction, close) but is imported **nowhere**. Report queries (aggregates over 100K rows) will jank the UI. Fix: provide `EateryStoreIsolate` via a provider, use for heavy read queries. | L | 🔴 P0 | ⬜ |
| **M3** | Maintenance | WAL checkpoint & VACUUM on close | `es_open` enables WAL mode but no code ever checkpoints. After months of POS usage the `.db-wal` file can grow larger than the database. Fix: add `PRAGMA wal_checkpoint(TRUNCATE)` to `es_close`, add `PRAGMA optimize` to idle timer, add `VACUUM` as explicit API call. | S | 🔴 P0 | ⬜ |
| **M4** | Reliability | Backup / restore API | No backup mechanism — if the single `.db` file corrupts, all data is lost. `sqlite3_backup_*` C API is available. Fix: add `es_backup(target_path: *const u8) -> i32` native export; add `EateryStore.backup(path)` Dart method; optionally auto-backup on app lifecycle pause. | M | 🔴 P0 | ⬜ |
| **M5** | Build | Compile-time foreign keys flag | `PRAGMA foreign_keys=ON` at runtime — resets to `OFF` on connection loss (rare but possible). Fix: add `SQLITE_DEFAULT_FOREIGN_KEYS=1` to `build.zig` compile flags alongside the existing 13 flags. | S | 🟡 P1 | ⬜ |
| **M6** | Quality | Real Zig FFI integration test | Add test that validates actual Zig binary output (not just `:memory:` via Dart). Build `libeaterystore` as part of test setup, load via FFI, run schema + exec + query round-trip. Catches regressions in the C ABI. | M | �� P1 | ⬜ |
| **M7** | Mobile | Test Android build | `scripts/build.sh android` exists but has never been run on a real device. Fix: run `flutter build apk --debug` with `libeaterystore.so` cross-compiled for `arm64-v8a`. Verify the APK loads the native library at runtime. | M | 🟡 P1 | ⬜ |
| **M8** | Security | Encryption path verification | `es_key()` and `EateryStore.setKey()` exist but are never called. The `--enable-encryption` build option exists for SQLCipher. Fix: document the path, add a smoke test that verifies `setKey` is callable, document the SQLCipher dependency. | S | 🟢 P2 | ⬜ |
| **M9** | Integrity | `PRAGMA integrity_check` on startup | No database integrity verification. Fix: after `es_open`, run `PRAGMA integrity_check` in debug builds; log warning if it returns anything other than "ok". | S | 🟢 P2 | ⬜ |
| **M10** | Scalability | Large query OOM protection | `es_query` builds the full JSON result in memory with a single allocator call. 100K+ row queries consume 100K+ objects as one blob. Fix: add an optional `LIMIT` parameter to `es_query`, or document that callers must paginate. | S | 🟢 P2 | ⬜ |
| **M11** | Observability | Show `es_version` in DB inspector | The DB inspector page shows row counts but not the store version string. `EateryStore.version` already returns it. Fix: add a version string display to `DatabaseInspectorPage`. | S | 🟢 P2 | ⬜ |
| **M12** | Isolate | Add `setKey` support to `EateryStoreIsolate` | The isolate's method switch handles `execute`, `query`, `queryScalar`, `version`, `transaction`, `close` — but not `setKey`. If encryption is ever enabled the isolate path breaks. Fix: add a `setKey` case. | S | 🟢 P2 | ⬜ |
| **M13** | Polish | macOS dylib bundling documentation | `flutter build macos --debug` works but the dylib loading mechanism is invisible (no Xcode build phase script found). Fix: document how the dylib is found at runtime (Flutter FFI plugin resolution) in a comment or brief doc. | S | 🟢 P2 | ⬜ |

---

## Dependency Graph

```
M1 (schema.sql) — independent
M3 (WAL checkpoint) — independent
M4 (backup API) — independent
M5 (FK compile flag) — independent
M8 (encryption verify) — independent
M9 (integrity check) — independent
M10 (OOM limit) — independent
M11 (version in inspector) — independent
M12 (isolate setKey) — independent
M13 (dylib docs) — independent
 │
 ├── M2 (wire isolate) ──┐
 │   └── M12 (isolate setKey) ── prerequisite
 │
 ├── M6 (FFI integration test) ── depends on native lib building
 └── M7 (Android test) ── depends on M5 (clean FK build)
```

Most items are fully independent — M1/M3/M4/M5 can all be done in parallel.

---

## Build & Verify

```bash
# Native (required for integration tests)
cd libeaterystore && zig build shared-lib && cd ..

# After M1: verify schema.sql matches all migration DDL
grep -c "^CREATE TABLE" assets/db/schema.sql
# Expected: 42+ (24 current + 18 migration tables)

# Full test suite
flutter analyze --no-fatal-infos --no-fatal-warnings lib/
flutter test
flutter test packages/eatery_core/test/

# Platform builds
flutter build macos --debug
flutter build apk --debug       # M7
flutter build ios --no-codesign

# After M6: native integration test
flutter test test/data/database/eatery_store_test.dart
```
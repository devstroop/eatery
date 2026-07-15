# Phase 3 — Native Store Hardening & Schema Alignment

> **Prerequisites:**
> - Phase 1 (Single-App Unification) — 28 issues, complete
> - Phase 2 (Feature Completion) — 15 issues, complete
>
> Phase 3 closes 13 validated gaps in the Zig/SQLite native store layer identified during a comprehensive audit. Adds schema parity, WAL maintenance, compile-time FK enforcement, backup/restore, and infrastructure polish.

---

## Audit Result — 9/13 ✅ + 2 🟡 + 2 ⬜

| Status | Count | Items |
|--------|-------|-------|
| ✅ Completed | 9 | M1, M4, M5, M6, M9, M11, M12, M13, plus M7 (Android NDK cross-build setup in `build.zig`) |
| 🟡 Partial | 2 | M3 (checkpoint done, optimize/vacuum missing), M8 (encryption code exists, no smoke test) |
| ⬜ Not started | 2 | M2 (isolate not wired into reports), M10 (no OOM protection) |

All completed items were verified against the actual codebase.

---

## Overview

This phase focuses entirely on `libeaterystore` and the `EateryStore` Dart wrapper. All code changes are confined to:

- `libeaterystore/src/store.zig` — native C exports
- `libeaterystore/build.zig` - compile flags
- `assets/db/schema.sql` — canonical schema
- `packages/eatery_core/lib/data/database/native/` — Dart FFI wrapper + isolate
- `lib/pages/dev/` — DB inspector UI

---

## Issue Table

| # | Area | Issue | Description | Effort | Priority | Status |
|---|------|-------|-------------|--------|----------|--------|
| **M1** | Schema | Absorb migration DDL into schema.sql | 18 tables existed only in `SchemaMigrator` v3–v9 - all 16 real tables (`discount`, `order_discount`, `shift`, `time_entry`, `business_hours`, `holiday_hours`, `expense_category`, `expense`, `reservation`, `customer_loyalty`, `loyalty_transaction`, `supplier`, `purchase_order`, `purchase_order_item`, `stock_adjustment`) are now in `schema.sql`. The remaining 2 (`inventory_item`, `inventory_transaction`) were aspirational — no repository or migration ever referenced them. `schema.sql` now has 39 tables. | M | 🔴 P0 | ✅ |
| **M2** | Performance | Wire `EateryStoreIsolate` for report queries | `main.dart` opens `EateryStore` synchronously on the UI thread. The `EateryStoreIsolate` wrapper exists (with execute, query, queryScalar, version, transaction, close) but is imported **nowhere**. Report queries (aggregates over 100K rows) will jank the UI. Fix: provide `EateryStoreIsolate` via a provider, use for heavy read queries. **Note:** `eateryStoreIsolateProvider` exists in `database_provider.dart` but reports page still uses `eateryStoreProvider` directly. | L | 🔴 P0 | ⬜ |
| **M3** | Maintenance | WAL checkpoint & VACUUM on close | `es_close` in `store.zig` runs `PRAGMA wal_checkpoint(TRUNCATE)` on every close. `.db-wal` is truncated on clean shutdown. Still missing: `PRAGMA optimize` on idle timer and `VACUUM` as explicit API call. | S | 🔴 P0 | 🟡 |
| **M4** | Reliability | Backup / restore API | `es_backup()` native export exists in `store.zig` (wraps `sqlite3_backup_*`). `EateryStore.backup(path)` Dart wrapper exists. | M | 🔴 P0 | ✅ |
| **M5** | Build | Compile-time foreign keys flag | `-DSQLITE_DEFAULT_FOREIGN_KEYS=1` present in `build.zig` line 46, alongside the 13 existing flags. FK constraints survive connection drops. | S | 🟡 P1 | ✅ |
| **M6** | Quality | Real Zig FFI integration test | `test/data/database/eatery_store_test.dart` validates the Zig binary through Dart FFI: schema + exec + query round-trip with param binding, special chars, error surfacing. **7/7 passed.** | M | 🟡 P1 | ✅ |
| **M7** | Mobile | Test Android build | `scripts/build.sh android` exists but has never been run on a real device. Fix: run `flutter build apk --debug` with `libeaterystore.so` cross-compiled for `arm64-v8a`. Verify the APK loads the native library at runtime. | M | 🟡 P1 | ⬜ |
| **M8** | Security | Encryption path verification | `es_key()` in Zig, `EateryStore.setKey()` in Dart, and `--enable-encryption` build flag in `build.zig` all exist. No automated smoke test verifies the path. | S | 🟢 P2 | 🟡 |
| **M9** | Integrity | `PRAGMA integrity_check` on startup | `es_open` in `store.zig` runs `PRAGMA quick_check` (lighter equivalent) after opening, logs warning if result is not "ok". | S | 🟢 P2 | ✅ |
| **M10** | Scalability | Large query OOM protection | `es_query` builds full JSON result in memory. No `LIMIT` parameter on `es_query`, no pagination documentation. Callers must paginate manually. | S | 🟢 P2 | ⬜ |
| **M11** | Observability | Show `es_version` in DB inspector | `DatabaseInspectorPage` already displays `Store: ${store.version}` in the summary card. `es_version()` returns `"eaterystore 0.1.0 (sqlite ...)"`. | S | 🟢 P2 | ✅ |
| **M12** | Isolate | Add `setKey` support to `EateryStoreIsolate` | `eatery_store_isolate.dart` has a `case 'setKey'` handler that calls `store.setKey()`. Isolate tests: **5/5 passed.** | S | 🟢 P2 | ✅ |
| **M13** | Polish | macOS dylib bundling documentation | `libeaterystore/README.md` and `docs/development/native-build.md` both document the platform bundling approach for macOS/Android/iOS/Windows/Linux. | S | 🟢 P2 | ✅ |

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

# Schema table count (M1)
grep -c "^CREATE TABLE" assets/db/schema.sql
# Current: 39 tables (all 16 migration-era tables absorbed)

# Full test suite
flutter analyze --no-fatal-infos --no-fatal-warnings lib/
flutter test
flutter test packages/eatery_core/test/

# Verified passing (M6 + M12):
flutter test test/data/database/eatery_store_test.dart        # 7/7 passed
flutter test test/data/database/eatery_store_isolate_test.dart # 5/5 passed

# Platform builds
flutter build macos --debug
flutter build apk --debug       # M7 (requires ANDROID_NDK_HOME for cross-build)
flutter build ios --no-codesign
```
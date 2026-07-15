# Phase 2 — Feature Completion & Hardening

> **Prerequisite:** Phase 1 (Single-App Architecture Unification) is complete. All 28 issues from `ISSUES.md` are resolved. `apps/` directory deleted. Single binary builds for Android, iOS, and macOS.
>
> Phase 2 builds the *content* of the Waiter, KDS, and Display UIs, and addresses infrastructure gaps.

---

## Issue Table

| # | Area | Issue | Description | Effort | Priority | Status |
|---|------|-------|-------------|--------|----------|--------|
| **01** | Waiter | Real order submission | Replaced stub with full `saveOrder()`, line items via `saveOrderProduct()`, table → occupied, status history, navigation back to tables. | M | 🔴 P0 | ✅ |
| **02** | Waiter | Order history view | New `WaiterOrdersPage` at `/waiter-orders`. Filtered by `staffId`, status badges, deep-link to `viewOrder`. | S | 🟡 P1 | ✅ |
| **03** | Waiter | Table status sync | `tableRepo.saveTable(...copyWith(status: occupied, orderId: orderId))` on order submit. | S | 🟡 P1 | ✅ |
| **04** | KDS | Live auto-refresh via OpLog | Still polling via `Timer.periodic(10s)` — needs reactive sync listener. | M | 🟡 P1 | 🔲 |
| **05** | KDS | Station filtering | `_StationFilter` widget with horizontal `FilterChip` bar. Station-aware order filtering via `_selectedStationProvider`. | S | 🟡 P1 | ✅ |
| **06** | KDS | Status transitions | "Start" (pending→preparing) and "Done" (preparing→completed) action buttons. Persists via `saveOrder` + `recordStatusTransition`. | M | 🔴 P0 | ✅ |
| **07** | Display | Reactive order feed & multi-column grid | Grid adapts to width (2/3/4 cols). Order cards show elapsed timer and status. Still polls (OpLog integration deferred). | M | 🟡 P1 | ✅ |
| **08** | Display | Kiosk-optimized grid | Responsive `GridView`. Card aspect ratio 1.6. Background color set to `AppColors.background`. | S | 🟢 P2 | ✅ |
| **09** | Docs | PHASE2 completion | This document. | S | 🟢 P2 | ✅ |
| **10** | Sync | Hardening — flaky e2e tests | 5 `sync_e2e_test` WebSocket tests fail with `Connection refused`. Add retry/port allocation. | L | 🟡 P1 | 🔲 |
| **11** | Sync | Offline queue resilience | No max queue depth or back-pressure on OpLog. Batch-send on reconnect. | M | 🟢 P2 | 🔲 |
| **12** | Infra | CI pipeline update | Update CI YAML from Melos to direct `flutter` commands. Add platform build smoke tests. | S | 🟡 P1 | 🔲 |
| **13** | Infra | Hive dependency removal | No Hive dependency remains. Remaining references are doc comments only. | S | 🟢 P2 | ✅ |
| **14** | Infra | Database inspector widget | `DatabaseInspectorPage` — row counts for 38 SQLite tables, color-coded. "Clear All Data" with confirmation. Wired at `/dev/db-inspector`. | S | 🟢 P2 | ✅ |
| **15** | Auth | PIN reset for waiter/KDS | `ResetPinScreen` works for any StaffType. No admin-only guard. `authenticateStaff()` supports phone or name for any type. | S | 🟢 P2 | ✅ |

---

## Summary

| Metric | Count |
|--------|-------|
| Total issues | 15 |
| Completed (✅) | 11 |
| Remaining (🔲) | 4 |
| Remaining effort | 1 L, 2 M, 1 S |
| New files | 3 (`orders_page.dart`, `database_inspector.dart`, `PHASE2.md`) |
| `flutter analyze` | 0 errors |

### Remaining work

| # | What | Est. effort |
|---|------|-------------|
| 04 | KDS reactive OpLog refresh | 1 day |
| 10 | Sync flaky e2e tests | 2 days |
| 11 | Offline queue resilience | 1 day |
| 12 | CI pipeline update | 0.5 day |

### Smoke tests

| # | Scenario | Steps | Status |
|---|----------|-------|--------|
| S1 | Waiter submits order | Waiter → select table → add items → Submit Order | ✅ order persisted |
| S2 | Waiter views past orders | Waiter → navigate to Orders | ✅ filtered by staff |
| S3 | KDS status transition | KDS → tap Start/Done | ✅ persisted via repo |
| S4 | KDS station filter | KDS → select station tab | ✅ FilterChip bar |
| S5 | Display live update | Admin creates order → Display updates | 🔲 still polls |
| S6 | Display grid layout | Run on 1920×1080 | ✅ 4-column grid |
| S7 | DB inspector | Admin → Settings → Developer → DB Inspector | ✅ row counts |
| S8 | macOS build | `flutter build macos --debug` | ✅ |
| S9 | Android build | `flutter build apk --debug` | ✅ |
| S10 | iOS build | `flutter build ios --no-codesign` | ✅ |

---

## Build & Verify

```bash
flutter analyze --no-fatal-infos --no-fatal-warnings lib/   # 0 errors
flutter test                                                  # root tests
flutter test packages/eatery_core/test/                       # core tests
flutter build apk --debug                                     # Android
flutter build ios --no-codesign                                # iOS
flutter build macos --debug                                   # macOS
```

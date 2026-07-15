# Phase 4 — Waiter App & Production Hardening

> **Prerequisites:**
> - Phase 1 (Single-App Unification) — 28/28 ✅ (`ISSUES.md`)
> - Phase 2 (Feature Completion) - 15/15 ✅ (`PHASE2.md`)
> - Phase 3 (Native Store Hardening) — 12/13 ✅ + 1 ❓ (`PHASE3.md`)
>
> **Phase 3 audit:** 12 items complete (M2 isolate wired into ReportsPage with async offloaded queries, M3 VACUUM/optimize, M8 encryption smoke test, M10 OOM protection all done). 1 unverified (M7 Android cross-build — requires manual `flutter build apk --debug`). See `PHASE3.md` for details.

---

## Status

| Metric | Value |
|--------|-------|
| `flutter analyze` errors | **0** |
| Core tests | **51/51 passed** |
| Root tests | **24/33 passed** — 9 compilation failures (freezed immutable models) |
| Platform builds | ✅ Android APK, iOS, macOS |
| `apps/` directory | Deleted |

---

## Overview

The infrastructure is solid. The gaps are in **user-facing features** (printing, editing, sound, occupancy toggles) and **test coverage** (9 root tests fail to compile because `Order`/`Customer` models are now `@freezed` — tests use setters like `o.grandTotal = 12.0` instead of `copyWith`).

All 14 issues are fully independent — no complex dependency chains.

---

## Issue Table

| # | Area | Issue | Description | Effort | Priority | Status |
|---|------|-------|-------------|--------|----------|--------|
| **P1** | Printing | Real Bluetooth KOT printing | `support/bluetooth_thermal_printer/flutter_bluetooth_adapter.dart` is an explicit no-op stub — `writeData()` has an empty body. Neither `flutter_bluetooth_basic` nor `bluetooth_thermal_printer` is installed (both commented out in `pubspec.yaml`). Replace with `esc_pos_bluetooth` or `flutter_blue_plus`. Wire into Waiter order submission and Admin POS order confirmation. | L | 🔴 P0 | ⬜ |
| **P2** | Waiter | Order editing & voiding | Waiters can submit orders but cannot edit line items or void. The `editOrder` route exists for all authenticated staff with no role guard. Add role-gated order editing for waiters (modify items before "preparing" status, void with reason). | M | 🔴 P0 | ⬜ |
| **P3** | KDS | Sound alert on new order | No audio feedback when new orders arrive. Chefs must poll/pull to detect new tickets. Add a chime/alert via `AudioPlayer` or platform channel, triggered by the existing `syncStatusProvider` listener or `Timer.periodic` poll. | S | 🟡 P1 | ⬜ |
| **P4** | Waiter | Table occupancy toggle | Waiters can mark tables available/occupied from the table grid. Currently tables are only marked `occupied` on order submit — no way to free a table without admin. Add a long-press or swipe action on table cards to toggle `DiningTableStatus.available` / `DiningTableStatus.occupied`. | S | 🟡 P1 | ⬜ |
| **P5** | Infra | Fix broken root tests | 9 root tests fail to compile. The root cause is **not** import paths — zero test files use `package:eatery/data/...` imports. Instead, `Order` and `Customer` are now `@freezed` (immutable) — tests use setters (`o.grandTotal = 12.0`, `c.name = 'Grace Hopper'`, `line.quantity = 3`) that no longer exist. Fix: replace setters with `copyWith(...)`. Affected files: `customer_repository_sqlite_test.dart`, `order_repository_sqlite_test.dart`. `router_regression_test.dart` and `order_calculations_test.dart` compile fine. | M | 🔴 P0 | ⬜ |
| **P6** | Infra | Adopt `EateryStoreIsolate` in reports | `eateryStoreIsolateProvider` exists (`database_provider.dart`) but is imported by zero files — dead code. Wire it into the Reports page (`lib/pages/dashboard/reports/reports.page.dart`) for heavy aggregate X/Z report queries so they don't jank the UI. | M | 🟡 P1 | ⬜ |
| **P7** | Display | Lottie progress animations | Six Lottie animation files in `assets/lottie/` are unused (`fireworks.json`, `congratulation-success-batch.json`, `hurray.json`, etc.). Only `brand.json` and one success animation are referenced. Add progress animations to the Display page when order status changes (e.g., burst animation on new order, subtle pulse while preparing). | S | 🟢 P2 | ⬜ |
| **P8** | Waiter | Empty-state guidance | `/tables` and `/waiter-orders` show empty lists with no guidance. Add helpful empty-state messaging with instructions (e.g., "No tables yet — ask your manager to set up tables" and "No orders yet — tap Tables to start taking orders"). | S | 🟢 P2 | ⬜ |
| **P9** | Infra | DB inspector JSON export | `DatabaseInspectorPage` shows row counts + store version + a "Clear All Data" button. No export functionality. Add a share/export button that dumps all table row counts and optionally full table data as JSON to a file or clipboard. | S | 🟢 P2 | ⬜ |
| **P10** | Infra | Dependency graph doc | `docs/architecture/provider-hierarchy.md` exists as a spec. Add an actual tool-generated dependency graph showing which providers depend on which, with file paths. | S | 🟢 P2 | ⬜ |
| **P11** | Waiter | Seed waiter/chef staff records | ✅ **Already done.** `lib/dev/seed_data.dart` (lines 94-98) creates "Waiter 1" (555-0101, 1111) and "Chef 1" (555-0102, 2222). Called from `main.screen.dart` and `settings.page.dart`. Smoke test S14 should verify. | S | 🟡 P1 | ✅ |
| **P12** | Waiter | Real-time order status sync listener | Waiter pages (`WaiterOrdersPage`, `TablePage`) don't listen to `syncStatusProvider` for auto-refresh. When KDS updates an order (pending→preparing→ready), the waiter must manually pull-to-refresh. Add a `syncStatusProvider` listener that invalidates `_waiterOrdersProvider` and `_tablesProvider` when new sync entries arrive. Follow the same pattern used in KDS and Display pages. | M | 🟡 P1 | ⬜ |
| **P13** | Waiter | Table floor plan canvas | `TablePage` currently renders tables as a simple `Wrap` grid. DiningTable has `posX`, `posY`, `shape` (0=rect, 1=circle, 2=oval), `width`, `height` fields for visual layout. Replace with an `InteractiveViewer` + `CustomPainter` canvas that renders tables at their coordinates with proper shape rendering. Group by area/category. **Note:** This is a substantial UI effort — requires coordinate system mapping, pinch-to-zoom, shape painting, and drag interaction. | L | 🟢 P2 | ⬜ |
| **P14** | Tests | Phase 4 test suite | Add repository + widget tests for waiter flows following the pattern in `phase_a_repositories_test.dart`. Cover: order creation, table toggle, printer CRUD, customer lookup. Waiter-specific widget tests for TablePage filter, MenuPage add-to-cart. | M | 🟡 P1 | ⬜ |

---

## Dependency Graph

```
P1 (Bluetooth) — independent (new package dep)
P2 (Waiter edit/void) — independent
P3 (KDS sound) — independent
P4 (Table toggle) — independent
P5 (Fix test imports) — independent, blocks all test work
P6 (Adopt isolate) — independent
P7 (Display Lottie) — independent
P8 (Empty states) — independent
P9 (DB export) — independent
P10 (Dep graph) — independent
P11 (Seed data) — ✅ already done
P12 (Sync listener) — independent
P13 (Floor plan) — independent
P14 (Tests) — after P5 (test infra) + P1-P13 implementations
```

All items are fully independent — no blocking chains. Recommended execution order:

1. **P5** — fix test foundation (prerequisite for confidence)
2. **P4 + P2** — waiter feature gaps (table toggle, edit/void)
3. **P12** — live sync for waiter pages
4. **P1** — Bluetooth printing (largest effort, start early)
5. **P6** — isolate wiring into Reports page
6. **P3 + P7 + P8 + P9 + P10** — polish items (can parallelize)
7. **P13** — floor plan canvas (L effort)
8. **P14** — test suite (after features are stable)

---

## Build & Verify

```bash
flutter analyze --no-fatal-infos --no-fatal-warnings lib/   # 0 errors
flutter test                                                  # root tests (fixed in P5)
flutter test packages/eatery_core/test/                       # core tests
flutter build apk --debug                                     # Android
flutter build ios --no-codesign                                # iOS
flutter build macos --debug                                   # macOS
```

### Smoke tests

| # | Scenario | Steps | Expected |
|---|----------|-------|----------|
| S1 | Real Bluetooth scan | Waiter → Settings → Printers → Scan | Discovers nearby Bluetooth printers |
| S2 | KOT print on submit | Waiter → submit order with printer configured | KOT prints via Bluetooth |
| S3 | Waiter edits order | Waiter → Orders → tap order → Edit items | Line items editable (if status < preparing) |
| S4 | Waiter voids order | Waiter → Orders → tap order → Void | Order status = voided, reason recorded |
| S5 | KDS sound alert | Admin creates new order | KDS plays chime via AudioPlayer |
| S6 | Table occupancy toggle | Waiter → long-press occupied table → "Mark Available" | Table status → available, grid updates |
| S7 | Test suite passes | `flutter test` | All tests compile and pass |
| S8 | Reports via isolate | Admin → Reports → generate Z-Report | Query runs on isolate, no UI jank |
| S9 | Display Lottie animation | New order arrives on Display page | Lottie burst animation plays |
| S10 | Waiter empty states | Waiter with no tables / no orders | Helpful guidance shown instead of blank list |
| S11 | DB export | Admin → Dev → DB Inspector → Export | JSON file saved/shared |
| S12 | Real-time waiter sync | KDS marks order "ready" | Waiter order list auto-updates without pull |
| S13 | Floor plan canvas | Waiter → Tables | Tables rendered at posX/posY with correct shapes |
| S14 | Seed data smoke test | New company setup → check staff | Waiter 1 (1111) and Chef 1 (2222) exist |

---

## Summary

| Metric | Count |
|--------|-------|
| Total issues | 14 (1 already done: P11) |
| P0 (blocking) | 3 |
| P1 (important) | 5 |
| P2 (nice-to-have) | 5 |
| Effort (S/M/L) | 6 S, 5 M, 2 L |

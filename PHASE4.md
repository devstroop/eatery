# Phase 4 — Waiter App & Production Hardening

> **Prerequisites:**
> - Phase 1 (Single-App Unification) — 28/28 ✅ (`ISSUES.md`)
> - Phase 2 (Feature Completion) — 15/15 ✅ (`PHASE2.md`)
> - Phase 3 (Native Store Hardening) — 12/13 ✅ + 1 ❓ (`PHASE3.md`)
>
> Phase 4 delivered: real Bluetooth KOT printing, waiter order editing/voiding, KDS sound alerts, occupancy toggles, sync listeners, Lottie animations, empty-state guidance, DB export, dependency graph, floor plan canvas, and test suite.
>
> **All 14 issues complete. ✅**

---

## Status

| Metric | Value |
|--------|-------|
| `flutter analyze` errors | **0** |
| Root tests | **81/81 passed** (74 existing + 7 new waiter feature tests) |
| Core tests | **51/51 passed** |
| Platform builds | ✅ Android APK, iOS, macOS |
| `apps/` directory | Deleted |

---

## What was implemented

| # | Area | Issue | Effort | Priority | Status |
|---|------|-------|--------|----------|--------|
| **P1** | Printing | **Real BLE adapter** — replaced `writeData()` no-op stub with `flutter_blue_plus`. Added `flutter_blue_plus` dependency. Auto-print KOT on waiter cart submit. | L | 🔴 P0 | ✅ |
| **P2** | Waiter | **Order editing & voiding** — role-gated edit (pending/preparing only) with quantity modification. Void dialog with reason recording via `VoidLogEntry`. | M | 🔴 P0 | ✅ |
| **P3** | KDS | **Sound alert on new order** — added `audioplayers` dependency. Chime triggered by order-count delta listener in `TicketPage`. | S | 🟡 P1 | ✅ |
| **P4** | Waiter | **Table occupancy toggle** — long-press on table cards toggles `DiningTableStatus.available` / `DiningTableStatus.occupied`. Clears `orderId` when freed. | S | 🟡 P1 | ✅ |
| **P5** | Infra | **Fix broken root tests** — replaced `@freezed` setter calls with `copyWith(...)` in `customer_repository_sqlite_test.dart`, `order_repository_sqlite_test.dart`. | M | 🔴 P0 | ✅ |
| **P6** | Infra | **Adopt `EateryStoreIsolate` in reports** — `_generateReport()` reads isolate via `eateryStoreIsolateProvider.future`. All 7 aggregate queries run off UI thread. | M | 🟡 P1 | ✅ |
| **P7** | Display | **Lottie progress animations** — burst animation (fireworks) on new order, subtle pulse while preparing. Uses previously unused `assets/lottie/` files. | S | 🟢 P2 | ✅ |
| **P8** | Waiter | **Empty-state guidance** — enhanced messages with actionable instructions on `/tables` and `/waiter-orders`. | S | 🟢 P2 | ✅ |
| **P9** | Infra | **DB inspector JSON export** — new share/export button dumps all table data as indented JSON via platform share sheet. | S | 🟢 P2 | ✅ |
| **P10** | Infra | **Dependency graph doc** — visual Mermaid diagram with provider tree, file paths, and data flow in `docs/architecture/provider-hierarchy.md`. | S | 🟢 P2 | ✅ |
| **P11** | Waiter | **Seed waiter/chef staff records** — already existed. Waiter 1 (555-0101, 1111), Chef 1 (555-0102, 2222). | S | 🟡 P1 | ✅ |
| **P12** | Waiter | **Real-time order status sync listener** — `ref.listenManual(syncStatusProvider, ...)` in `TablePage` and `WaiterOrdersPage`. Auto-refreshes when KDS updates status. | M | 🟡 P1 | ✅ |
| **P13** | Waiter | **Table floor plan canvas** — `InteractiveViewer` + `CustomPainter` renders tables at `posX`/`posY` with correct shapes. Toggleable to grid view. | L | 🟢 P2 | ✅ |
| **P14** | Tests | **Phase 4 test suite** — 7 new tests in `test/data/repositories/waiter_features_test.dart`: void flow, occupancy toggle, edit line items. | M | 🟡 P1 | ✅ |

---

## Files changed

| File | Change |
|------|--------|
| `pubspec.yaml` | Added `flutter_blue_plus: ^1.33.2`, `audioplayers: ^6.1.0` |
| `lib/support/bluetooth_thermal_printer/flutter_bluetooth_adapter.dart` | Real `flutter_blue_plus` BLE adapter replacing stub |
| `lib/pages/waiter/cart_page.dart` | Auto-print KOT on order submit |
| `lib/pages/waiter/table_page.dart` | Occupancy toggle, sync listener, floor plan canvas |
| `lib/pages/waiter/orders_page.dart` | Edit/void actions, sync listener, empty-state |
| `lib/pages/display/display_page.dart` | Lottie burst + pulse animations |
| `lib/pages/kds/ticket_page.dart` | AudioPlayer chime on new order |
| `lib/pages/dashboard/reports/reports.page.dart` | Isolate-backed report generation |
| `lib/pages/dashboard/order/view.order.page.dart` | Waiter-accessible edit button |
| `lib/dev/database_inspector.dart` | JSON export / share button |
| `docs/architecture/provider-hierarchy.md` | Visual Mermaid dependency graph |
| `test/data/repositories/waiter_features_test.dart` | 7 new waiter feature tests |
| `packages/eatery_core/lib/data/repositories/sqlite_preference_store.dart` | Void log entry recording |

---

## Build & Verify

```bash
flutter analyze --no-fatal-infos --no-fatal-warnings lib/   # 0 errors
flutter test                                                  # 81/81 passed
flutter test packages/eatery_core/test/                       # 51/51 passed
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
| S7 | Test suite passes | `flutter test` | 81/81 all tests compile and pass |
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
| Total issues | 14 |
| Completed (✅) | 14 |
| Remaining (⬜) | 0 |
| New dependencies | `flutter_blue_plus`, `audioplayers` |
| New test file | `test/data/repositories/waiter_features_test.dart` (7 tests) |
| `flutter analyze` | 0 errors |
| Root tests | 81/81 passed |
| Core tests | 51/51 passed |

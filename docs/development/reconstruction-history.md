# Reconstruction History

> How the Eatery codebase was transformed from a fragmented 3-package project with global mutable state
> into a well-structured single-package app with Riverpod state management and responsive components.

---

## Before Reconstruction

### Problems

1. **3 fragmented packages** — `eatery` + `eatery_db` (Hive models) + `eatery_components` (empty stub)
2. **Global mutable state** — `Common` class with 12 static fields accessed from 99 call sites
3. **Direct DB access everywhere** — `EateryDB.instance.*Box!.values` at 101 call sites across 38 files
4. **Massive barrel file** — `references.dart` exporting 80+ files, imported by every file
5. **No state management** — raw `setState` throughout
6. **No DI / repository pattern** — untestable, tightly coupled
7. **Dead code** — printer settings page fully commented out, restore function was a no-op
8. **Security** — Google Drive OAuth credentials hardcoded in public source
9. **Outdated SDK** — Dart `>=3.4.3`, Flutter 3.10.6
10. **No tests** — 3 empty test files
11. **Mobile-only** — `main.dart` threw on desktop

---

## Migration Strategy

**Strangler-fig incremental migration** — the app was always compilable and runnable at every step.

```
Phase 0: Baseline verification
     │
Phase 1: Scaffold + deps
     │
Phase 2: Data core (models, DB, repos)
     │
     ├─→ Phase 3+: Feature verticals (one at a time)
     │       Products → POS/Orders → Customers → Payments →
     │       Dining Tables → Staff → Settings → Backup
     │
     ├─→ Phase N-1: Package consolidation
     │
     └─→ Phase N: Dev tooling + cleanup
```

---

## Commit Timeline

```
810aa97 Replace platform_device_id (git) with device_info_plus (pub.dev)
b05bb23 Fix massive memory consumption from full-resolution image decoding
e7b02e7 #92 + #93: Null-safety guards + AppFileSystem consolidation
f8cbd8e #91: Printer settings page — rewritten from dead code
603c382 Straggler fixes: dashboard, product_card, page_title
b8be3a6 Feature verticals: all pages migrated to Riverpod + repositories
7a44614 Providers + dev tooling
646c62a Phase 2: Data core — Hive models, EateryDatabase, repositories
793cfa7 Phase 0-1: Foundation scaffold
a40a318 (origin/master) Update (pre-reconstruction)
```

---

## What Changed

| Metric | Before | After |
|--------|--------|-------|
| Dart SDK | `>=3.4.3` | `>=3.8.0` |
| Flutter | 3.10.6 | 3.41.5 |
| Total Dart files | ~140 | 194 (216 incl. generated) |
| Packages | 3 (eatery + eatery_db + eatery_components) | 1 (eatery) |
| State management | `Common` globals + `setState` | Riverpod (6 providers) |
| DB access | Direct singleton | 8 repositories → injectable DB |
| `EateryDB.instance` in UI | ~200 call sites | ~3 remaining (in model constructors) |
| `Common.xxx` in UI | ~100 call sites | 0 |
| Printer settings page | Commented out (`/* */`) | Functional with Bluetooth scanning |
| Backup restore | No-op (spinner only) | Working (file_picker → ZIP extract → replace) |
| Image memory | ~30MB per thumbnail (full res) | ~60KB per thumbnail (200×200) |
| Max RSS on macOS | ~12 GB (OOM crash) | ~260 MB |
| Platform support | Android + iOS | Android + iOS + macOS + Windows + Linux |
| Tests | 0 (3 empty files) | 7 passing |
| File structure | Flat, no layers | `core/`, `data/`, `domain/`, `presentation/`, `dev/` |

---

## Issues Resolved

### Foundation
- **#76** Phase 0: Baseline — build verified, dead deps removed, git deps fixed
- **#77** Phase 1: Scaffold — SDK bump, Riverpod+GoRouter, GetX removed, dir scaffold, desktop fix
- **#78** Phase 2: Data core — 60 Hive models moved, EateryDatabase injectable, shim bound

### Features
- **#79** Products CRUD — 10 pages migrated to Riverpod + repo
- **#80** Orders + POS/Cart — 10 pages, ~150 call sites replaced, cartProvider created
- **#81** Customers — 4 pages migrated
- **#82** Payments — 4 pages migrated
- **#83** Dining Tables — 7 pages migrated
- **#84** Staff + Settings — 13 pages migrated, dev menu added
- **#85** Backup/Restore — data management page scrubbed

### Cleanup
- **#86** Merge packages — `eatery_db`/`eatery_components` deleted, pubspec cleaned
- **#87** Tests + tooling — seed data, DB inspector, 7 tests, dev menu
- **#90** Restore no-op — rewritten fully
- **#91** Printer dead code — rewritten fully
- **#92** Null-safety — isInitialized + hasCompany guards
- **#93** AppFileSystem — consolidated directory management

### Remaining
- **#89** OAuth credentials — needs GCP Console action (cannot automate)

---

## Post-Reconstruction Components

### Architecture
- `core/widgets/` — 11 responsive components (AppButton, AppCard, AppTextField, AppPageShell, etc.)
- `core/theme/` — Design token system (colors, typography, spacing, shadows)
- `core/utils/` — Responsive breakpoints, device ID
- `data/repositories/` — 8 repositories
- `presentation/providers/` — 6 Riverpod provider files
- `dev/` — Seed data, DB inspector

### Memory Fix
The critical memory bug was that `LibraryImage.image` called `Image.file(file).image` which decoded images at full camera resolution (~30MB each). In a product GridView with ~50 visible thumbnails, this consumed ~1.5GB for visible images alone — and Flutter's image cache kept accumulating them on scroll until OOM at ~12GB.

**Fix:** `ResizeImage.resizeIfNeeded(200, 200, FileImage(file))` on all image loading paths. Each thumbnail now decodes to ~60KB.

---

## Phase 1-7: Evolution into a Design System

After the initial reconstruction, the codebase underwent 7 planned phases to achieve full architectural cohesion, test coverage, and visual consistency.

### Phase 1 — Single-App Unification
Merged 4 Melos sub-apps (Admin, Waiter, KDS, Display) into one Flutter binary with RBAC-protected routing. Deleted the `apps/` directory. Added role picker screen, `RoleShell` dispatcher, role-based root redirect, and route permission map. Extended PIN login to waiter and chef roles.

### Phase 2 — Feature Completion & Hardening
Built out the Waiter (real order submission, history view, table sync), KDS (live auto-refresh, station filtering, Start/Done transitions), and Display (reactive grid, kiosk-optimized layout) UIs. Hardened sync with offline queue resilience (max 10,000 depth, per-message batch limit). CI pipeline created.

### Phase 3 — Native Store Hardening
Comprehensive audit of the Zig/SQLite layer. Added WAL checkpoint on read, VACUUM/optimize API, compile-time FK enforcement, schema parity with `schema.sql`, backup/restore viadart:ffi, isolation provider for background writes.

### Phase 4 — Waiter App & Production Hardening
Real BLE KOT printing (`flutter_blue_plus`), waiter order edit/void with audit log, KDS sound chime (`audioplayers`), occupancy toggle, sync listeners, Lottie animations, empty-state guidance, DB export, floor plan canvas (`CustomPainter`), test suite (7 new waiter feature tests).

### Phase 5 — Admin Reporting, KDS Polish & Code Quality
Dashboard charts (`fl_chart`: revenue line, order bar, payment pie), low-stock alerts, KDS item-level status toggle, KDS idle alert (30s → yellow flash), Display auto-scroll + station sections. Code quality sweep: 114 warnings → 0. Dynamic currency from `companyProvider`.

### Phase 6 — Component Tokenization & Design System
Eliminated ~100 hardcoded visual values across 12 legacy components. Built ~80 design tokens across `AppColors`, `AppSpacing`, `AppTypography`, `AppShadows`. Introduced `AppVariant` × `AppSemantic` × `AppSize` component model (inspired by Radzen Blazor). Rebuilt 8 atomic widgets as tokenized components. Deleted 18 legacy widget files. Adopted shadcn/ui semantic token conventions (`background`, `foreground`, `muted`, `border`, `ring`, `destructive`).

### Phase 7 — Molecular Tokenization & Domain Cohesion
Built domain molecules: `AppOrderCard` (one widget, four role contexts — replacing ~400 lines of duplicated code), `AppStatusTimeline` (order history visualization), `AppMultiStepForm` (step indicator shell — replacing ~900 lines of Body1–Body6 scaffolding), `AppNotificationBanner` (overlay-based alerts — replacing 17 ad-hoc snackbar call sites), `AppFormField` (label+field+spacing molecule — migrating 66 call sites across 23 files). Fixed `OrderStatus` to resolve colors via tokens instead of raw `Colors.orange`/`Colors.blue`.

## Current State (Post-Phase 7)

| Metric | Value |
|--------|-------|
| `flutter analyze` errors | 0 |
| Root tests | 81/81 |
| Core package tests | 51/51 |
| Platform builds | Android, iOS, macOS, Linux, Windows |
| Design tokens | ~120 in 4 files |
| Tokenized widgets | 22 in `eatery_core/lib/widgets/` |
| Legacy components | 1 remaining (`CustomTextFromField` — used by bottom sheets) |
| Legacy form fields | 0 in page files (Body1 in `create_company` only — dead code) |
| RBAC roles | 4 (admin, waiter, kds, display) |
| Repositories | 8 (all SQLite via Zig FFI) |
| ADRs | 6 formal decision records |

## Related

- [Migration Patterns](migration-patterns.md) — strangler fig methodology and active migration status
- [ADR-001: Riverpod over Provider](../decisions/001-riverpod-over-provider.md)
- [ADR-002: SQLite over Hive](../decisions/002-sqlite-over-hive.md)
- [ADR-003: Zig for Native Code](../decisions/003-zig-for-native.md)
- [ADR-004: Zero Raw Visual Values](../decisions/004-zero-raw-visual-values.md)
- [ADR-005: Variant × Semantic × Size](../decisions/005-variant-semantic-size.md)
- [ADR-006: Domain Molecule Cohesion](../decisions/006-domain-molecule-cohesion.md)

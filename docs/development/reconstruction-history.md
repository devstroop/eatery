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

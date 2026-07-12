# Architecture Overview

> Eatery uses a **pragmatic "lite" Clean Architecture** — layers exist but without the boilerplate of full Clean Architecture (no separate domain entities, no mappers, no CRUD use-cases).

---

## Layer Diagram

```
┌─────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                     │
│                                                         │
│  pages/ ─── providers/ ─── core/widgets/                │
│  (screens)   (Riverpod)     (components)                │
│                                                         │
│  Pages read providers. Pages render widgets.             │
│  Pages call repositories through provider refs.          │
├─────────────────────────────────────────────────────────┤
│                      DATA LAYER                          │
│                                                         │
│  repositories/ ─── database/ ─── models/                │
│  (typed CRUD)     (Hive boxes)   (@HiveType entities)   │
│                                                         │
│  Repositories wrap Hive box operations.                  │
│  EateryDatabase holds all 24 box references.             │
├─────────────────────────────────────────────────────────┤
│                     DOMAIN LAYER                         │
│                                                         │
│  usecases/    (order/tax calculations — WIP)            │
│                                                         │
│  Only exists where business logic is non-trivial.        │
│  CRUD passthroughs live in repositories.                 │
└─────────────────────────────────────────────────────────┘
```

---

## App Startup Flow

```
main()
  │
  ├─ runZonedGuarded()                                    [global error capture]
  ├─ Permission checks (mobile only)                      [Platform.isAndroid || Platform.isIOS]
  ├─ setupDataAndInitDB()
  │   ├─ AppFileSystem.init(basePath)                     [creates 7 directories]
  │   ├─ EateryDatabase(dataDir).init()                    [opens 24 Hive boxes]
  │   ├─ EateryDB.bind(database)                           [binds legacy shim]
  │   └─ FastCachedImageConfig.init()                      [image cache]
  ├─ ProviderScope(overrides: [appDatabaseProvider])       [Riverpod DI]
  │   └─ MyApp()
  │       └─ MaterialApp(theme: AppTheme.light)
  │           └─ Scaffold
  │               ├─ appDatabase.hasCompany → LoginPage()
  │               └─ !hasCompany → MainScreen()           [onboarding]
  │
  └─ App startup complete
```

**Entry point:** `lib/main.dart` ([view](../../lib/main.dart))

---

## Migration State (Old → New)

| Aspect | Old (Legacy) | New (Current) |
|--------|-------------|---------------|
| **State** | `Common` static class · `setState` | Riverpod `NotifierProvider` |
| **DB access** | `EateryDB.instance.*Box!.values` | `Repository` → `EateryDatabase` |
| **Models** | `eatery_db` package (separate) | `data/models/` (in-app) |
| **Widgets** | `widgets/`, `components/` (mobile-only) | `core/widgets/` (responsive-first) |
| **Colors** | `KColors` (mutable, in `constants/`) | `AppColors` (immutable, in `core/theme/`) |
| **Spacing** | `SpacingStyle` (in `constants/`) | `AppSpacing` (4px scale, in `core/theme/`) |
| **Typography** | Raw `TextStyle(fontSize: ...)` throughout | `AppTypography` presets |
| **Routing** | Raw `Navigator.push` throughout | GoRouter defined, not fully adopted |
| **Forms** | `LabeledCustomTextFormField` | `AppTextField` |
| **Buttons** | `PrimaryButton`, `SecondaryButton` | `AppButton.primary/secondary/destructive/ghost` |
| **Cards/Lists** | `MenuTile`, raw ListTile | `AppCard`, `AppTableView` |
| **Dialogs** | `showDialog`/`showModalBottomSheet` | `AppDialog.show()` / `AppDialog.showAdaptive()` |
| **Navigation** | `Scaffold` per-page | `AppPageShell` (standard wrapper) / `AppAdaptiveShell` (tab nav) |
| **Images** | `Image.file(file).image` (full res) | `ResizeImage.resizeIfNeeded(200, 200, ...)` |
| **Printing** | `flutter_bluetooth_basic` (mobile) | `PrinterRepository` + desktop network support |
| **Filesystem** | `Common.tempDirectory!` (nullable) | `AppFileSystem` (singleton, sync getters) |
| **Device ID** | `platform_device_id` (git, no macOS) | `device_info_plus` (cross-platform) |

---

## Key Files

| File | Purpose |
|------|---------|
| [main.dart](../../lib/main.dart) | Entry point, DB init, ProviderScope |
| [AppTheme](../../lib/core/theme/app_theme.dart) | ThemeData builder |
| [AppColors](../../lib/core/theme/app_colors.dart) | All color tokens |
| [AppTypography](../../lib/core/theme/app_typography.dart) | All text styles |
| [AppSpacing](../../lib/core/theme/app_spacing.dart) | Spacing scale |
| [Responsive](../../lib/core/utils/responsive.dart) | Breakpoints & layout utilities |
| [EateryDatabase](../../lib/data/database/eatery_database.dart) | Injectable DB wrapper |
| [EateryDB shim](../../lib/data/database/eatery_db_shim.dart) | Legacy → new bridge |
| [appDatabaseProvider](../../lib/presentation/providers/database_provider.dart) | Riverpod DB provider |
| [AppFileSystem](../../lib/constants/utils/app_file_system.dart) | Directory management |
| [references.dart](../../lib/references.dart) | Legacy barrel — being phased out |

---

## Related Specs

- [Data Layer](data-layer.md) — Hive models, database, repositories
- [Component Library](components.md) — Every widget documented
- [Page Directory](pages.md) — All screens and their data dependencies
- [State Management](state-management.md) — Riverpod providers
- [Responsive Design](responsive-design.md) — Breakpoints, adaptive layouts
- [Design Tokens](design-tokens.md) — Colors, typography, spacing
- [Reconstruction History](reconstruction.md) — How we got here

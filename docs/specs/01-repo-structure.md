# Specs 01 — Repository Structure

## 1. Directory Layout

```
eatery/
├── apps/
│   ├── eatery_admin/                 # Admin app (current codebase → migrated)
│   │   ├── lib/
│   │   │   ├── main.dart             # App entry, ProviderScope overrides
│   │   │   ├── eatery_admin.dart     # Barrel
│   │   │   └── pages/               # Admin-only UI pages
│   │   │       ├── authentication/
│   │   │       ├── dashboard/
│   │   │       ├── activation/
│   │   │       ├── backup_restore/
│   │   │       └── create_company/
│   │   └── pubspec.yaml              # path: packages/eatery_core
│   ├── eatery_waiter/                # Waiter app (Phase 4)
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   └── pages/
│   │   │       ├── login/
│   │   │       ├── tables/
│   │   │       ├── pos/
│   │   │       └── orders/
│   │   └── pubspec.yaml
│   ├── eatery_kds/                   # Kitchen Display (Phase 5)
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   └── pages/
│   │   │       └── kds/
│   │   └── pubspec.yaml
│   └── eatery_display/               # Customer Display (Phase 6)
│       ├── lib/
│       │   ├── main.dart
│       │   └── pages/
│       │       └── display/
│       └── pubspec.yaml
├── packages/
│   ├── eatery_core/                  # Shared code package
│   │   ├── lib/
│   │   │   ├── eatery_core.dart      # Barrel export
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── order/
│   │   │   │   │   ├── product/
│   │   │   │   │   ├── dining_table/
│   │   │   │   │   ├── staff/
│   │   │   │   │   ├── customer/
│   │   │   │   │   ├── payment/
│   │   │   │   │   ├── company/
│   │   │   │   │   ├── tax/
│   │   │   │   │   ├── printer/
│   │   │   │   │   ├── compliance/
│   │   │   │   │   ├── config/
│   │   │   │   │   ├── subscription/
│   │   │   │   │   └── kds/
│   │   │   │   ├── database/
│   │   │   │   │   └── native/       # EateryStore, schema, config
│   │   │   │   ├── repositories/     # Interfaces + SQLite impls
│   │   │   │   ├── dtos/             # Sync DTOs + mappers
│   │   │   │   └── sync/             # OpLog, SyncService, SyncMessage
│   │   │   ├── core/
│   │   │   │   ├── theme/            # AppColors, AppTheme, AppTypography, AppSpacing
│   │   │   │   ├── widgets/          # AppButton, AppCard, AppDialog, AppTextField, etc.
│   │   │   │   ├── router/           # Route definitions, guards (base)
│   │   │   │   ├── extensions/       # double_ext, string_ext
│   │   │   │   └── utils/            # DeviceId, Responsive
│   │   │   ├── functions/
│   │   │   │   └── order.function.dart
│   │   │   ├── presentation/
│   │   │   │   └── providers/        # All Riverpod providers
│   │   │   └── services/             # Printing, cloud, utility
│   │   ├── assets/
│   │   │   └── db/
│   │   │       └── schema.sql
│   │   └── pubspec.yaml
│   └── eatery_sync/                  # Optional: separate sync package
├── libeaterystore/                   # Native SQLite library (Zig) — unchanged
├── docs/
│   ├── README.md
│   ├── prd/
│   ├── specs/
│   └── audit/
└── pubspec.yaml                      # Root workspace
```

## 2. Dependency Graph

```
eatery_admin ──┐
eatery_waiter ──┤── eatery_core ── libeaterystore (FFI)
eatery_kds   ──┘
eatery_display ──┘
```

## 3. Package Configuration

### Root `pubspec.yaml` (workspace)
```yaml
name: eatery
publish_to: none

environment:
  sdk: '>=3.8.0 <4.0.0'

workspace:
  - apps/eatery_admin
  - apps/eatery_waiter
  - packages/eatery_core
```

### `packages/eatery_core/pubspec.yaml`
```yaml
name: eatery_core
version: 0.1.0
publish_to: none

environment:
  sdk: '>=3.8.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  go_router: ^17.3.0
  riverpod_annotation: ^2.6.1
  rxdart: ^0.28.0
  intl: ^0.19.0
  device_info_plus: ^12.4.0
  path: ^1.9.0

dev_dependencies:
  build_runner: ^2.4.13
  riverpod_generator: ^2.4.0
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
```

### `apps/eatery_admin/pubspec.yaml`
```yaml
name: eatery_admin
publish_to: none

dependencies:
  flutter:
    sdk: flutter
  eatery_core:
    path: ../../packages/eatery_core
  # Existing deps: http, encrypt, shared_preferences, etc.
```

## 4. Import Pattern

After extraction, all imports follow:

```dart
// Shared code (in any app):
import 'package:eatery_core/data/models/order.dart';
import 'package:eatery_core/data/repositories/order_repository.dart';
import 'package:eatery_core/core/widgets/app_button.dart';
import 'package:eatery_core/presentation/providers/cart_provider.dart';

// Admin-only pages (in apps/eatery_admin):
import 'package:eatery_admin/pages/dashboard/dashboard.page.dart';
```

## 5. Theme & Widget Ownership

| Component | Location | Notes |
|-----------|----------|-------|
| AppColors, AppTheme, AppTypography, AppSpacing | `eatery_core/core/theme/` | Shared, brand colors |
| AppButton, AppCard, AppDialog, AppTextField | `eatery_core/core/widgets/` | Shared, used by all apps |
| Page shell (AppPageShell) | `eatery_core/core/widgets/` | Shared, base wrapper |
| Page-specific widgets | Each app's `lib/pages/` | Not shared |
| Dashboard header, menu tiles | `eatery_admin/pages/dashboard/` | Admin-only |
| Table floor plan widget | `eatery_core/core/widgets/` | Shared (used by Waiter + Admin) |

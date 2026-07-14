# Repository Structure

## Directory Layout

```
eatery/
��── apps/
│   ├── eatery_admin/              # Admin app (currently at root lib/, will migrate here)
│   ├── eatery_waiter/             # Waiter app (in progress)
��   ├── eatery_kds/                # Kitchen Display System (in progress)
│   └── eatery_display/            # Customer Display (in progress)
��── packages/
│   ��── eatery_core/               # Shared code package
��       └── lib/
│           ├── data/
│           │   ├── models/        # All domain models (freezed)
│           │   ├── database/      # EateryDatabase, native/ (EateryStore, schema, migrator)
│           │   ├── repositories/  # Interfaces + SQLite implementations
│           │   └── sync/          # OpLog, SyncService, SyncCoordinator
│           ├─��� theme/             # AppColors, AppTheme, AppTypography, AppSpacing, AppShadows
│           ├── widgets/           # AppButton, AppCard, AppDialog, etc.
│           ├── providers/         # All Riverpod providers
│           ├── utils/             # Responsive, DeviceId
│           └── services/          # OrderService, ReportService
├── libeaterystore/                # Native SQLite library (Zig FFI)
├��─ lib/                           # Admin app (root, planned migration to apps/eatery_admin/)
│   ├── main.dart                  # Entry point, ProviderScope
│   ├── core/
│   │   └── router/app_router.dart # GoRouter setup
│   ├── pages/                     # All screens
│   ├── dev/                       # Seed data, inspector
│   └── widgets/                   # Legacy widgets (being migrated)
├── assets/db/schema.sql           # SQLite schema
├── test/                          # 7 tests (legacy)
├── docs/
│   ├��─ architecture/              # This directory
│   └── specs/                     # Being deleted
├── specs/                         # Being deleted
└── pubspec.yaml                   # Root workspace
```

## Dependency Graph

```
eatery_admin ──┐
eatery_waiter ──┤── eatery_core ── libeaterystore (FFI)
eatery_kds   ──┘
eatery_display ──��
```

## Package Configuration

Root `pubspec.yaml` (workspace):
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

`packages/eatery_core/pubspec.yaml` key dependencies:
- `flutter_riverpod: ^2.6.1` — state management
- `go_router: ^17.3.0` — routing
- `riverpod_annotation: ^2.6.1` — code generation
- `rxdart: ^0.28.0` — reactive streams
- `intl: ^0.19.0` — formatting
- `device_info_plus: ^12.4.0` — cross-platform device ID
- `freezed_annotation` — immutable models
- `json_annotation` — JSON serialization
- `web_socket_channel` — sync WebSocket transport

`apps/eatery_admin/pubspec.yaml` (when migrated):
- `eatery_core: path: ../../packages/eatery_core`
- Existing deps: `http`, `encrypt`, `shared_preferences`, `permission_handler`, `image_picker`, etc.

## Import Pattern

```dart
// Shared code (in any app):
import 'package:eatery_core/data/models/order.dart';
import 'package:eatery_core/data/repositories/order_repository.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/widgets/app_button.dart';
import 'package:eatery_core/providers/cart_provider.dart';

// Admin-only pages (currently root lib/):
import 'package:eatery/pages/dashboard/dashboard.page.dart';
```

## Migration Note

The Admin app currently lives at the repo root (`lib/`, `main.dart`) for historical reasons. The long-term plan is to move it into `apps/eatery_admin/`. The companion apps (`apps/eatery_waiter/`, `apps/eatery_kds/`, `apps/eatery_display/`) exist as scaffolding and are under active development.

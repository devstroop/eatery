# Repository Structure

## Directory Layout

> **Status:** The single-app architecture migration is complete (Phase 1). The `apps/` directory has been deleted. Role-specific pages live in `lib/pages/{waiter,kds,display}/`. See [Reconstruction History](../development/reconstruction-history.md) for the full migration timeline.

```
eatery/
├── lib/                           # Unified app entry & pages
│   ├── main.dart                  # Single entry point, role-aware init
│   ├── core/
│   │   └── router/app_router.dart # Unified GoRouter with RBAC guard
│   ├── pages/
│   │   ├── authentication/        # Login, reset PIN, logout
│   │   ├── activation/            # Upgrade page
│   │   ├── create_company/        # Company setup
│   │   ├── dashboard/             # Admin dashboard & all admin pages
│   │   │   ├── customer/
│   │   │   ├── data/
│   │   │   ├── dining_table/
│   │   │   ├── help/
│   │   │   ├── inventory/
│   │   │   ├── order/
│   │   │   ├── payment/
│   │   │   ├── pos/
│   │   │   ├── product/
│   │   │   ├── reports/
│   │   │   ├── reservations/
│   │   │   ├── settings/
│   │   │   ├── staff/
│   │   │   └── utility/
│   │   ├── waiter/                # Waiter pages (from apps/eatery_waiter)
│   │   ├── kds/                   # KDS pages (from apps/eatery_kds)
│   │   ├── display/               # Display pages (from apps/eatery_display)
│   │   ├── role_picker.page.dart  # First-launch role selector
│   │   ├── setup/                 # Setup wizard
│   │   └── main.screen.dart       # Onboarding screen
│   ├── components/                # Admin UI components
│   ├── constants/                 # Common, styles, validators, utils
│   ├── extensions/                # Dart extension methods
│   ├── functions/                 # Business logic (OrderFunction)
│   ├── services/                  # Cloud, printing, utility services
│   ├── support/                   # Bluetooth thermal printer adapter
│   ├── widgets/                   # Legacy admin widgets
│   └── references.dart            # Barrel export file
├── packages/
│   └── eatery_core/               # Shared code package (unchanged)
│       └── lib/
│           ├── data/
│           │   ├── models/        # All domain models (freezed)
│           │   ├── database/      # EateryDatabase, native/ (EateryStore, schema, migrator)
│           │   ├── repositories/  # Interfaces + SQLite implementations
│           │   └── sync/          # OpLog, SyncService, SyncCoordinator
│           ├── theme/             # AppColors, AppTheme, AppTypography, AppSpacing, AppShadows
│           ├── widgets/           # AppButton, AppCard, AppDialog, etc.
│           ├── providers/         # All Riverpod providers
│           ├── utils/             # Responsive, DeviceId
│           └── services/          # OrderService, ReportService
├── libeaterystore/                # Native SQLite library (Zig FFI)
├── assets/
│   ├── db/schema.sql              # SQLite schema
│   ├── lottie/                    # Lottie animations
│   ├── images/                    # PNG/JPG images
│   ├── icons/                     # App icons
│   └── vectors/                   # SVG vectors
├── test/                          # Test suite
├── docs/
│   ├── architecture/              # Architecture docs (00-13)
│   ├── guides/                    # Developer guides
│   ├── product/                   # Product requirements
│   ├── plan/                      # Roadmaps, audits
│   └── decisions/                 # Architecture Decision Records
├── ISSUES.md                      # Migration issue tracker
└── pubspec.yaml                   # Single package (no workspace)
```

## Dependency Graph

```
eatery (single binary) ── eatery_core ── libeaterystore (FFI)
```

The single Flutter app depends on `packages/eatery_core` as a `path:` dependency. `eatery_core` loads the native `libeaterystore` via `dart:ffi`.

## Package Configuration

Root `pubspec.yaml`:
```yaml
name: eatery
publish_to: none
environment:
  sdk: '>=3.11.3 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
  eatery_core:
    path: packages/eatery_core
  # ... all shared deps
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  melos: ^8.2.2
melos:
  scripts:
    analyze:
      run: flutter analyze --no-fatal-infos --no-fatal-warnings lib/
    test:
      run: flutter test
    format:
      run: dart format .
    get:
      run: flutter pub get
    build:admin:
      run: flutter build macos --debug
```

`packages/eatery_core/pubspec.yaml` key dependencies (unchanged):
- `flutter_riverpod: ^2.6.1` — state management
- `go_router: ^17.3.0` — routing
- `riverpod_annotation: ^2.6.1` — code generation
- `rxdart: ^0.28.0` — reactive streams
- `intl: ^0.19.0` — formatting
- `device_info_plus: ^12.4.0` — cross-platform device ID
- `freezed_annotation` — immutable models
- `json_annotation` — JSON serialization
- `web_socket_channel` — sync WebSocket transport
- `multicast_dns: ^0.3.2` — mDNS device discovery

## Import Pattern

```dart
// Shared core (unchanged):
import 'package:eatery_core/data/models/order.dart';
import 'package:eatery_core/data/repositories/order_repository.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/widgets/app_button.dart';
import 'package:eatery_core/providers/cart_provider.dart';

// Role pages (previously sub-app packages, now unified):
import 'package:eatery/pages/waiter/table_page.dart';
import 'package:eatery/pages/kds/ticket_page.dart';
import 'package:eatery/pages/display/display_page.dart';

// Admin pages (unchanged):
import 'package:eatery/pages/dashboard/dashboard.page.dart';
```

## Migration Note

The four previously-separate sub-apps (`apps/eatery_waiter/`, `apps/eatery_kds/`, `apps/eatery_display/`) were merged into the root `lib/` directory as `lib/pages/{waiter,kds,display}/`. The `apps/` directory has been deleted. See [Single-App Architecture](single-app-architecture.md) for the RBAC routing design.

<p align="center">
  <img src="./assets/logo.svg" width="40%" height="20%">
</p>

<h1 align="center">Eatery — Restaurant Operating System</h1>

<p align="center">
  <strong>Offline-first restaurant POS & management system — single binary with role dispatch.</strong>
  Free & open-source alternative to Toast, Square for Restaurants, and Lightspeed.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.41-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.8-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-lightgrey" alt="Platforms">
  <img src="https://img.shields.io/badge/state-Riverpod-purple" alt="Riverpod">
  <img src="https://img.shields.io/badge/db-SQLite-brightgreen" alt="Database">
  <img src="https://img.shields.io/badge/PRs-Automated-blue?logo=github-actions" alt="PR-Agent">
</p>

---

## Overview

Eatery is a **single Flutter binary** that presents four role-specific UIs from one codebase. The device's role is selected on first launch (or via `--dart-define=role` for dev) and persisted in SQLite:

| Role | Login | Purpose | Users |
|------|-------|---------|-------|
| **Admin** | PIN (StaffType.admin) | Full POS, management, config, reports | Owner, manager |
| **Waiter** | PIN (StaffType.waiter) | Order taking, table management | Waitstaff |
| **KDS** | None (kiosk) | Real-time order feed, KOT display | Chefs |
| **Display** | None (kiosk) | Customer-facing order status | Customers |

**Key differentiators:**
- Full offline resilience — POS works without internet
- Local-network sync via OpLog over WebSockets (no cloud dependency)
- Role-based access control — each role sees only its permitted routes
- Cross-platform: Android, iOS, macOS, Windows, Linux
- Zero monthly fees — free open core

---

## Tech Stack

| Category | Choice |
|----------|--------|
| **Language** | Dart 3.11+ / Flutter 3.41+ |
| **State Management** | Riverpod (NotifierProvider / AsyncNotifierProvider) |
| **Navigation** | GoRouter 17.x (~76 routes, RBAC guard) |
| **Database** | SQLite via native Zig FFI (`libeaterystore`) |
| **Native Store** | Zig 0.15+ / `libeaterystore` (embedded SQLite via `dart:ffi`) |
| **Sync** | WebSocket + OpLog (operation log) + mDNS discovery |
| **Code Gen** | freezed, json_serializable, riverpod_generator, build_runner |

---

## Getting Started

```bash
# Prerequisites: Flutter 3.41+, Zig 0.15+
flutter pub get
cd libeaterystore && ./scripts/build.sh && cd ..
dart run build_runner build --delete-conflicting-outputs
flutter analyze --no-fatal-infos --no-fatal-warnings lib/
flutter test
flutter test packages/eatery_core/test/
```

See [docs/guides/getting-started.md](docs/guides/getting-started.md) for full setup instructions.

---

## Project Structure

```
eatery/
├── lib/                     # Unified app entry & all role pages
│   ├── main.dart            # Single entry point, role-aware init
│   ├── core/router/         # Unified GoRouter + RBAC guard
│   └── pages/
│       ├── authentication/  # Login, reset PIN
│       ├── dashboard/       # Admin POS & management
│       ├── waiter/          # Table view, menu, cart
│       ├── kds/             # Kitchen ticket grid
│       ├── display/         # Customer order status
│       └── role_picker.page.dart  # First-launch role selector
├─── packages/
│   └── eatery_core/         # Shared models, DB, sync, widgets, theme
├── libeaterystore/          # Native Zig/SQLite library
├── docs/                    # Documentation
│   ├── architecture/        # ADRs, specs, data models, sync protocol
│   ├── guides/              # Getting started, architecture overview
│   ├── product/             # Product requirements
│   ├── plan/                # Roadmaps, audits
│   └── decisions/           # Architecture Decision Records
├── assets/                  # Images, Lottie, icons, SQLite schema
```

---

## Documentation

| Link | Audience |
|------|----------|
| [Getting Started](docs/guides/getting-started.md) | New contributors |
| [Architecture Overview](docs/guides/architecture-overview.md) | Developers starting out |
| [Architecture Index](docs/architecture/index.md) | Design tokens, component library, ADRs, specs |
| [Reconstruction History](docs/development/reconstruction-history.md) | Full Phase 1-7 evolution timeline |
| [Product Requirements](docs/product/index.md) | PRDs, personas, feature roadmap |
| [Development Guide](docs/development/setup.md) | Build, CI, testing |

---

## License

Open-source (license TBD).

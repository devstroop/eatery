<p align="center">
  <img src="./assets/logo.svg" width="40%" height="20%">
</p>

<h1 align="center">Eatery — Restaurant Operating System</h1>

<p align="center">
  <strong>Offline-first, multi-app restaurant POS & management system.</strong>
  Free & open-source alternative to Toast, Square for Restaurants, and Lightspeed.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.41-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.8-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-lightgrey" alt="Platforms">
  <img src="https://img.shields.io/badge/state-Riverpod-purple" alt="Riverpod">
  <img src="https://img.shields.io/badge/db-SQLite-brightgreen" alt="Database">
</p>

---

## Overview

Eatery is a family of four applications forming a complete restaurant management system:

| App | Purpose | Users |
|-----|---------|-------|
| **Admin** | Full management, POS, config, reports | Owner, manager |
| **Waiter** | Order taking, table management | Waitstaff |
| **Kitchen (KDS)** | Real-time order feed, KOT display | Chefs |
| **Display** | Customer-facing order status | Customers |

**Key differentiators:**
- Full offline resilience — POS works without internet
- Local-network sync via OpLog over WebSockets (no cloud dependency)
- Cross-platform: Android, iOS, macOS, Windows, Linux
- Zero monthly fees — free open core

---

## Tech Stack

| Category | Choice |
|----------|--------|
| **Language** | Dart 3.11+ / Flutter 3.41+ |
| **State Management** | Riverpod (NotifierProvider / AsyncNotifierProvider) |
| **Navigation** | GoRouter 17.x (migrating) |
| **Database** | SQLite via native Zig FFI (`libeaterystore`) |
| **Native Store** | Zig 0.15+ / `libeaterystore` (embedded SQLite via `dart:ffi`) |
| **Sync** | WebSocket + OpLog (operation log) + mDNS discovery |
| **Code Gen** | freezed, json_serializable, riverpod_generator, build_runner |
| **Architecture** | Pragmatic "lite" Clean Architecture (repositories + providers) |
| **Monorepo** | Melos 8.x workspace |

---

## Getting Started

```bash
# Prerequisites: Flutter 3.41+, Zig 0.15+, Melos
melos bootstrap
melos run generate
melos run analyze
melos run test
```

See [docs/guides/getting-started.md](docs/guides/getting-started.md) for full setup instructions.

---

## Project Structure

```
eatery/
��── apps/                    # Companion apps (waiter, kds, display)
├── packages/
│   └── eatery_core/         # Shared core: models, DB, sync, widgets, providers
├── lib/                     # Admin app entry & pages (migrating into apps/eatery_admin)
├── libeaterystore/          # Native Zig/SQLite library
├── docs/                    # Documentation
│   ├── guides/              # Developer guides & architecture overview
│   ├── product/             # Product requirements
│   ├── architecture/        # Technical specs
│   ├── development/         # Dev procedures
│   ├── plan/                # Roadmaps, audits, plans
│   ���── decisions/           # Architecture Decision Records
└── specs/                   # (deprecated — content moved to docs/)
```

---

## Documentation

| Link | Audience |
|------|----------|
| [Architecture Overview](docs/guides/architecture-overview.md) | Developers starting out |
| [Getting Started](docs/guides/getting-started.md) | New contributors |
| [Product Requirements](docs/product/index.md) | Product / stakeholders |
| [Technical Specs](docs/architecture/index.md) | Engineering team |
| [Development Guide](docs/development/setup.md) | Contributors |
| [Issue Inventory](docs/plan/issue-inventory.md) | Project management |

---

## License

Open-source (license TBD).

# Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Eatery (Flutter)                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐ │
│  │  Admin   │  │  Waiter  │  │   KDS    │  │ Display │ │
│  │  (full)  │  │ (orders) │  │(kitchen) │  │(public) │ │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬────┘ │
│       └──────────────┴─────────────┴──────────────┘      │
│                          │                                │
│              ┌───────────┴───────────┐                    │
│              │    eatery_core        │                    │
│              │  (shared package)     │                    │
│              │  models • repos • UI  │                    │
│              └───────────┬───────────┘                    │
│                          │                                │
│              ┌───────────┴───────────┐                    │
│              │   libeaterystore      │                    │
│              │   (Zig FFI → SQLite)  │                    │
│              └───────────────────────┘                    │
└─────────────────────────────────────────────────────────┘
```

## Four Roles, One Binary

A single Flutter binary dispatches to 4 UIs based on persisted `device_role`:

| Role | Auth | UI | Users |
|------|------|----|-------|
| **Admin** | PIN | Dashboard, POS, management, reports | Owner/manager |
| **Waiter** | PIN | Table grid, menu, cart, orders | Waitstaff |
| **KDS** | None | Live ticket queue, KOT display | Chefs |
| **Display** | None | Order status board, auto-scroll | Diners (public TV) |

## Dependency Graph

```
eatery (single binary)
  └── eatery_core (shared package)
        ├── data/models/     (40+ freezed models)
        ├── data/database/   (SQLite via Zig FFI)
        ├── data/repos/      (data access layer)
        ├── data/sync/       (WebSocket OpLog protocol)
        ├── theme/           (design tokens)
        ├── widgets/         (component library)
        ├── providers/       (Riverpod providers)
        └── utils/           (responsive, helpers)
```

## Key Architecture Decisions

| Decision | Rationale |
|----------|-----------|
| **Single binary** | One codebase, zero duplication, role dispatch at startup |
| **Offline-first SQLite** | No cloud dependency, works without internet |
| **Riverpod** | Compile-safe DI, no BuildContext for providers |
| **freezed models** | Immutable, copyWith, JSON serialization |
| **Zig FFI for DB** | Native SQLite access, no platform channel overhead |
| **WebSocket sync** | Local network device-to-device, no cloud required |
| **GoRouter + RBAC** | Role-based redirects, typed extras, deep linking |

## Request Flow

```
Page (ConsumerWidget)
  → ref.watch(provider)
    → Provider (Riverpod)
      → Repository (data access)
        → EateryDatabase / EateryStore (SQLite FFI)
```

## Repository Structure (simplified)

```
eatery/
├── lib/                         # App entry, pages, router
│   ├── main.dart                # Single entry point
│   ├── core/router/             # GoRouter + RBAC
│   └── pages/                   # All pages by role
│       ├── authentication/      # Login, reset PIN
│       ├── dashboard/           # Admin (POS, orders, products...)
│       ├── waiter/              # Waiter (tables, menu, cart)
│       ├── kds/                 # Kitchen display
│       └── display/             # Customer display
├── packages/eatery_core/        # Shared code (models, repos, UI)
├── libeaterystore/              # Native SQLite (Zig)
├── assets/                      # Images, icons, Lottie, sounds
├── test/                        # Unit + widget tests
└── docs/                        # Documentation
```

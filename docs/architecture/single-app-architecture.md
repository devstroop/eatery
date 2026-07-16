# Single-App Architecture

> **Status:** Complete (Phase 1). All 28 issues resolved. The `apps/` directory is deleted. Single binary dispatches UI by device role at runtime. See [Reconstruction History](../development/reconstruction-history.md) for the full migration timeline.

## Overview

Eatery is moving from 4 separate Flutter binaries (Admin, Waiter, KDS, Display) to a **single unified binary** that dispatches UI by device role at runtime. One app, installed on every device in the restaurant, behaves differently based on whether it's configured as the admin terminal, a waiter tablet, a kitchen display, or a customer-facing screen.

## Architecture Comparison

### Current: 4 Separate Apps (Melos Workspace)

```mermaid
flowchart TB
    subgraph BEFORE["Current: 4 Separate Apps (Melos Workspace)"]
        subgraph ADMIN["eatery (root lib/)"]
            AM["main.dart"]
            AR["GoRouter (45 routes)"]
            AL["LoginPage → Dashboard → POS/Orders/Settings"]
            AS["SyncServer (host)"]
        end
        subgraph WAITER["apps/eatery_waiter/"]
            WM["main.dart"]
            WR["GoRouter (3 routes)"]
            WL["TablePage → MenuPage → CartPage"]
            WS["SyncClient (leaf)"]
        end
        subgraph KDS["apps/eatery_kds/"]
            KM["main.dart"]
            KR["GoRouter (1 route)"]
            KL["TicketPage"]
            KS["SyncClient (leaf)"]
        end
        subgraph DISPLAY["apps/eatery_display/"]
            DM["main.dart"]
            DR["GoRouter (1 route)"]
            DL["DisplayPage"]
            DS["SyncClient (leaf)"]
        end
    end
    CORE["packages/eatery_core/<br/>(models, DB, sync, widgets, theme)"]
    NATIVE["libeaterystore (Zig FFI)"]
    CORE --> ADMIN
    CORE --> WAITER
    CORE --> KDS
    CORE --> DISPLAY
    NATIVE --> CORE
```

### Target: Single Binary with Role Dispatch

```mermaid
flowchart TB
    subgraph AFTER["Target: Single Binary with Role Dispatch"]
        MAIN["Unified main.dart<br/>(one EateryStore, one SchemaMigrator)"]
        PICKER["RolePicker<br/>(first launch)"]
        subgraph SHELL["RoleShell"]
            ROUTER["Unified GoRouter (~50 routes)<br/>RBAC guard per role"]
        end
        MAIN --> PICKER
        PICKER -->|"I'm Staff"| LOGIN["LoginPage<br/>(PIN auth, any StaffType)"]
        PICKER -->|"Kitchen Display"| KDS_UI["TicketPage<br/>(no auth)"]
        PICKER -->|"Customer Display"| DISP_UI["DisplayPage<br/>(no auth)"]
        LOGIN -->|"StaffType.admin"| ADMIN_UI["Dashboard → POS → Orders → Settings<br/>(45+ routes, wildcard RBAC)"]
        LOGIN -->|"StaffType.waiter"| WAITER_UI["Tables → Menu → Cart<br/>(9 routes)"]
        LOGIN -->|"StaffType.chef"| KDS_UI2["TicketPage<br/>(3 routes)"]
        KDS_UI --> ROUTER
        DISP_UI --> ROUTER
        ADMIN_UI --> ROUTER
        WAITER_UI --> ROUTER
        KDS_UI2 --> ROUTER
        ROUTER --> SYNC{"role == admin?"}
        SYNC -->|"yes"| HOST["SyncServer (host, :9876)"]
        SYNC -->|"no"| LEAF["SyncClient (leaf, mDNS → host)"]
    end
    CORE2["packages/eatery_core/<br/>(unchanged)"]
    NATIVE2["libeaterystore (unchanged)"]
    MAIN --> CORE2
    CORE2 --> NATIVE2
```

## Role-Based Dispatch Flow

```mermaid
sequenceDiagram
    actor User
    participant App as Unified App
    participant DB as SQLite app_config
    participant Router as GoRouter with RBAC
    participant UI as Role UI

    Note over App: App cold start

    User->>App: Open app
    App->>DB: SELECT device_role
    DB-->>App: null (first launch)

    App->>User: Show RolePicker
    Note over User,App: 3 cards - Staff, KDS, Display

    alt User picks Staff
        User->>App: Tap "I'm Staff"
        App->>DB: INSERT device_role = admin
        App->>Router: Navigate to /login
        User->>App: Enter phone + PIN
        App->>DB: authenticateStaff(phone, pin)
        DB-->>App: Staff type=admin
        Router->>Router: RBAC check: role=admin, route=/dashboard
        Note over Router: admin = wildcard ALLOW
        App->>UI: Show Dashboard (45 routes)
    else User picks Kitchen Display
        User->>App: Tap "Kitchen Display"
        App->>DB: INSERT device_role = kds
        App->>Router: Navigate to /kds
        Note over Router: kds role, no auth, allow
        App->>UI: Show TicketPage (no login)
    else User picks Customer Display
        User->>App: Tap "Customer Display"
        App->>DB: INSERT device_role = display
        App->>Router: Navigate to /display
        Note over Router: display role, no auth, allow
        App->>UI: Show DisplayPage (no login)
    end

    Note over Router: On every route change...
    Router->>Router: Check role + auth + route vs permissions
    Router-->>UI: Allow or redirect with Access denied toast
```

## Key Architectural Shifts

| Aspect | Before | After |
|--------|--------|-------|
| **Apps** | 4 separate binaries | 1 binary, 4 UIs via role dispatch |
| **Entry points** | 4 `main.dart` files | 1 `main.dart` |
| **Routers** | 4 separate `GoRouter` instances | 1 unified `GoRouter` (~50 routes) |
| **Auth** | Admin only (PIN). Waiter/KDS/Display have zero auth | Admin + waiter/chef get PIN login. Display/KDS kiosk modes bypass auth |
| **Sync role** | Hardcoded per app (`kHostDeviceId = 'eatery-admin'`) | Derived from `device_role` in `app_config` — admin=host, others=leaf |
| **Code location** | `apps/eatery_waiter/lib/`, etc. | `lib/pages/waiter/`, `lib/pages/kds/`, `lib/pages/display/` |
| **Build** | `melos exec` across 4 packages | Single `flutter build` |
| **Melos** | Workspace manager for all packages | Dev script runner only (no workspace wiring) |
| **Role persistence** | N/A (hardcoded per app) | `device_role` key in SQLite `app_config` table |
| **First launch** | Each app starts directly into its UI | RolePicker screen on first launch |

## What Doesn't Change

- `packages/eatery_core/` — all shared code (models, DB, sync, widgets, theme) unchanged
- `libeaterystore/` — Zig FFI native library unchanged
- SQLite schema — identical, shared by all roles
- Sync protocol — WebSocket + OpLog + mDNS unchanged
- Theme system — `AppTheme`, `AppColors`, etc. unchanged
- Repository layer — all SQLite-backed repositories unchanged
- All existing admin pages — 45+ routes preserved exactly

## Permission Matrix

| Role | Auth Required | Allowed Routes |
|------|---------------|----------------|
| `admin` | PIN login | `*` (wildcard — all routes) |
| `waiter` | PIN login | `tables`, `menu`, `cart`, `orders`, `viewOrder`, `orderConfirmation`, `orderPrint`, `customers`, `viewCustomer` |
| `kds` | None (kiosk) | `kds`, `viewOrder`, `orderConfirmation` |
| `display` | None (kiosk) | `display`, `viewOrder` |

## Repository Structure (Target)

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
│   │   ├── waiter/                # Waiter pages (table, menu, cart)
│   │   ├── kds/                   # KDS pages (ticket grid)
│   │   ├── display/               # Display pages (order status)
│   │   ├── role_picker.page.dart  # First-launch role selector
│   │   └── setup/                 # Setup wizard
│   ├── components/                # Shared UI components
│   ├── constants/                 # App constants, styles, validators
│   ├── extensions/                # Dart extension methods
│   ├── functions/                 # Business logic (OrderFunction)
│   ├── services/                  # Cloud, printing, utility services
│   └── widgets/                   # Legacy admin widgets
├── packages/
│   └── eatery_core/               # Shared core (unchanged)
├── libeaterystore/                # Native SQLite library (unchanged)
├── assets/                        # Static assets (unchanged)
├── docs/                          # Documentation
└── test/                          # Test suite
```

## Sync Topology

```
┌─────────────────────────────────┐
│  Device A: role = admin         │  ← Sync Host
│  Runs SyncServer on :9876       │
└────────────┬────────────────────┘
             │ WebSocket
    ┌────────┼────────┬───────────┐
    │        │        │           │
    ▼        ▼        ▼           ▼
┌──────┐ ┌──────┐ ┌──────┐ ┌──────────┐
│ admin │ │waiter│ │ kds  │ │ display  │
│(other)│ │ leaf │ │ leaf │ │  leaf    │
└──────┘ └──────┘ └──────┘ └──────────┘
```

- **Admin device** always runs the sync server. If you need multiple admin terminals, only one should have the sync host role (future: configurable in settings).
- **mDNS discovery:** Service type `_eatery-sync._tcp`. Fallback to `localhost` if discovery fails.
- **Offline-first:** All devices work without a connection. Leaf nodes queue OpLog entries locally until the host is reachable.
- See [Sync Protocol](sync-protocol.md) for wire format and conflict resolution.

## Rollback Strategy

If the unified app breaks production:

1. `git checkout pre-unification` — restores all 4 separate apps
2. `melos bootstrap` — reinstalls sub-app dependencies
3. Rebuild and redeploy each sub-app individually

The `pre-unification` tag was created before deleting `apps/` (Phase 1, issue 16).

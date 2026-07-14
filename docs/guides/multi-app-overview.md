# Multi-App Overview

Eatery is a family of four applications that form a complete restaurant management system. They share a common core (`packages/eatery_core`) but serve different user roles with distinct UIs.

## The Four Apps

### Admin (`apps/eatery_admin/`)

The primary restaurant management application. Full POS, menu management, customer database, payment processing, staff management, dining table floor plan, reports, settings, and backup/restore. Runs on a dedicated terminal (desktop) or tablet.

**Screens:** Login → Dashboard → POS (point of sale) → Cart → Order confirmation → Orders list → Order detail → Customers → Payments → Dining tables → Products → Categories → Staff → Settings → Backup/restore → Reports

### Waiter (`apps/eatery_waiter/`)

Wireless order-taking app for floor staff. Lightweight, focused on table management and order entry. Syncs with Admin for menu data and sends orders in real time.

**Screens:** Login → Table overview → Table detail → POS (add items) → Order confirmation → Orders list

### Kitchen Display (KDS) (`apps/eatery_kds/`)

Real-time order feed for chefs. Displays incoming KOTs (kitchen order tickets) grouped by station. Supports marking items as "preparing" and "ready". Read-only on orders, no order editing.

**Screens:** Login → Order feed (filtered by station) → Order detail (items, modifiers, table)

### Display (`apps/eatery_display/`)

Customer-facing display showing order status. Placed in the dining area so customers can see when their order is being prepared, ready, or served. Read-only, no authentication needed.

**Screens:** Order status board → Order detail (items, progress)

## Sync Topology

```
┌──────────────┐
│    Admin     │  ← Sync Host
│  (Host App)  │
└──────┬───────┘
       │
       ├─── eatery_waiter   (Leaf Node — push/pull orders, products, customers)
       ├─── eatery_kds      (Leaf Node — pull orders, push status changes)
       └─── eatery_display  (Leaf Node — pull order status, read-only)
```

**Roles:**
- **Admin** runs the sync server (WebSocket host). All writes fan through it.
- **Waiter, KDS, Display** connect as leaf nodes. They push their own OpLog entries and receive broadcasts from other nodes.

**Discovery:** mDNS service type `_eatery-sync._tcp`. Fallback: manual IP entry.

**Host Election:** If the Admin host goes offline, leaf nodes detect missed heartbeats (3 × 5s) and elect a new host by highest uptime + clock.

## Dependency Graph

```
eatery_admin ──┐
eatery_waiter ──┤── eatery_core ── libeaterystore (FFI)
eatery_kds   ──┘
eatery_display ──┘
```

All apps depend on `eatery_core` for shared code. The native `libeaterystore` (Zig/SQLite) is loaded via `dart:ffi` only by `eatery_core`.

## Current Status

| App | Status | Notes |
|-----|--------|-------|
| Admin | Functional | Being migrated from `lib/` to `apps/eatery_admin/`. Full POS, menu, customers, payments, staff, tables, settings, backup. |
| Waiter | In progress | App scaffold exists. Core screens planned. |
| KDS | In progress | App scaffold exists. Order feed planned. |
| Display | In progress | App scaffold exists. Read-only display planned. |

The root `lib/` directory currently hosts the Admin app code. It is being migrated into `apps/eatery_admin/lib/` as a Melos workspace member. During transition, both locations may contain code.

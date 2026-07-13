# PRD 03 — Feature Requirements by Phase

## Phase 0 — Foundation: Core Extraction

| Feature | Description | Acceptance Criteria |
|---------|-------------|-------------------|
| Monorepo structure | Create `apps/` and `packages/` dirs. Move existing code into `apps/eatery_admin/` | `apps/eatery_admin` builds and runs |
| `packages/eatery_core` | Shared package with all models, repos, sync, theme, providers | `pubspec.yaml` points to path dep |
| Import migration | All Admin app imports use `package:eatery_core/` | No broken imports |
| Schema extraction | DB schema lives in `packages/eatery_core/assets/` | Both apps use same schema |
| Verification | Existing app functions identically | All existing flows work |

## Phase 1 — Role-Based Auth

| Feature | Description |
|---------|-------------|
| Staff PIN login | Replace `Company.password` with per-staff PIN. Staff model gets `pin` field. |
| AuthSession provider | Riverpod provider tracking `currentStaff` + `currentRole` |
| Route guards | GoRouter redirect checks `StaffType` against allowed routes |
| Login page rewrite | Query staff by phone, verify PIN, set session |
| Logout with state clear | Clear session, navigate to login, prevent back-navigation |
| Route permission map | Each route maps to allowed `StaffType` values |
| Waiter assignment | `Order.staffId` set automatically; table can have assigned waiter |

## Phase 2 — Order Status Lifecycle

| Feature | Description |
|---------|-------------|
| `OrderStatus` enum | `pending → preparing → ready → served → completed → voided` |
| Status history table | `order_status_history(order_id, from_status, to_status, changed_by, changed_at)` |
| State machine validation | Invalid transitions rejected (e.g., `voided → served`) |
| KDS status updates | Kitchen acknowledges → `preparing`, marks done → `ready` |
| Waiter/Admin actions | Mark `ready → served` |
| Station-based filtering | KDS shows only orders for its station |
| Status display in UI | ViewOrder page shows current status + history timeline |

## Phase 3 — Local Network Sync

| Feature | Description |
|---------|-------------|
| WebSocket transport | Implement `_sendMessage()` in `SyncService` using `dart:io` |
| Admin as sync host | Admin starts WebSocket server on configurable port (default 42069) |
| Auto-discovery | mDNS service `_eatery-sync._tcp` + UDP broadcast fallback |
| Manual connection | IP:port input form for leaf apps |
| OpLog integration | Every repository write commits an `OpLogEntry` |
| Heartbeat | 5-second keep-alive between host and leaves |
| Host election | 3 missed heartbeats triggers re-election (highest uptime wins) |
| Sync status indicator | Dashboard shows connected devices, last sync time |

## Phase 4 — Waiter App

| Feature | Description |
|---------|-------------|
| Table floor plan | Visual grid of tables with status colors (available/occupied/reserved) |
| Quick POS | Streamlined flow: select table → browse items → add to cart → checkout |
| KOT printing | Send KOT to configured Bluetooth/USB printer |
| My tables filter | Show only tables assigned to logged-in waiter |
| Order status view | See if kitchen has acknowledged/prepared the order |
| Sync integration | Orders pushed to Admin and KDS via WebSocket in real-time |

## Phase 5 — Kitchen Display App

| Feature | Description |
|---------|-------------|
| Order card feed | Real-time cards for incoming orders, sorted by time |
| Station filter | Tabs/sections for each KDS station |
| Acknowledge button | Tap → `pending` → `preparing`, order highlighted |
| Ready button | Tap → `preparing` → `ready`, order moves to ready section |
| Sound alert | Audible notification on new order |
| Visual alert | Screen flash/pulse for new orders after idle |
| Item-level status | Mark individual `OrderProduct` items as done |

## Phase 6 — Display App

| Feature | Description |
|---------|-------------|
| Order number display | Large-format list of order numbers with status |
| Color coding | Preparing (yellow), Ready (green) |
| Auto-scroll | Scrolls through active orders on a loop |
| Configurable sections | Optionally show by waiter or station |

## Phase 7 — Admin Gaps (Reporting & Inventory)

| Feature | Description |
|---------|-------------|
| Z-Report | End-of-day sales report with totals by payment mode, tax collected |
| X-Report | Mid-day sales snapshot |
| Daily summary | Date range picker, show total sales, orders, average ticket |
| Dashboard charts | Revenue trend line, order volume bar, payment mode pie |
| Stock counts | `Product.stockQuantity`, manual adjustment UI |
| Low-stock alerts | Visual indicator when stock < threshold, notification in POS |
| Purchase orders | Create PO, receive stock, adjust inventory |

## Phase 8 — Cloud Sync (Stretch)

| Feature | Description |
|---------|-------------|
| Cloud relay server | Dart `shelf` server on a VPS |
| Offline queue | Local OpLog syncs to cloud when online |
| Multi-location | HQ dashboard shows data from all restaurant locations |
| Remote monitoring | Owner views sales from home via web dashboard |

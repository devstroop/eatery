# PRD 05 — Release Criteria

## Phase 0 — Core Extraction

| Criteria | Status |
|----------|--------|
| `packages/eatery_core` builds without errors | ✅ |
| Monorepo unified into single binary (apps/ removed) | ✅ |
| All existing data loads correctly after migration | ✅ |
| POS flow: select type → add items → checkout → verify order in DB | ✅ |
| All existing CRUD pages functional (products, customers, staff, tables, settings) | ✅ |
| No regression in print functionality | ✅ |

## Phase 1 — Role-Based Auth

| Criteria | Status |
|----------|--------|
| Staff login with individual PIN works | ✅ |
| Router redirects unauthorized users | ✅ |
| Admin can access all routes; waiter access restricted correctly | ✅ |
| Orders track which staff created them | ✅ |
| Logout clears session and prevents back-navigation | ✅ |
| Reset PIN flow works end-to-end | ✅ |
| Existing PIN-less company upgraded with admin staff account | ✅ |

## Phase 2 — Order Status Lifecycle

| Criteria | Status |
|----------|--------|
| New orders created with `pending` status | ✅ |
| Kitchen can acknowledge (→ `preparing`) | ✅ |
| Kitchen can mark ready (→ `ready`) | ✅ |
| Waiter can mark served (→ `served`) | ✅ |
| Admin can complete/void orders | ✅ |
| Status history is recorded for every transition | ✅ |
| Invalid transitions are rejected | ✅ |
| ViewOrder page shows current status + history timeline | ✅ |

## Phase 3 — Local Network Sync

| Criteria | Status |
|----------|--------|
| Admin hosts WebSocket server, accepts connections | ✅ |
| Leaf devices connect and receive heartbeats | ✅ |
| Order created on waiter → appears on admin within 2s | ✅ |
| Kitchen status update → reflects on all connected devices | ✅ |
| Host failure → election → new host within 15s | ❓ |
| Reconnecting leaf catches up on missed entries | ✅ |
| Sync status indicator shows connected/standalone/host | ✅ |

## Phase 4 — Waiter App

| Criteria | Status |
|----------|--------|
| Waiter app runs as role within single binary | ✅ |
| Table floor plan displays with correct status colors | ✅ |
| Full POS flow works (browse → cart → checkout) | ✅ |
| KOT prints to configured Bluetooth printer | ✅ |
| Order appears on Admin and KDS in real-time | ✅ |
| Waiter can see their assigned tables | ✅ |
| Waiter can edit/void pending orders | ✅ |

## Phase 5 — Kitchen Display App

| Criteria | Status |
|----------|--------|
| KDS app runs as role within single binary | ✅ |
| New orders appear in real-time card feed | ✅ |
| Acknowledge and ready buttons work | ✅ |
| Sound alert plays on new order | ✅ |
| Station filter shows correct items | ✅ |
| Item-level status (mark individual line items done) | ✅ |
| Visual idle alert (screen flash on new order after idle) | ✅ |

## Phase 6 — Display App

| Criteria | Status |
|----------|--------|
| Display app runs as role within single binary | ✅ |
| Order numbers appear with correct status colors | ✅ |
| Lottie fireworks on new pending, pulse while preparing | ✅ |
| Auto-scroll works on a loop | ✅ |
| Configurable sections (group by station) | ✅ |

## Phase 7 — Admin Gaps

| Criteria | Status |
|----------|--------|
| Z-report generates with correct totals | ✅ |
| X-report shows mid-day snapshot | ✅ |
| Dashboard shows sales charts (revenue, orders, payment pie) | ✅ |
| Products have stock count fields | ✅ |
| Low-stock alerts show in POS and inventory | ✅ |
| Dynamic currency symbol (not hardcoded `$`) | ✅ |
| Purchase order creation + stock receipt works | ☐ |

## Phase 8 — Cloud Sync (Stretch)

| Criteria | Status |
|----------|--------|
| Cloud relay server accepts connections | ☐ |
| Offline queue syncs when connection restores | ☐ |
| Multi-location dashboard shows all stores | ☐ |
| Remote monitoring works from web browser | ☐ |

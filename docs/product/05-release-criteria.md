# PRD 05 — Release Criteria

## Phase 0 — Core Extraction

| Criteria | Status |
|----------|--------|
| `packages/eatery_core` builds without errors | ☐ |
| `apps/eatery_admin` builds and runs from monorepo | ☐ |
| All existing data loads correctly after migration | ☐ |
| POS flow: select type → add items → checkout → verify order in DB | ☐ |
| All existing CRUD pages functional (products, customers, staff, tables, settings) | ☐ |
| No regression in print functionality | ☐ |

## Phase 1 — Role-Based Auth

| Criteria | Status |
|----------|--------|
| Staff login with individual PIN works | ☐ |
| Router redirects unauthorized users | ☐ |
| Admin can access all routes; waiter access restricted correctly | ☐ |
| Orders track which staff created them | ☐ |
| Logout clears session and prevents back-navigation | ☐ |
| Reset PIN flow works end-to-end | ☐ |
| Existing PIN-less company upgraded with admin staff account | ☐ |

## Phase 2 — Order Status Lifecycle

| Criteria | Status |
|----------|--------|
| New orders created with `pending` status | ☐ |
| Kitchen can acknowledge (→ `preparing`) | ☐ |
| Kitchen can mark ready (→ `ready`) | ☐ |
| Waiter can mark served (→ `served`) | ☐ |
| Admin can complete/void orders | ☐ |
| Status history is recorded for every transition | ☐ |
| Invalid transitions are rejected | ☐ |
| ViewOrder page shows current status + history timeline | ☐ |

## Phase 3 — Local Network Sync

| Criteria | Status |
|----------|--------|
| Admin hosts WebSocket server, accepts connections | ☐ |
| Leaf devices connect and receive heartbeats | ☐ |
| Order created on waiter → appears on admin within 2s | ☐ |
| Kitchen status update → reflects on all connected devices | ☐ |
| Host failure → election → new host within 15s | ☐ |
| Reconnecting leaf catches up on missed entries | ☐ |
| Sync status indicator shows connected/standalone/host | ☐ |

## Phase 4 — Waiter App

| Criteria | Status |
|----------|--------|
| Waiter app builds from monorepo | ☐ |
| Table floor plan displays with correct status colors | ☐ |
| Full POS flow works (browse → cart → checkout) | ☐ |
| KOT prints to configured printer | ☐ |
| Order appears on Admin and KDS in real-time | ☐ |
| Waiter can see their assigned tables | ☐ |

## Phase 5 — Kitchen Display App

| Criteria | Status |
|----------|--------|
| KDS app builds from monorepo | ☐ |
| New orders appear in real-time card feed | ☐ |
| Acknowledge and ready buttons work | ☐ |
| Sound alert plays on new order | ☐ |
| Station filter shows correct items | ☐ |

## Phase 6 — Display App

| Criteria | Status |
|----------|--------|
| Display app builds from monorepo | ☐ |
| Order numbers appear with correct status colors | ☐ |
| Auto-scroll works on a loop | ☐ |

## Phase 7 — Admin Gaps

| Criteria | Status |
|----------|--------|
| Z-report generates with correct totals | ☐ |
| X-report shows mid-day snapshot | ☐ |
| Dashboard shows sales charts | ☐ |
| Products have stock count fields | ☐ |
| Low-stock alerts show in POS | ☐ |
| Purchase order creation + stock receipt works | ☐ |

## Phase 8 — Cloud Sync

| Criteria | Status |
|----------|--------|
| Cloud relay server accepts connections | ☐ |
| Offline queue syncs when connection restores | ☐ |
| Multi-location dashboard shows all stores | ☐ |
| Remote monitoring works from web browser | ☐ |

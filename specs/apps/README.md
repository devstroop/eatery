# Application Modules

> Specs for each device-specific application in the Eatery ecosystem.

---

## Applications

| App | Primary Device | Purpose | Status |
|-----|---------------|---------|--------|
| **Admin** | Tablet / Desktop | Full POS, menu management, reports, settings | ✅ Current |
| **Waiter** | Phone / Small tablet | Order entry, table management | 🔲 Planned |
| **Kitchen Display** | Wall-mounted screen / Tablet | Order routing, prep tracking | 🔲 Planned |
| **Customer Portal** | Any browser | Menu browsing, online ordering | 🔲 Future |
| **Sync Daemon** | Raspberry Pi / Server | Host service, cloud bridge | 🔲 Planned |

---

## Admin (Current)

The existing app in `lib/`. Single-location POS with full management capabilities.

### Key screens
- Dashboard (hub-and-spoke navigation)
- Point of Sale (product grid, cart, order flow)
- Orders (list, view, edit)
- Payments (log, view)
- Customers (CRUD)
- Products & Categories (CRUD)
- Dining Tables (CRUD, status management)
- Staff (CRUD)
- Settings (company, tax, printer, data management)

---

## Waiter (Planned)

Lightweight order-entry app. Subset of Admin features.

### Screens
- Table view (floor plan)
- Menu browser (by category)
- Cart / order review
- Order sent confirmation

### Sync
- Connects to Admin/sync host for menu data
- Pushes orders via OpLog
- Pulls table status updates

---

## Kitchen Display System (Planned)

Always-on order feed.

### Screens
- Order queue (filtered by station)
- Order detail (line items, modifiers, prep time)
- Bump bar (mark items as started/completed)

### Routing
- Each product has a `stationId` (grill, salad, bar, expo)
- KDS shows only its station's orders
- Supports split tickets (items routed to different stations)

---

## Customer Portal (Future)

Web-based menu and ordering.

### Features
- Menu browsing (read-only)
- Cart / checkout
- Order status tracking
- Pickup time selection

---

## Sync Daemon (Planned)

Headless service that runs the sync server and cloud bridge.

### Responsibilities
- WebSocket server for device connections
- OpLog validation and conflict resolution
- Cloud push/pull bridge
- Heartbeat monitoring
- Host election participation

## eatery Provider Hierarchy

```
                    ┌─────────────────────────┐
                    │     eateryStoreProvider   │  (EateryStore — raw SQLite)
                    └────────────┬────────────┘
                                 │
            ┌────────────────────┼────────────────────┐
            ▼                    ▼                    ▼
   ┌────────────────┐   ┌────────────────┐   ┌──────────────────┐
   │Repository      │   │SyncCoordinator │   │CompanyProvider    │
   │Providers       │   │Provider        │   │(currency, name..) │
   │(order, product,│   │                │   └──────────────────┘
   │ customer,      │   │syncStatus     │
   │ diningTable,   │   │Provider       │
   │ staff, tax,    │   └────────────────┘
   │ payment, etc)  │
   └───────┬────────┘
           │
           ▼
   ┌────────────────┐
   │  cartProvider   │  (PosSession + CartNotifier)
   │  (waiter/admin) │
   └───────┬────────┘
           │
           ▼
   ┌──────────────────────────────────────────┐
   │              UI Pages                     │
   │                                          │
   │  ┌───────────┐  ┌──────────┐  ┌────────┐ │
   │  │ TablePage │  │MenuPage  │  │CartPage │ │
   │  │ (waiter)  │  │(waiter)  │  │(waiter) │ │
   │  └─────┬─────┘  └────┬─────┘  └───┬────┘ │
   │        │              │            │      │
   │  ┌─────▼──────────────▼────────────▼───┐  │
   │  │        WaiterOrdersPage             │  │
   │  └─────────────────────────────────────┘  │
   │                                          │
   │  ┌──────────┐  ┌──────────┐  ┌─────────┐ │
   │  │ POS Page │  │Cart Page │  │OrderPrint│ │
   │  │ (admin)  │  │ (admin)  │  │          │ │
   │  └──────────┘  └──────────┘  └─────────┘ │
   │                                          │
   │  ┌──────────┐  ┌────────────┐            │
   │  │TicketPage│  │DisplayPage │            │
   │  │  (KDS)   │  │ (Display)  │            │
   │  └──────────┘  └────────────┘            │
   └──────────────────────────────────────────┘

Key:
  ┌──────────┐  AsyncNotifierProvider / StateProvider / NotifierProvider
  ───→         Dependency (reads from)

Data flow:
  1. SQLite tables are read/written via Repository providers.
  2. syncStatusProvider notifies all pages of incoming remote changes.
  3. Pages invalidate their local FutureProviders on sync or periodic timer.
  4. cartProvider holds the ephemeral POS/waiter session state.

Infrastructure:
  - eateryStoreProvider: raw sqlite3 database access
  - appDatabaseProvider: EateryDatabase abstraction (used by old code)
  - syncCoordinatorProvider: manages WebSocket sync between devices
  - syncStatusProvider: connection state + pending entry count
  - authSessionProvider: current logged-in Staff
  - roleProvider: device role (admin / waiter / kds / display)

Bluetooth:
  - BluetoothManager (singleton): wraps FlutterBluePlus for BLE printer I/O
  - BluetoothPrinterService: scan → connect → writeBytes → disconnect flow
  - PrinterRepository: persists saved Printer configs to SQLite
  - AutoPrint: singleton config for auto-print on sale

Waiter edit/void flow:
  - WaiterOrdersPage → PopupMenuButton → editOrder route / void dialog
  - Void records reason + VoidLogEntry to void_log_entry table
  - Edit only allowed while order is in pending or preparing status
  - Role-gated by StaffType.waiter

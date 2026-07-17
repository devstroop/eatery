# Providers (Riverpod)

All providers in `packages/eatery_core/lib/providers/`.

## Pattern

```
Repository (data access)
  → Provider<Repository>           (singleton)
    → NotifierProvider / FutureProvider  (reactive state)
      → ConsumerWidget.build()     (UI reads via ref.watch)
```

## Provider Catalog

### Database

| Provider | Type | Purpose |
|----------|------|---------|
| `eateryStoreProvider` | `Provider<EateryStore>` | Native SQLite via Zig FFI |
| `appDatabaseProvider` | `Provider<EateryDatabase>` | Compatibility DB wrapper |

### Session / Auth

| Provider | Type | Purpose |
|----------|------|---------|
| `authSessionProvider` | `StateNotifierProvider` | Current logged-in `Employee` (null = none) |
| `roleProvider` | `StateNotifierProvider` | Device role string (admin/waiter/kds/display) |
| `syncStatusProvider` | `StateProvider<SyncStatus?>` | Sync connection + entry count |

### Company

| Provider | Type | Purpose |
|----------|------|---------|
| `companyRepositoryProvider` | `Provider<CompanyRepository>` | Repository singleton |
| `companyProvider` | `NotifierProvider<CompanyNotifier, Company?>` | Current company + currency |

### Cart (POS Session)

| Provider | Type | Purpose |
|----------|------|---------|
| `cartProvider` | `NotifierProvider<CartNotifier, PosSession>` | Active order context |

`PosSession` fields: `activeOrderType`, `activeDiningTable`, `activeCustomer`, `activeOrder`, `cart` (Map<int, CartItem>).

### Entities (Repository Providers)

| Provider | Returns |
|----------|---------|
| `productRepositoryProvider` | `ProductRepository` |
| `orderRepositoryProvider` | `OrderRepository` |
| `customerRepositoryProvider` | `CustomerRepository` |
| `paymentRepositoryProvider` | `PaymentRepository` |
| `taxRepositoryProvider` | `TaxRepository` |
| `diningTableRepositoryProvider` | `DiningTableRepository` |
| `printerRepositoryProvider` | `PrinterRepository` |
| `modifierRepositoryProvider` | `ModifierRepository` |
| `employeeRepositoryProvider` | `EmployeeRepository` |
| `supplierRepositoryProvider` | `SupplierRepository` |
| `stockProvider` | `StockNotifier` |

## Usage

```dart
// In build() — react to changes
final orders = ref.watch(ordersProvider);
final company = ref.watch(companyProvider);

// In event handlers — read once
final repo = ref.read(orderRepositoryProvider);
await repo.saveOrder(order);

// Invalidate on data change
ref.invalidate(ordersProvider);

// In initState — listen to external changes
ref.listenManual(syncStatusProvider, (_, status) {
  ref.invalidate(_tablesProvider);
});
```

## Sync

### Sync Protocol

Local-network device-to-device sync via WebSocket:

```
Admin (Host)  <──WebSocket──>  Waiter (Leaf)
              <──WebSocket──>  KDS (Leaf)
```

Messages: `host_announce`, `oplog_push`, `oplog_pull`, `oplog_broadcast`, `heartbeat`, `ack`.

OpLog entries stored in `op_log` table with UUID v7 IDs (time-sortable). Each entry records entity type, operation (create/update/void), full data snapshot, and originating device.

### SyncStatusChip

Shows connection state in AppBar. Listens to `syncStatusProvider`.

```dart
const SyncStatusChip()
```

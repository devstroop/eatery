# Data Flow

> How data moves through the system — from user action to persistence to sync.

## Local Write Path

```
User taps "Add to cart"
  │
  ▼
CartNotifier.addToCart(product)    ← Riverpod state mutation
  │
  ▼
CartPage / PosPage reads ref.watch(cartProvider)   ← Reactive rebuild
  │
  ▼
"Place Order" → OrderConfirmationPage
  │
  ▼
OrderRepository.saveOrder(order)   ← Repository (SQLite)
  
  ├─ SQLite path: SqliteOrderRepository
  │     ─ _store.execute('INSERT INTO orders ...')
  │     ├─ _opLog.commit("order", "create", data, prevData)
  │     └─ Returns id
  │
  └─ (Legacy Hive path — removed)
  │
  ▼
SyncService.pushToHost()           ← Async, fire-and-forget
```

### Repository Write Pattern (SQLite)

```dart
class SqliteOrderRepository implements OrderRepository {
  final EateryStore _store;
  final OpLogService _opLog;

  Future<int> createOrder(Order order) async {
    // 1. Insert into SQLite
    _store.execute('INSERT INTO orders (...) VALUES (...)', params);

    // 2. Read back the auto-generated ID
    final id = _store.queryScalar('SELECT last_insert_rowid()');

    // 3. Commit OpLog entry for sync
    _opLog.commit(
      entityType: 'order',
      entityId: id,
      operation: 'create',
      data: { ...order.toMap(), 'id': id },
    );

    return id;
  }
}
```

## Sync Write Path (Remote)

```
Remote device commits OpLog entry locally
  │
  ▼
Sync Client sends `oplog_push` over WebSocket
  │
  ▼
Sync Host receives `oplog_push`
  │
  ├─ Validates entry (clock check, parent check)
  ├─ Resolves conflicts (LWW by clock + deviceId)
  ├─ Writes to local DB via repository
  ├─ Records own OpLog entry for the merge
  └─ Broadcasts `oplog_broadcast` to all connected leaf nodes
```

### Conflict Resolution

Last-Writer-Wins by logical clock:

1. Every mutation commits an `OpLogEntry` with an incrementing clock.
2. Ordered by `(clock, deviceId)` — higher clock wins; same clock → lexicographic deviceId.
3. `applyBatch()` checks: if incoming entry has higher clock than local state, it overwrites.
4. Full snapshots in `data` field — no field-level merge needed.

### Clock Management

```dart
// On local write:
_clock++;
_opLog.commit(_clock, entry);

// On receiving batch:
for (final entry in batch) {
  _clock = max(_clock, extractClock(entry.id)) + 1;
  storeAndApply(clock, entry);
}
```

## DTO Translation Layer

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  DB Model    │────▶│    DTO       │────▶│   JSON wire  │
│ (toMap)      │     │ (toJson)     │     │ (WebSocket)  │
└─────────────┘     └──────────────┘     └──────────────┘
        ▲                                        │
        │                                        ▼
│  DB Model    │◀───│    DTO       │◀──│   JSON wire  │
│ (fromMap)    │     │ (fromJson)   │     │ (WebSocket)  │
└──────────────┘     └──────────────┘     └──────────────
```

DTOs live in `packages/eatery_core/lib/data/dtos/`. They are:
- (no Hive annotations needed)
- Versioned (each DTO has a `schemaVersion` field)
- Validated (null checks, range checks on deserialization)

## Startup & Data Consistency

```
App starts
  │
  ├─ Init native SQLite store (EateryStore.open)
  │     ├─ Run schema initialization from schema.sql
  │     └─ Run SchemaMigrator for incremental migrations
  │
  ├─ Initialize SQLite store (all entities — Hive fully migrated)
  │
  ├─ Initialize repositories (SQLite)
  │
  ├─ Connect to sync host (if available)
  │     ├─ Pull missed ops since last connection
  │     └─ Apply to local DB
  │
  └─ Ready for use
```

## Hive → SQLite Transition (Complete)

The migration from Hive to SQLite is complete for all entities:

| Phase | Entity | Repository | OpLog |
|-------|--------|-----------|-------|
| Removed | All | SQLite via EateryStore | All migrated |
| Phase A | Product, Customer, Order | SQLite | ✅ |
| Phase B | Payment, Tax, DiningTable, Company, Staff, etc. | SQLite | ✅ |
| Post-migration | All | SQLite only | ✅ |

All entities use SQLite. All feature flags in `store_config.dart` are `true` and the legacy Hive fallback code has been fully removed.

## See Also

- [Sync Protocol spec](../architecture/sync-protocol.md) — OpLog, WebSocket messages, discovery
- [Database Schema spec](../architecture/database-schema.md) — SQL tables and migration
- [Repositories spec](../architecture/repositories.md) — All repository interfaces
- [Migration Patterns](../development/migration-patterns.md) — Strangler fig migration reference

# Data Flow Architecture

> How data moves through the system — from user action to persistence to sync.

---

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
OrderRepository.saveOrder(order)   ← Hive write
OrderRepository.addOrderProduct(op) ← Hive write  
  │
  ▼
OpLogService.commit("order", "create", data, prevData)  ← New
  │
  ▼
SyncService.pushToHost()           ← Async, fire-and-forget
```

---

## Sync Write Path (Remote)

```
Remote device commits OpLog entry
  │
  ▼
Sync Host receives `oplog_push`
  │
  ├─ Validates entry (clock check, parent check)
  ├─ Resolves conflicts (LWW / operator resolve)
  ├─ Writes to local Hive via repository
  ├─ Records own OpLog entry for the merge
  └─ Broadcasts to all connected leaf nodes
```

---

## DTO Translation Layer

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Hive Model   │────▶│    DTO       │────▶│   JSON wire  │
│ (toMap)       │     │ (toJson)     │     │ (WebSocket)  │
└──────────────┘     └──────────────┘     └──────────────┘
        ▲                                        │
        │                                        ▼
│  Hive Model   │◀───│    DTO       │◀───│   JSON wire  │
│ (fromMap)     │     │ (fromJson)   │     │ (WebSocket)  │
└──────────────┘     └──────────────┘     └──────────────┘
```

DTOs live in `lib/data/dtos/`. They are:
- Independent of Hive annotations
- Versioned (each DTO has a `schemaVersion` field)
- Validated (null checks, range checks on deserialization)

---

## Startup & Data Consistency

```
App starts
  │
  ├─ Init Hive boxes (local)
  ├─ Connect to sync host (if available)
  │     ├─ Pull missed ops since last connection
  │     └─ Apply to local Hive
  └─ Ready for use
```

On initial sync from cloud:
```
Device first setup
  │
  ├─ Download full snapshot from cloud
  ├─ Replay ops into local Hive
  └─ Begin normal operation
```

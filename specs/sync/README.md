# Sync Protocol

> Peer-to-peer data replication for multi-device restaurant operations.
> Cloud is a replication target, *not* the primary data store.

---

## Design Principles

1. **Local-first** — Every device owns its data. The network is optional.
2. **Append-only OpLog** — All mutations are recorded as immutable operations.
3. **CRDT-inspired merge** — State mutations (voids, refunds, edits) use last-writer-wins with logical clocks.
4. **Host-elected topology** — One device acts as sync host. Failover via host-election protocol.
5. **DTO layer** — Wire format is JSON over WebSocket. Hive models never leave the device.

---

## Topology

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│  Admin   │────▶│  Host    │◀────│  Waiter  │
│ (tablet) │     │ (Pi/AP)  │     │ (phone)  │
└──────────┘     └────┬─────┘     └──────────┘
                      │
              ┌───────┴────────┐
              │                │
        ┌─────▼────┐    ┌─────▼────┐
        │  KDS     │    │  Cloud   │
        │ (screen) │    │(Firebase)│
        └──────────┘    └──────────┘
```

- **Sync Host** — Dedicated daemon (Raspberry Pi or elected tablet). Runs the sync server.
- **Leaf nodes** — Admin, Waiter, KDS. Connect to host. Never peer-to-peer.
- **Cloud** — Async replication target. Host pushes to cloud. Never read from cloud for operations.

---

## OpLog Entry

```dart
class OpLogEntry {
  final String  id;          // UUID v7 (time-sortable)
  final String  entityType;  // "order", "product", "payment"
  final int     entityId;    // Local ID
  final String  operation;   // "create", "update", "void", "refund"
  final Map<String, dynamic> data;     // Full snapshot after mutation
  final Map<String, dynamic>? prevData; // Snapshot before mutation (for undo/rollback)
  final int     timestamp;   // Logical clock (millis since epoch)
  final String  deviceId;    // Originating device
  final String  parentId;    // Previous op ID for this entity (conflict detection)
}
```

### Conflict Resolution Strategy

| Scenario | Strategy |
|----------|----------|
| Concurrent creates (different tables) | Accept both — table ID scopes uniqueness |
| Concurrent order edits | Last-writer-wins by logical clock |
| Void after payment | Dependent ops merge — payment must be rolled back first |
| Network partition merge | Prior host's ops win; operator resolves via diff UI |

---

## Entity Sync Lifecycle

```
create ──→ update ──→ update ──→ void
  │                    │
  └──→ payment ──→ refund
```

Each arrow is an OpLog entry. The current state is a fold over all ops for that entity.

---

## Wire Protocol (DTO)

All wire messages use explicit DTOs (not Hive models):

```dart
class SyncMessage {
  final String  type;        // "oplog_push", "oplog_pull", "host_announce", "host_vote"
  final String  deviceId;
  final int     clock;       // Sender's current logical clock
  final List<Map<String, dynamic>>? entries;
  final Map<String, dynamic>? payload;
}
```

### Message Types

| Type | Direction | Purpose |
|------|-----------|---------|
| `host_announce` | Host → All | Heartbeat + current clock |
| `oplog_push` | Leaf → Host | Send new ops since last ack |
| `oplog_pull` | Leaf → Host | Request missed ops |
| `oplog_broadcast` | Host → All | Distribute validated ops |
| `host_vote` | Any → All | Trigger host election |
| `host_claim` | Winner → All | New host announced |

---

## Host Election Protocol

1. Leaf detects host silence (3 missed heartbeats)
2. Leaf broadcasts `host_vote` with its clock + uptime
3. Highest-clock device wins; ties broken by lowest deviceId
4. Winner broadcasts `host_claim` with its full op range
5. Losers ack and reconnect

---

## Cloud Replication

- Host pushes to cloud every N ops (configurable, default 30s)
- Cloud is append-only — never modifies ops
- New device restores from cloud then catches up via host
- Cloud schema mirrors DTO layer, not Hive models

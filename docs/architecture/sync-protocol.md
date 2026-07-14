# Sync Protocol

## Architecture

```
Admin App (Sync Host)  <--WebSocket-->  Waiter App (Leaf Node)
                      <--WebSocket-->  KDS App (Leaf Node)
                            |
                      (optional, future)
                            v
                      Cloud Relay (VPS)
```

## OpLog Entry Format

`packages/eatery_core/lib/data/sync/op_log_entry.dart`:

```dart
class OpLogEntry {
  final String id;                    // UUID v7 (time-sortable, globally unique)
  final String entityType;            // "order", "product", "staff", "customer", etc.
  final int entityId;                 // Local DB row ID
  final String operation;             // "create", "update", "void", "refund", "payment"
  final Map<String, dynamic> data;    // Full snapshot after mutation
  final Map<String, dynamic>? prevData; // Snapshot before mutation (null for create)
  final int timestamp;                // Logical clock (ms since epoch on origin)
  final String deviceId;              // Originating device
  final String? parentId;             // Previous op for this entity (forms chain)
  final String? hostId;               // Sync host that accepted this entry
  final Map<String, dynamic>? metadata; // Free-form (e.g., {"staffId": 5})
}
```

Entries are stored in the `op_log` SQLite table keyed by an auto-incrementing clock.

## Topology

- **Admin app**: Sync host — runs WebSocket server, coordinates replication, broadcasts to leaves
- **Waiter/KDS/Display apps**: Leaf nodes — connect to host, push local ops, receive broadcasts
- **Standalone**: No network — single-device mode (no sync)

## WebSocket Message Types

`packages/eatery_core/lib/data/sync/sync_message.dart`:

| Type | Direction | Payload | When |
|------|-----------|---------|------|
| `host_announce` | Host -> Leaves | `{ deviceId, deviceName, clock }` | Every 5s heartbeat |
| `oplog_push` | Leaf -> Host / Host -> Leaf | `{ entries: [...] }` | New local entries available |
| `oplog_pull` | Leaf -> Host | `{ sinceClock: N }` | On connect or reconnect |
| `oplog_broadcast` | Host -> All Leaves | `{ entries: [...] }` | After receiving push, fan-out |
| `host_vote` | Any -> All | `{ deviceId, uptimeSeconds, clock }` | On host loss detection |
| `host_claim` | Winner -> All | `{ deviceId, lastOpTimestamp, entryCount }` | After winning election |
| `heartbeat` | Host <-> Leaf | `{ clock }` | Connection keep-alive (5s) |
| `ack` | Any | `{ lastAppliedClock: N }` | Confirm receipt |

### Wire Format

```json
{
  "type": "oplog_push",
  "deviceId": "eatery-admin",
  "clock": 42,
  "entries": [...]
}
```

## Conflict Resolution (LWW CRDT)

Last-Writer-Wins with clock-based ordering:

1. Every entity mutation commits an `OpLogEntry` with the device's incrementing clock
2. Entries ordered by `(clock, deviceId)` — higher clock wins; tiebreak by lexicographic deviceId
3. On sync, incoming entry with higher clock overwrites local state
4. Full snapshots in `data` field — no field-level merge needed

### Clock Management

Each device maintains a monotonically increasing logical clock. On local write, the clock increments and the entry is stored. On receiving a batch, the local clock advances to `max(localClock, maxReceivedClock) + 1`.

## mDNS Discovery

Service type: `_eatery-sync._tcp` (port 9876)

- Admin app advertises the service on startup
- Leaf apps discover and auto-connect
- Fallback: manual IP:Port entry in settings
- Last resort: UDP broadcast on port 9876

## Host Election Protocol

Triggered after 3 missed heartbeats (15s timeout):

1. Each leaf broadcasts a `host_vote` with `{ deviceId, uptimeSeconds, clock }`
2. After 2s timeout, votes are evaluated:
   - Highest uptime wins
   - Tiebreaker: highest clock
3. Winner broadcasts `host_claim` to all devices
4. All leaves connect to the new host

## Cloud Replication (Future)

The host will asynchronously replicate to a cloud VPS server:
- Append-only push of OpLog entries
- No cloud-side conflict resolution (LWW maintained)
- Cloud acts as backup and cross-restaurant aggregation point
- Auth via restaurant API key (derived from company ID)

## Lifecycle

```
App Start -> hasCompany?
  Yes -> Was host? -> becomeHost() (start SyncServer)
         Was leaf? -> connectToHost() or scan mDNS
  No -> becomeStandalone()

On host loss -> detectHostLoss() -> 3 misses -> election
  winner: becomeHost()
  loser: connectToHost(winner)

On settings change:
  User selects "Become Host" -> stop client, start server
  User enters host IP -> stop server, connect client
```

## Mutation Hook

`packages/eatery_core/lib/data/sync/mutation_hook.dart` provides a non-global callback that repositories call after writes. The `SyncCoordinator` installs a hook that forwards mutations to `OpLogService` and broadcasts via the sync service.

```dart
// Repository calls after successful write:
notifyMutation('order', createdId, 'create', order.toMap());
```

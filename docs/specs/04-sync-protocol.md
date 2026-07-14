# Specs 04 — Sync Protocol

## 1. Architecture Overview

```
┌──────────────┐     WebSocket      ┌──────────────┐
│  Admin App   │ ◄─────────────────► │  Waiter App  │
│  (Sync Host) │                     │  (Leaf Node) │
│              │ ◄─────────────────► │  KDS App     │
│  OpLog DB    │                     │  (Leaf Node) │
└──────┬───────┘                     └──────────────┘
       │
       │ (optional, Phase 8)
       ▼
┌──────────────┐
│ Cloud Relay  │
│ (VPS Server) │
└──────────────┘
```

## 2. OpLog Entry (Existing, Extended)

```dart
class OpLogEntry {
  final String id;              // "{deviceId}_{clock}" — globally unique
  final String entityType;      // "order", "product", "staff", "dining_table", etc.
  final int entityId;           // local DB row ID
  final String operation;       // create | update | void | refund | payment | status_change
  final Map<String, dynamic> data;       // full entity snapshot after operation
  final Map<String, dynamic>? prevData;  // snapshot before (null for create)
  final int timestamp;          // milliseconds since epoch
  final String deviceId;        // origin device
  final String? parentId;       // previous op for this entity (forms chain)
  final String? hostId;         // host that accepted this entry
  final Map<String, dynamic>? metadata;  // free-form (e.g., {"staffId": 5})
}
```

## 3. Conflict Resolution (LWW CRDT)

**Last-Writer-Wins** with clock-based ordering:

1. Every entity mutation commits an `OpLogEntry` with an incrementing clock.
2. Entries are ordered by `(clock, deviceId)` — higher clock wins; same clock → lexicographic deviceId.
3. On sync, `applyBatch()` checks: if incoming entry has higher clock than local state, it overwrites.
4. Full snapshots in `data` field — no field-level merge needed.

### Clock Management

```dart
// Each device maintains a monotonically increasing logical clock.
// Clock values are stored in the op_log table (clock column is PRIMARY KEY).

// On local write:
_clock++;
_commit(_clock, entry);

// On receiving batch:
for (final entry in batch) {
  _clock = max(_clock, extractClock(entry.id)) + 1;
  _store(clock, entry);
}
```

## 4. WebSocket Message Protocol

### Wire Format (JSON)

```json
{
  "type": "oplog_push",
  "deviceId": "device-abc-123",
  "clock": 42,
  "payload": { ... }
}
```

### Message Types

| Type | Direction | Payload | When |
|------|-----------|---------|------|
| `host_announce` | Host → Leaf | `{ deviceId, deviceName, clock }` | Every 5s heartbeat |
| `oplog_push` | Leaf → Host / Host → Leaf | `{ entries: [...] }` | New entries available |
| `oplog_pull` | Leaf → Host | `{ sinceClock: 35 }` | On connect or after reconnection |
| `oplog_broadcast` | Host → All Leaves | `{ entries: [...] }` | After receiving push, fan-out to others |
| `host_vote` | Any → All | `{ deviceId, uptimeSeconds, clock }` | On host loss detection |
| `host_claim` | Winner → All | `{ deviceId }` | After winning election |
| `heartbeat` | Host ↔ Leaf | `{ clock }` | Connection keep-alive |
| `ack` | Any | `{ lastAppliedClock: 42 }` | Confirm receipt |

### Sequences

```
Connection:
  Leaf ──oplog_pull──→ Host
  Leaf ←─oplog_push─── Host  (all entries since client's clock)

Steady state:
  Host ──heartbeat──→ Leaf  (every 5s)
  Leaf ──heartbeat──→ Host  (every 5s)
  Leaf ──oplog_push──→ Host  (when local entries exist)
  Host ──oplog_broadcast──→ All Leaves  (fan-out)

Host failure:
  Leaf detects 3 missed heartbeats (15s)
  Leaf ──host_vote──→ All
  All leaves evaluate: highest uptime wins, tiebreak by clock
  Winner ──host_claim──→ All
  All leaves connect to new host
```

## 5. Discovery Protocol

### Primary: mDNS

Service type: `_eatery-sync._tcp`

```dart
// Admin app advertises:
_advertiseService('_eatery-sync._tcp', port: 42069);

// Leaf app discovers:
_discoverServices('_eatery-sync._tcp')
  .listen((service) => connect(service.host, service.port));
```

### Fallback: Manual Connection

Leaf apps show a text form: "Enter Host IP:Port"

### Last Resort: UDP Broadcast

```dart
// Admin listens on UDP port 42069
// Leaf broadcasts discovery packet
// Admin responds with its IP
```

## 6. Host Election

```dart
class HostElection {
  /// Triggered after 3 missed heartbeats.
  void onHostLost() {
    _missedHeartbeats = 0;
    broadcast(HostVote(
      deviceId: _deviceId,
      uptime: _uptimeSeconds(),
      clock: _opLog.clock,
    ));
    // Wait 2s for other votes
    Timer(Duration(seconds: 2), () {
      _evaluateVotes();
    });
  }

  void _evaluateVotes() {
    // Highest uptime wins. Tiebreaker: highest clock.
    _votes.sort((a, b) {
      final uptimeCmp = b.uptime.compareTo(a.uptime);
      if (uptimeCmp != 0) return uptimeCmp;
      return b.clock.compareTo(a.clock);
    });
    final winner = _votes.first;
    if (winner.deviceId == _deviceId) {
      _becomeHost();
    } else {
      _connectToHost(winner.deviceId);
    }
  }
}
```

## 7. OpLog Integration Pattern

Every repository write must also commit to the OpLog:

```dart
class SqliteOrderRepository implements OrderRepository {
  final EateryStore _store;
  final OpLogService _opLog;

  Future<int> createOrder(Order order, {int? staffId}) async {
    // 1. Insert into main SQLite table
    _store.execute('INSERT INTO orders ...');
    final id = _store.queryScalar('SELECT last_insert_rowid()');

    // 2. Commit to OpLog
    _opLog.commit(
      entityType: 'order',
      entityId: id,
      operation: 'create',
      data: { ...order.toMap(), 'id': id },
      metadata: {'staffId': staffId},
    );

    return id;
  }

  Future<void> updateOrderStatus(int orderId, OrderStatus newStatus, int staffId) async {
    // 1. Update main table
    _store.execute('UPDATE orders SET status = ? WHERE id = ?', [newStatus.index, orderId]);

    // 2. Get previous state for prevData
    final prev = getOrderById(orderId);

    // 3. Record in status history
    _store.execute(
      'INSERT INTO order_status_history (order_id, from_status, to_status, changed_by_staff_id, changed_at) VALUES (?,?,?,?,?)',
      [orderId, prev!.status.index, newStatus.index, staffId, DateTime.now().millisecondsSinceEpoch],
    );

    // 4. Commit to OpLog
    _opLog.commit(
      entityType: 'order_status',
      entityId: orderId,
      operation: 'status_change',
      data: {'status': newStatus.index},
      prevData: {'status': prev.status.index},
      metadata: {'staffId': staffId},
    );
  }
}
```

## 8. Sync Service Lifecycle

```
App Start
  │
  ├── Company exists?
  │   ├── Yes → Check previous role
  │   │   ├── Was host? → becomeHost()
  │   │   └── Was leaf? → connectToHost() or scan()
  │   └── No → becomeStandalone()
  │
  └── On host loss:
      detectHostLoss() → 3 misses → election
        → winner: becomeHost()
        → loser: connectToHost(winner)

  └── On settings change:
      User selects "Become Host" → becomeHost()
      User enters host IP → connectToHost()
```

## 9. Security Considerations

| Concern | Mitigation |
|---------|------------|
| Unauthorized device connects | Shared secret (restaurant PIN) on handshake |
| Eavesdropping on LAN | Optional TLS for WebSocket |
| Malicious OpLog entries | Clock validation — reject entries with clock << local |
| Host spoofing | Validate host identity on connection |

# Audit 08 — Data Layer & Sync

## Repository Issues

### R1 — Mix of sync and async methods [HIGH]

**File:** All `_sqlite.dart` repositories

```dart
// Sync
List<Order> getAllOrders() => ...  // synchronous
Order? getOrderById(int id) => ...  // synchronous

// Async
Future<int> saveOrder(Order order) async { ... }  // async
Future<void> deleteOrder(Order order) async { ... }  // async
```

The sync methods are actually synchronous (FFI calls are blocking), while the write methods are wrapped in `Future`. Callers inconsistently use both patterns. Some code uses `await`, some doesn't.

**Fix:** Make query methods sync (they're fast), keep write methods async for API consistency (or make all sync since FFI is synchronous).

---

### R2 — getAll*() loads everything [HIGH]

**File:** All repository implementations

Every `getAll*()` method runs `SELECT * FROM <table>` with no `LIMIT`, `OFFSET`, or filtering parameters. As data grows, this becomes a performance bottleneck.

**Fix:** Add pagination and filtering parameters to all interfaces.

---

### R3 — DiningTableRepository interface incomplete [MEDIUM]

**File:** `dining.table.repository.dart` vs `dining.table.repository.sqlite.dart`

The interface doesn't include category management methods. The SQLite implementation adds them extra. Pages that need categories must `as dynamic` cast.

**Fix:** Add category methods to the interface.

---

### R4 — Repository return type inconsistency [MEDIUM]

**File:** `order_repository_sqlite.dart:43-84`

`saveOrder()` returns `Future<int>` but the underlying `_store.execute()` is synchronous. Same pattern across all repositories.

**Fix:** Either make save methods synchronous (`int saveOrder()`) or document why they're async.

---

## Sync Layer Issues

### S1 — _sendMessage() is a TODO stub [CRITICAL]

**File:** `sync.service.dart:275`

```dart
void _sendMessage(SyncMessage message) {
  // TODO: Implement actual WebSocket send
}
```

The entire sync transport layer is unimplemented. `SyncService` manages timers, state transitions, heartbeats, and election — but never sends a single byte over the network. The method body is empty.

**Fix:** Implement WebSocket send.

---

### S2 — OpLog is never written to [CRITICAL]

**File:** Entire codebase

Despite the `OpLogService` and `SyncService` architecture existing in `lib/data/sync/`, **no repository calls `_opLog.commit()`**. Every `saveOrder()`, `saveTable()`, etc. writes to the main SQLite table but never records the operation in the op_log table. The sync architecture is wired but completely disconnected.

**Fix:** Inject `OpLogService` into every repository and call `commit()` on every write.

---

### S3 — _getUptimeSeconds() returns clock not uptime [HIGH]

**File:** `sync.service.dart:271`

```dart
int _getUptimeSeconds() {
  return DateTime.now().millisecondsSinceEpoch ~/ 1000;  // This is Unix timestamp, not uptime!
}
```

This returns the current Unix timestamp (seconds since epoch), not the process uptime. During host election, this would give random results — the device with a higher clock would arbitrarily win, not the one that's been running longest.

**Fix:** Track process start time and compute uptime: `DateTime.now().difference(_processStartTime).inSeconds`

---

### S4 — Clock validation missing [MEDIUM]

**File:** `op.log.service.dart:96-98`

```dart
void advanceClockTo(int newClock) {
  if (newClock > _clock) _clock = newClock;
}
```

Advances clock unconditionally without validating the source. A malicious or buggy peer could send a wildly incorrect clock value.

**Fix:** Validate `newClock` is within reasonable bounds (e.g., `newClock > _clock && newClock < _clock + 1000`).

---

### S5 — Full snapshots in OpLog [MEDIUM]

**File:** `op.log.entry.dart`

The OpLog stores full entity snapshots in `data`. This works for LWW CRDT but uses more storage and bandwidth than field-level diffs. For a restaurant with 1000+ orders/day, the op_log table could grow quickly.

**Fix:** Implement periodic OpLog compaction (merge chain of entries for the same entity into a single state entry).

---

### S6 — No device identity management [MEDIUM]

**File:** `sync.service.dart`

The `deviceId` is a parameter but there's no mechanism to persist it across app restarts, display it to the user, or let the user name their device.

**Fix:** Store device identity in SQLite preferences, display in sync settings UI.

---

### S7 — Graceful role transition missing [LOW]

**File:** `sync.service.dart`

`becomeHost()`, `becomeLeaf()`, and `becomeStandalone()` exist but there's no UI or flow to let the user trigger these transitions (beyond the automatic election).

**Fix:** Add sync settings UI: "Make this device the host", "Connect to host", "Disconnect".

---

## Service Layer Issues

### L1 — Global static store reference [HIGH]

**File:** `order.function.dart:6-7`

```dart
static EateryStore? _store;
static void init(EateryStore store) { _store = store; }
```

`OrderFunction` stores a global static `EateryStore` reference. This breaks:
- Testability (can't mock the store in unit tests)
- Dependency injection (the store is set once and never changes)
- Multi-app architecture (each app would need its own store reference)

**Fix:** Pass the store as a parameter, or make `OrderFunction` methods take an `EateryStore` parameter.

---

### L2 — No provider lifecycle management [LOW]

**File:** `cart.provider.dart`

`cartProvider` is a plain `NotifierProvider` with no `ref.onDispose` cleanup. While session persistence is desired, there's no way to verify cleanup works correctly when providers are disposed.

**Fix:** Add `ref.onDispose` for any timers or listeners.

---

### L3 — Legacy EateryDatabase wrapper [LOW]

**File:** `database.provider.dart`

`appDatabaseProvider` provides an `EateryDatabase` compatibility wrapper that maps to the native store. It exists for legacy pages that haven't been migrated to direct store usage.

**Fix:** Phase out after core extraction confirms all pages use `eateryStoreProvider` directly.

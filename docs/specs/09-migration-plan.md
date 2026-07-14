# Specs 09 — Migration Plan

## Phase 0 — Core Extraction (Estimated: 2–3 weeks)

### Step 0.1: Create monorepo scaffold

```bash
mkdir -p apps/eatery_admin packages/eatery_core
```

### Step 0.2: Create package structure

```bash
cd packages/eatery_core
flutter create --template=package .
```

### Step 0.3: Move files into eatery_core

Move (not copy) — maintain git history:

| Source | Destination |
|--------|-------------|
| `lib/data/models/` → | `packages/eatery_core/lib/data/models/` |
| `lib/data/dtos/` → | `packages/eatery_core/lib/data/dtos/` |
| `lib/data/repositories/` (interfaces + SQLite impls) → | `packages/eatery_core/lib/data/repositories/` |
| `lib/data/database/native/` (EateryStore, schema, config) → | `packages/eatery_core/lib/data/database/native/` |
| `lib/data/sync/` → | `packages/eatery_core/lib/data/sync/` |
| `lib/core/theme/` → | `packages/eatery_core/lib/core/theme/` |
| `lib/core/widgets/` (shared) → | `packages/eatery_core/lib/core/widgets/` |
| `lib/core/extensions/` → | `packages/eatery_core/lib/core/extensions/` |
| `lib/core/utils/` (device_id, responsive) → | `packages/eatery_core/lib/core/utils/` |
| `lib/functions/` → | `packages/eatery_core/lib/functions/` |
| `lib/presentation/providers/` → | `packages/eatery_core/lib/presentation/providers/` |
| `lib/references.dart` → | `packages/eatery_core/lib/eatery_core.dart` |
| `assets/db/schema.sql` → | `packages/eatery_core/assets/db/schema.sql` |

### Step 0.4: Keep in Admin app

Files that stay in `apps/eatery_admin/lib/`:

| Path | Reason |
|------|--------|
| `main.dart` | App entry |
| `pages/` | All UI pages (Admin-specific) |
| `components/` | UI components |
| `data/database/eatery_database.dart` | Legacy compatibility wrapper |
| `data/database/eatery_db_shim.dart` | Hive stub |
| `services/` | Printing, cloud, utility (may migrate later) |
| `support/bluetooth_thermal_printer/` | Printer driver |
| `widgets/` | Admin-specific widgets |

### Step 0.5: Update imports

```dart
// Before:
import 'package:eatery/data/models/order.dart';
import 'package:eatery/core/widgets/app_button.dart';

// After:
import 'package:eatery_core/data/models/order.dart';
import 'package:eatery_core/core/widgets/app_button.dart';
```

### Step 0.6: Deps & pubspec

- Add `eatery_core` as path dependency in `apps/eatery_admin/pubspec.yaml`
- Move shared deps to `packages/eatery_core/pubspec.yaml`

### Step 0.7: Verify

```bash
cd apps/eatery_admin && flutter run
# Test all existing flows
```

---

## Phase 1 — Role-Based Auth (Estimated: 2 weeks)

### Step 1.1: Schema migration

```sql
ALTER TABLE staff ADD COLUMN pin TEXT;
ALTER TABLE staff ADD COLUMN current_dining_table_id INTEGER;
ALTER TABLE orders ADD COLUMN staff_id INTEGER;
ALTER TABLE orders ADD COLUMN dining_table_id INTEGER;
ALTER TABLE dining_table ADD COLUMN staff_id INTEGER;
ALTER TABLE dining_table ADD COLUMN pos_x INTEGER;
ALTER TABLE dining_table ADD COLUMN pos_y INTEGER;
```

### Step 1.2: Update Staff model

- Add `pin` field (String?)
- Add `currentDiningTableId` field (int?)
- Update `toMap()/fromMap()`

### Step 1.3: Create `AuthSession` provider

- Implement `AuthSessionNotifier` (sealed class)
- Add `login()`, `logout()` methods

### Step 1.4: Rewrite LoginPage

- Query staff by phone/name
- Verify PIN against `Staff.pin`
- Set `AuthSession` on success

### Step 1.5: Add route guards

- GoRouter `redirect` checks auth state
- Route permission map

### Step 1.6: LogoutPage

- Clear `AuthSession`
- Navigate to `/login`, replace all routes

### Step 1.7: Reset PIN page

- Implement full flow

### Step 1.8: Update Order creation

- `staffId` set automatically from `AuthSession`
- `diningTableId` set from `PosSession`

### Step 1.9: Admin PIN migration

- Copy `Company.password` → new admin `Staff` entry

---

## Phase 2 — Order Status (Estimated: 1 week)

### Step 2.1: Schema

```sql
CREATE TABLE order_status_history (...);
```

### Step 2.2: Create enums + models

- `OrderStatus`
- `OrderStatusTransition`

### Step 2.3: Repository updates

- `updateStatus()` with validation
- Status history recording
- OpLog commit on status change

### Step 2.4: POS updates

- Set initial status to `pending`
- Wire KDS status updates

### Step 2.5: ViewOrderPage updates

- Show current status
- Show status history timeline

---

## Phase 3 — Sync Transport (Estimated: 2–3 weeks)

### Step 3.1: Implement WebSocket in SyncService

```dart
class SyncService {
  WebSocket? _socket;

  void _sendMessage(SyncMessage message) {
    _socket?.send(jsonEncode(message.toJson()));
  }

  void _onMessage(String data) {
    final msg = SyncMessage.fromJson(jsonDecode(data));
    switch (msg.type) {
      case 'oplog_push': receiveEntries(msg.entries);
      case 'oplog_pull': _respondPull(msg.sinceClock);
      case 'host_announce': receiveHostAnnounce(msg);
      case 'heartbeat': receiveHeartbeat(msg.clock);
      case 'host_vote': _handleVote(msg);
      case 'host_claim': _handleClaim(msg);
      case 'ack': receiveAck(msg.lastAppliedClock);
    }
  }
}
```

### Step 3.2: Admin as WebSocket server

```dart
class SyncHostServer {
  HttpServer? _server;

  Future<void> start(int port) async {
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    await for (final request in _server!) {
      if (request.uri.path == '/sync') {
        final ws = await WebSocketTransformer.upgrade(request);
        _handleConnection(ws);
      }
    }
  }
}
```

### Step 3.3: Wire OpLog to repositories

- Inject `OpLogService` into every `Sqlite*Repository`
- Commit on every `create`, `update`, `delete`, status change

### Step 3.4: Discovery

- Implement mDNS via `multicast_dns` package
- Manual IP fallback

### Step 3.5: Sync status UI

- Dashboard shows: role (host/leaf/standalone), connected devices, last sync time

---

## Phase 4–8

See [PRD 03 — Features by Phase](/docs/prd/03-features-by-phase.md) for detailed scope of each phase. Estimated total: 12–16 weeks for all 8 phases.

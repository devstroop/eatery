# Specs 06 — Repositories

## 1. Current Issues

| # | Issue | Impact |
|---|-------|--------|
| R1 | Mix of sync and async methods on same interface | Callers don't know if a method blocks |
| R2 | `getAll*()` loads entire table — no pagination | Performance degradation with scale |
| R3 | No OpLog integration | Sync layer is disconnected |
| R4 | `DiningTableRepository` interface is incomplete | `getAllCategories()` not declared, only on impl |
| R5 | `OrderFunction` stores global static store ref | Breaks DI and testability |

## 2. Target Repository Pattern

### Interface

```dart
/// Base CRUD operations.
abstract class Repository<T> {
  T? getById(int id);
  List<T> getAll({int? limit, int? offset});
  Future<int> save(T entity);   // INSERT or UPDATE
  Future<void> delete(int id);
}
```

### OrderRepository (Target)

```dart
abstract class OrderRepository {
  // Queries — all synchronous (local SQLite)
  Order? getById(int id);
  List<Order> getAll({int? limit, int? offset, OrderStatus? status, DateTime? from, DateTime? to});
  List<Order> getByStaffId(int staffId);
  List<Order> getByTableId(int diningTableId);
  List<OrderProduct> getOrderProducts(int orderId);

  // Commands — all async, all commit to OpLog
  Future<int> create(Order order, {int? staffId});
  Future<void> update(Order order);
  Future<void> updateStatus(int orderId, OrderStatus newStatus, int changedByStaffId);
  Future<void> voidOrder(int orderId, String reason, String voidedBy);
  Future<void> delete(int orderId);
}
```

### SqliteOrderRepository (Target)

```dart
class SqliteOrderRepository implements OrderRepository {
  final EateryStore _store;
  final OpLogService _opLog;

  SqliteOrderRepository({required EateryStore store, required OpLogService opLog})
      : _store = store, _opLog = opLog;

  @override
  List<Order> getAll({int? limit, int? offset, OrderStatus? status, DateTime? from, DateTime? to}) {
    final conditions = <String>[];
    final params = <Object?>[];

    if (status != null) {
      conditions.add('status = ?');
      params.add(status.index);
    }
    if (from != null) {
      conditions.add('createdAt >= ?');
      params.add(from.millisecondsSinceEpoch);
    }
    if (to != null) {
      conditions.add('createdAt <= ?');
      params.add(to.millisecondsSinceEpoch);
    }

    final where = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';
    final limitClause = limit != null ? 'LIMIT $limit' : '';
    final offsetClause = offset != null ? 'OFFSET $offset' : '';

    return _store.query('SELECT * FROM orders $where ORDER BY createdAt DESC $limitClause $offsetClause', params)
        .map(Order.fromMap)
        .toList();
  }

  @override
  Future<int> create(Order order, {int? staffId}) async {
    // 1. Set staffId
    order.staffId = staffId;

    // 2. Set initial status
    order.status = OrderStatus.pending;

    // 3. Insert
    _store.execute('INSERT INTO orders (...) VALUES (...)');
    final id = _store.queryScalar('SELECT last_insert_rowid()') as int;

    // 4. Record status history
    _store.execute(
      'INSERT INTO order_status_history (order_id, from_status, to_status, changed_by_staff_id, changed_at) VALUES (?,?,?,?,?)',
      [id, OrderStatus.pending.index, OrderStatus.pending.index, staffId, DateTime.now().millisecondsSinceEpoch],
    );

    // 5. OpLog commit
    _opLog.commit(
      entityType: 'order',
      entityId: id,
      operation: 'create',
      data: { ...order.toMap(), 'id': id },
      metadata: {'staffId': staffId},
    );

    return id;
  }

  @override
  Future<void> updateStatus(int orderId, OrderStatus newStatus, int changedByStaffId) async {
    final prev = getById(orderId);
    if (prev == null) return;

    // Validate transition
    if (!_isValidTransition(prev.status, newStatus)) {
      throw ArgumentError('Invalid status transition: ${prev.status} → $newStatus');
    }

    // Update order
    _store.execute('UPDATE orders SET status = ?, updatedAt = ? WHERE id = ?', [
      newStatus.index, DateTime.now().millisecondsSinceEpoch, orderId,
    ]);

    // Record history
    _store.execute(
      'INSERT INTO order_status_history (order_id, from_status, to_status, changed_by_staff_id, changed_at) VALUES (?,?,?,?,?)',
      [orderId, prev.status.index, newStatus.index, changedByStaffId, DateTime.now().millisecondsSinceEpoch],
    );

    // OpLog commit
    _opLog.commit(
      entityType: 'order',
      entityId: orderId,
      operation: 'status_change',
      data: {'status': newStatus.index},
      prevData: {'status': prev.status.index},
      metadata: {'staffId': changedByStaffId},
    );
  }

  bool _isValidTransition(OrderStatus from, OrderStatus to) {
    switch (from) {
      case OrderStatus.pending: return to == OrderStatus.preparing || to == OrderStatus.voided;
      case OrderStatus.preparing: return to == OrderStatus.ready || to == OrderStatus.voided;
      case OrderStatus.ready: return to == OrderStatus.served;
      case OrderStatus.served: return to == OrderStatus.completed;
      case OrderStatus.completed: return false;  // terminal state
      case OrderStatus.voided: return false;     // terminal state
    }
  }
}
```

## 3. DiningTableRepository (Target)

```dart
abstract class DiningTableRepository {
  // Tables
  List<DiningTable> getAllTables({DiningTableStatus? status, int? staffId});
  DiningTable? getById(int id);
  List<DiningTable> getByStaffId(int staffId);
  Future<int> save(DiningTable table);
  Future<void> delete(int id);

  // Categories (now part of the interface)
  List<DiningTableCategory> getAllCategories();
  DiningTableCategory? getCategoryById(int id);
  Future<int> saveCategory(DiningTableCategory category);
  Future<void> deleteCategory(int id);
}
```

## 4. Repository Initialization

```dart
// In provider setup:
final opLogServiceProvider = Provider<OpLogService>((ref) {
  final store = ref.read(eateryStoreProvider);
  return OpLogService(store: store, deviceId: getDeviceId());
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final store = ref.read(eateryStoreProvider);
  final opLog = ref.read(opLogServiceProvider);
  return SqliteOrderRepository(store: store, opLog: opLog);
});
```

## 5. OpLog Integration Checklist

Every repository must commit to OpLog for these operations:

| Repository | Create | Update | Delete | Status Change | Notes |
|------------|--------|--------|--------|---------------|-------|
| OrderRepository | ✓ | ✓ | ✓ | ✓ | Most important for sync |
| ProductRepository | ✓ | ✓ | ✓ | — | |
| DiningTableRepository | ✓ | ✓ | ✓ | — | Status change (occupied/available) |
| StaffRepository | ✓ | ✓ | ✓ | — | |
| CustomerRepository | ✓ | ✓ | ✓ | — | |
| PaymentRepository | ✓ | — | — | — | Payments are append-only |
| CompanyRepository | ✓ | ✓ | — | — | Singleton |

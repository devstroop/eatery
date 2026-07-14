import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/order_repository.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';

import '../database/native/eatery_store.dart';

/// SQLite-backed implementation of [OrderRepository], powered by the native
/// libeaterystore (Zig + embedded SQLite) over dart:ffi.
///
/// Demonstrates a foreign-key relationship: `order_product.orderId` references
/// `orders.id` with `ON DELETE CASCADE`, so [deleteOrder] removes an order's
/// line items in a single statement. Implements the same public surface as the
/// Hive-backed [OrderRepository], swapped in behind `orderRepositoryProvider`.
class SqliteOrderRepository implements OrderRepository {
  SqliteOrderRepository({required EateryStore store}) : _store = store;

  final EateryStore _store;

  static const _orderColumns =
      'customerPhone, createdAt, updatedAt, totalQuantity, subTotal, '
      'discountTotal, taxTotal, finalTotal, roundOff, grandTotal, paidTotal, '
      'type, status, voidReason, voidedBy, voidedAt, staffId';

  static const _orderProductColumns =
      'orderId, productId, productName, quantity, price, subTotal, '
      'discountRate, discountAmount, taxRate, taxAmount, total, stationId, '
      'stationName';

  // ---------------------------------------------------------------------------
  // Orders
  // ---------------------------------------------------------------------------

  @override
  List<Order> getAllOrders() =>
      _store.query('SELECT * FROM orders LIMIT 100').map(Order.fromMap).toList();

  @override
  List<Order> getOrdersPage(int limit, int offset) =>
      _store.query('SELECT * FROM orders ORDER BY id DESC LIMIT ? OFFSET ?', [limit, offset])
          .map(Order.fromMap).toList();

  @override
  int getOrderCount() =>
      (_store.queryScalar('SELECT COUNT(*) FROM orders') as int?) ?? 0;

  @override
  @override
  Order? getOrderById(int id) {
    final rows = _store.query('SELECT * FROM orders WHERE id = ?', [id]);
    return rows.isEmpty ? null : Order.fromMap(rows.first);
  }

  @override
  Future<int> saveOrder(Order order) async {
    final m = order.toMap();
    final values = <Object?>[
      m['customerPhone'],
      m['createdAt'],
      m['updatedAt'],
      m['totalQuantity'],
      m['subTotal'],
      m['discountTotal'],
      m['taxTotal'],
      m['finalTotal'],
      m['roundOff'],
      m['grandTotal'],
      m['paidTotal'],
      m['type'],
      m['status'],
      m['voidReason'],
      m['voidedBy'],
      m['voidedAt'],
      m['staffId'],
    ];

    final int id;
    if (order.id != null && _exists('orders', order.id!)) {
      id = order.id!;
      _store.execute(
        'UPDATE orders SET '
        'customerPhone=?, createdAt=?, updatedAt=?, totalQuantity=?, '
        'subTotal=?, discountTotal=?, taxTotal=?, finalTotal=?, roundOff=?, '
        'grandTotal=?, paidTotal=?, type=?, status=?, voidReason=?, '
        'voidedBy=?, voidedAt=?, staffId=? WHERE id=?',
        [...values, id],
      );
    } else {
      _store.execute(
        'INSERT INTO orders ($_orderColumns) '
        'VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        values,
      );
      id = _store.queryScalar('SELECT last_insert_rowid()') as int;
    }
    notifyMutation('order', id, 'save', order.toMap());
    return id;
  }

  @override
  Future<void> deleteOrder(Order order) async {
    if (order.id == null) return;
    // order_product rows cascade-delete via the foreign key.
    _store.execute('DELETE FROM orders WHERE id = ?', [order.id]);
    notifyMutation('order', order.id!, 'delete', {'id': order.id});
  }

  // ---------------------------------------------------------------------------
  // Order status history
  // ---------------------------------------------------------------------------

  @override
  List<OrderStatusHistory> getStatusHistory(int orderId) => _store
      .query(
        'SELECT * FROM order_status_history WHERE orderId = ? ORDER BY changedAt',
        [orderId],
      )
      .map(OrderStatusHistory.fromMap)
      .toList();

  @override
  Future<void> recordStatusTransition(OrderStatusHistory transition) async {
    final m = transition.toMap();
    _store.execute('''
      INSERT INTO order_status_history (orderId, fromStatus, toStatus,
        changedByStaffId, changedAt, reason)
      VALUES (?,?,?,?,?,?)
    ''', [
      m['orderId'],
      m['fromStatus'],
      m['toStatus'],
      m['changedByStaffId'],
      m['changedAt'],
      m['reason'],
    ]);
  }

  // ---------------------------------------------------------------------------
  // Order products (line items)
  // ---------------------------------------------------------------------------

  @override
  List<OrderProduct> getOrderProducts(int orderId) => _store
      .query('SELECT * FROM order_product WHERE orderId = ?', [orderId])
      .map(OrderProduct.fromMap)
      .toList();

  @override
  Future<int> addOrderProduct(OrderProduct op) async {
    final id = _insertOrderProduct(op);
    op = op.copyWith(id: id);
    notifyMutation('order_product', id, 'save', op.toMap());
    return id;
  }

  @override
  Future<void> saveOrderProduct(OrderProduct op) async {
    final int id;
    if (op.id != null && _exists('order_product', op.id!)) {
      id = op.id!;
      final v = _orderProductValues(op);
      _store.execute(
        'UPDATE order_product SET '
        'orderId=?, productId=?, productName=?, quantity=?, price=?, '
        'subTotal=?, discountRate=?, discountAmount=?, taxRate=?, taxAmount=?, '
        'total=?, stationId=?, stationName=? WHERE id=?',
        [...v, id],
      );
    } else {
      id = _insertOrderProduct(op);
    }
    notifyMutation('order_product', id, 'save', op.toMap());
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  int _insertOrderProduct(OrderProduct op) {
    _store.execute(
      'INSERT INTO order_product ($_orderProductColumns) '
      'VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
      _orderProductValues(op),
    );
    return _store.queryScalar('SELECT last_insert_rowid()') as int;
  }

  List<Object?> _orderProductValues(OrderProduct op) {
    final m = op.toMap();
    return <Object?>[
      m['orderId'],
      m['productId'],
      m['productName'],
      m['quantity'],
      m['price'],
      m['subTotal'],
      m['discountRate'],
      m['discountAmount'],
      m['taxRate'],
      m['taxAmount'],
      m['total'],
      m['stationId'],
      m['stationName'],
    ];
  }

  bool _exists(String table, int id) =>
      _store.queryScalar('SELECT 1 FROM $table WHERE id = ?', [id]) != null;
}

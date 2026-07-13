import 'package:eatery_core/data/database/eatery_database.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/customer_repository.dart';

import '../database/native/eatery_store.dart';

/// SQLite-backed implementation of [CustomerRepository], powered by the native
/// libeaterystore (Zig + embedded SQLite) over dart:ffi.
///
/// Implements the same public surface as the Hive-backed [CustomerRepository]
/// so it can be swapped in behind `customerRepositoryProvider` without touching
/// any UI code.
///
/// Note on incremental migration: [getOutstandingAmount] aggregates over Orders
/// and Payments, which are still Hive-backed during the spike. That method
/// therefore continues to read from [EateryDatabase] while pure-customer
/// operations go through the SQLite [EateryStore]. This is representative of
/// how a real, entity-by-entity migration behaves.
class SqliteCustomerRepository implements CustomerRepository {
  SqliteCustomerRepository({
    required EateryStore store,
    required EateryDatabase db,
  }) : _store = store,
       _db = db;

  final EateryStore _store;
  final EateryDatabase _db;

  static const _columns =
      'name, phone, address, landmark, latitude, longitude, isActive, '
      'lastOrderAt';

  @override
  List<Customer> getAllCustomers() =>
      _store.query('SELECT * FROM customer').map(Customer.fromMap).toList();

  @override
  Customer? getCustomerByPhone(String phone) {
    final rows = _store.query(
      'SELECT * FROM customer WHERE phone = ? LIMIT 1',
      [phone],
    );
    return rows.isEmpty ? null : Customer.fromMap(rows.first);
  }

  @override
  Future<int> saveCustomer(Customer customer) async {
    final m = customer.toMap();
    final values = <Object?>[
      m['name'],
      m['phone'],
      m['address'],
      m['landmark'],
      m['latitude'],
      m['longitude'],
      m['isActive'],
      m['lastOrderAt'],
    ];

    if (customer.id != null && _exists(customer.id!)) {
      _store.execute(
        'UPDATE customer SET '
        'name=?, phone=?, address=?, landmark=?, latitude=?, longitude=?, '
        'isActive=?, lastOrderAt=? WHERE id=?',
        [...values, customer.id],
      );
      return customer.id!;
    }

    _store.execute(
      'INSERT INTO customer ($_columns) VALUES (?,?,?,?,?,?,?,?)',
      values,
    );
    final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
    customer.id = id;
    return id;
  }

  /// Outstanding amount computed via an aggregate SQL query on the orders and
  /// payment tables in the native store.
  @override
  double getOutstandingAmount(String phone) {
    final result = _store.queryScalar(
      '''
      SELECT COALESCE(SUM(o.grandTotal - COALESCE(p.paid, 0)), 0)
      FROM orders o
      LEFT JOIN (
        SELECT orderId, SUM(amount) AS paid FROM payment GROUP BY orderId
      ) p ON p.orderId = o.id
      WHERE o.customerPhone = ?
    ''',
      [phone],
    );
    return (result as num?)?.toDouble() ?? 0.0;
  }

  bool _exists(int id) =>
      _store.queryScalar('SELECT 1 FROM customer WHERE id = ?', [id]) != null;
}

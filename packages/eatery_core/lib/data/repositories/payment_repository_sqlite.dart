import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/payment_repository.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';

import '../database/native/eatery_store.dart';

/// SQLite-backed implementation of [PaymentRepository], powered by the native
/// libeaterystore (Zig + embedded SQLite) over dart:ffi.
class SqlitePaymentRepository implements PaymentRepository {
  SqlitePaymentRepository({required EateryStore store}) : _store = store;

  final EateryStore _store;

  static const _columns =
      'orderId, date, amount, mode, reference, attachment, '
      'processorTransactionId, processorName, processorStatus, '
      'cardLastFour, terminalId';

  @override
  List<Payment> getAllPayments() =>
      _store.query('SELECT * FROM payment').map(Payment.fromMap).toList();

  @override
  List<Payment> getPaymentsByOrder(int orderId) => _store
      .query('SELECT * FROM payment WHERE orderId = ?', [orderId])
      .map(Payment.fromMap)
      .toList();

  @override
  Future<int> savePayment(Payment payment) async {
    final m = payment.toMap();
    final values = <Object?>[
      m['orderId'],
      m['date'],
      m['amount'],
      m['mode'],
      m['reference'],
      m['attachment'],
      m['processorTransactionId'],
      m['processorName'],
      m['processorStatus'],
      m['cardLastFour'],
      m['terminalId'],
    ];

    final int id;
    if (payment.id != null && _exists(payment.id!)) {
      id = payment.id!;
      _store.execute(
        'UPDATE payment SET orderId=?, date=?, amount=?, mode=?, reference=?, '
        'attachment=?, processorTransactionId=?, processorName=?, '
        'processorStatus=?, cardLastFour=?, terminalId=? WHERE id=?',
        [...values, id],
      );
    } else {
      _store.execute(
        'INSERT INTO payment ($_columns) VALUES (?,?,?,?,?,?,?,?,?,?,?)',
        values,
      );
      id = _store.queryScalar('SELECT last_insert_rowid()') as int;
      payment = payment.copyWith(id: id);
    }
    notifyMutation('payment', id, 'save', payment.toMap());
    return id;
  }

  bool _exists(int id) =>
      _store.queryScalar('SELECT 1 FROM payment WHERE id = ?', [id]) != null;
}

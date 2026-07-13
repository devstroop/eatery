import 'package:eatery/data/models/eatery_db.dart';
import '../database/native/eatery_store.dart';
import 'subscription_repository.dart';

/// SQLite-backed implementation of [SubscriptionRepository].
class SqliteSubscriptionRepository implements SubscriptionRepository {
  SqliteSubscriptionRepository({required EateryStore store}) : _store = store;
  final EateryStore _store;

  static const _columns =
      'purchaseCode, validFrom, validTill, subscriptionType';

  @override
  Subscription? getFirst() {
    final rows = _store.query('SELECT * FROM subscription LIMIT 1');
    if (rows.isEmpty) return null;
    return _toSub(rows.first);
  }

  @override
  Future<int> save(Subscription sub) async {
    final values = <Object?>[
      sub.purchaseCode,
      sub.validFrom?.millisecondsSinceEpoch,
      sub.validTill?.millisecondsSinceEpoch,
      sub.subscriptionType?.id,
    ];

    if (sub.id != null && _exists(sub.id!)) {
      _store.execute(
        'UPDATE subscription SET purchaseCode=?, validFrom=?, validTill=?, '
        'subscriptionType=? WHERE id=?',
        [...values, sub.id],
      );
      return sub.id!;
    }

    _store.execute(
      'INSERT INTO subscription ($_columns) VALUES (?,?,?,?)',
      values,
    );
    final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
    sub.id = id;
    return id;
  }

  @override
  Future<void> clearAll() async => _store.execute('DELETE FROM subscription');

  Subscription _toSub(Map<String, Object?> row) {
    SubscriptionType? st;
    final stId = row['subscriptionType'] as int?;
    if (stId != null) {
      st = SubscriptionType.values.firstWhere(
        (e) => e.id == stId,
        orElse: () => SubscriptionType.individual,
      );
    }
    return Subscription(
      purchaseCode: row['purchaseCode'] as String?,
      validFrom: row['validFrom'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['validFrom'] as int)
          : null,
      validTill: row['validTill'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['validTill'] as int)
          : null,
      subscriptionType: st,
    )..id = row['id'] as int;
  }

  bool _exists(int id) =>
      _store.queryScalar('SELECT 1 FROM subscription WHERE id = ?', [id]) !=
      null;
}

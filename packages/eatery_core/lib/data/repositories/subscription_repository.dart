import 'package:eatery_core/data/models/eatery_db.dart';
import '../database/native/eatery_store.dart';
class SubscriptionRepository {
  SubscriptionRepository({required EateryStore store}) : _db = store;
  final EateryStore _db;
  Subscription? getFirst() {
    final r = _db.query('SELECT * FROM subscription LIMIT 1');
    return r.isEmpty ? null : _toSub(r.first);
  }
  Future<int> save(Subscription sub) async {
    final v = [sub.purchaseCode, sub.validFrom?.millisecondsSinceEpoch, sub.validTill?.millisecondsSinceEpoch, sub.subscriptionType?.id];
    if (sub.id != null) {
      _db.execute('UPDATE subscription SET purchaseCode=?,validFrom=?,validTill=?,subscriptionType=? WHERE id=?', [...v, sub.id]);
      return sub.id!;
    }
    _db.execute('INSERT INTO subscription (purchaseCode,validFrom,validTill,subscriptionType) VALUES (?,?,?,?)', v);
    final id = _db.queryScalar('SELECT last_insert_rowid()') as int;
    sub.id = id; return id;
  }
  Future<void> clearAll() async => _db.execute('DELETE FROM subscription');
  Subscription _toSub(Map<String, Object?> r) {
    SubscriptionType? st; final stId = r['subscriptionType'] as int?;
    if (stId != null) st = SubscriptionType.values.firstWhere((e) => e.id == stId, orElse: () => SubscriptionType.individual);
    return Subscription(purchaseCode: r['purchaseCode'] as String?, validFrom: r['validFrom'] != null ? DateTime.fromMillisecondsSinceEpoch(r['validFrom'] as int) : null, validTill: r['validTill'] != null ? DateTime.fromMillisecondsSinceEpoch(r['validTill'] as int) : null, subscriptionType: st)..id = r['id'] as int;
  }
}

import 'package:eatery_core/data/models/eatery_db.dart'; import 'package:eatery_core/data/database/native/eatery_store.dart';
class LoyaltyRepository {
  final EateryStore _store; LoyaltyRepository(this._store);

  CustomerLoyalty? getByCustomer(int customerId) {
    final rows = _store.query('SELECT * FROM customer_loyalty WHERE customerId = ? LIMIT 1', [customerId]);
    return rows.isEmpty ? null : CustomerLoyalty.fromMap(rows.first);
  }

  void recordVisit(int customerId, double spent) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existing = getByCustomer(customerId);
    if (existing != null) {
      final pts = existing.points + (spent * 0.1); // 10% back as points
      _store.execute('UPDATE customer_loyalty SET points = ?, totalVisits = totalVisits + 1, totalSpent = totalSpent + ?, lastVisitAt = ?, updatedAt = ? WHERE id = ?',
        [pts, spent, now, now, existing.id]);
      _store.execute('INSERT INTO loyalty_transaction (customerId, points, type, referenceId, description, createdAt) VALUES (?,?,?,?,?,?)',
        [customerId, spent * 0.1, 0, null, 'Points earned from order', now]);
    } else {
      final pts = spent * 0.1;
      _store.execute('INSERT INTO customer_loyalty (customerId, points, totalVisits, totalSpent, lastVisitAt, tier, createdAt, updatedAt) VALUES (?,?,1,?,?,0,?,?)',
        [customerId, pts, spent, now, now, now]);
      _store.execute('INSERT INTO loyalty_transaction (customerId, points, type, referenceId, description, createdAt) VALUES (?,?,?,?,?,?)',
        [customerId, pts, 0, null, 'Points earned from first order', now]);
    }
  }

  void redeemPoints(int customerId, double points, String description) {
    final loyalty = getByCustomer(customerId);
    if (loyalty == null || loyalty.points < points) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    _store.execute('UPDATE customer_loyalty SET points = points - ?, updatedAt = ? WHERE id = ?', [points, now, loyalty.id]);
    _store.execute('INSERT INTO loyalty_transaction (customerId, points, type, referenceId, description, createdAt) VALUES (?,?,?,?,?,?)',
      [customerId, -points, 1, null, description, now]);
  }
}

import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/database/eatery_database.dart';

/// Repository for [Subscription] operations.
class SubscriptionRepository {
  SubscriptionRepository({required EateryDatabase db}) : _db = db;
  final EateryDatabase _db;

  Subscription? getFirst() {
    if (_db.subscriptionBox.values.isEmpty) return null;
    return _db.subscriptionBox.values.first;
  }

  Future<int> save(Subscription sub) async {
    if (sub.id != null && _db.subscriptionBox.containsKey(sub.id)) {
      await sub.save();
      return sub.id!;
    }
    return await _db.subscriptionBox.add(sub);
  }

  Future<void> clearAll() => _db.subscriptionBox.clear();
}

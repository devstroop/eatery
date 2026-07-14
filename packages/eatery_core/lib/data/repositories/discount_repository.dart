import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';

class DiscountRepository {
  final EateryStore _store;
  DiscountRepository(this._store);

  List<Discount> getAllDiscounts() =>
      _store.query('SELECT * FROM discount ORDER BY name').map(Discount.fromMap).toList();

  Future<int> saveDiscount(Discount d) async {
    final m = d.toMap();
    if (d.id != null) {
      _store.execute('UPDATE discount SET name=?,type=?,value=?,minOrder=?,maxUses=?,isActive=?,startsAt=?,endsAt=?,updatedAt=? WHERE id=?',
        [m['name'], m['type'], m['value'], m['minOrder'], m['maxUses'], m['isActive'], m['startsAt'], m['endsAt'], m['updatedAt'], d.id]);
      return d.id!;
    }
    _store.execute('INSERT INTO discount (name,type,value,minOrder,maxUses,isActive,startsAt,endsAt,createdAt,updatedAt) VALUES (?,?,?,?,?,?,?,?,?,?)',
      [m['name'], m['type'], m['value'], m['minOrder'], m['maxUses'], m['isActive'], m['startsAt'], m['endsAt'], m['createdAt'], m['updatedAt']]);
    final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
    notifyMutation('discount', id, 'save', d.copyWith(id: id).toMap());
    return id;
  }

  Future<void> deleteDiscount(int id) async {
    _store.execute('DELETE FROM discount WHERE id = ?', [id]);
    notifyMutation('discount', id, 'delete', {'id': id});
  }

  Future<void> applyDiscount(OrderDiscount od) async {
    final m = od.toMap();
    _store.execute('INSERT INTO order_discount (orderId,discountId,name,type,value,amount,appliedBy,createdAt) VALUES (?,?,?,?,?,?,?,?)',
      [m['orderId'], m['discountId'], m['name'], m['type'], m['value'], m['amount'], m['appliedBy'], m['createdAt']]);
    _store.execute('UPDATE orders SET discountTotal = COALESCE(discountTotal, 0) + ? WHERE id = ?', [od.amount, od.orderId]);
  }
}

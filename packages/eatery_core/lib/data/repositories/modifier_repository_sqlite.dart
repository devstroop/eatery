import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/modifier_repository.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';
import '../database/native/eatery_store.dart';

class SqliteModifierRepository implements ModifierRepository {
  final EateryStore _store;
  SqliteModifierRepository({required EateryStore store}) : _store = store;

  @override
  List<ModifierGroup> getAllGroups() =>
      _store.query('SELECT * FROM modifier_group ORDER BY sortOrder')
          .map(ModifierGroup.fromMap).toList();

  @override
  ModifierGroup? getGroupById(int id) {
    final rows = _store.query('SELECT * FROM modifier_group WHERE id = ?', [id]);
    return rows.isEmpty ? null : ModifierGroup.fromMap(rows.first);
  }

  @override
  Future<int> saveGroup(ModifierGroup group) async {
    final m = group.toMap();
    if (group.id != null) {
      _store.execute(
        'UPDATE modifier_group SET name=?,description=?,minSelect=?,maxSelect=?,'
        'sortOrder=?,isRequired=?,updatedAt=? WHERE id=?',
        [m['name'], m['description'], m['minSelect'], m['maxSelect'],
         m['sortOrder'], m['isRequired'], m['updatedAt'], group.id],
      );
      return group.id!;
    }
    _store.execute(
      'INSERT INTO modifier_group (name,description,minSelect,maxSelect,'
      'sortOrder,isRequired,createdAt,updatedAt) VALUES (?,?,?,?,?,?,?,?)',
      [m['name'], m['description'], m['minSelect'], m['maxSelect'],
       m['sortOrder'], m['isRequired'], m['createdAt'], m['updatedAt']],
    );
    final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
    notifyMutation('modifier_group', id, 'save', group.copyWith(id: id).toMap());
    return id;
  }

  @override
  Future<void> deleteGroup(int id) async {
    _store.execute('DELETE FROM modifier_group WHERE id = ?', [id]);
    notifyMutation('modifier_group', id, 'delete', {'id': id});
  }

  @override
  List<Modifier> getModifiers(int groupId) =>
      _store.query('SELECT * FROM modifier WHERE modifierGroupId = ? ORDER BY sortOrder', [groupId])
          .map(Modifier.fromMap).toList();

  @override
  Modifier? getModifierById(int id) {
    final rows = _store.query('SELECT * FROM modifier WHERE id = ?', [id]);
    return rows.isEmpty ? null : Modifier.fromMap(rows.first);
  }

  @override
  Future<int> saveModifier(Modifier modifier) async {
    final m = modifier.toMap();
    if (modifier.id != null) {
      _store.execute(
        'UPDATE modifier SET modifierGroupId=?,name=?,priceAdjust=?,'
        'sortOrder=?,isDefault=?,updatedAt=? WHERE id=?',
        [m['modifierGroupId'], m['name'], m['priceAdjust'],
         m['sortOrder'], m['isDefault'], m['updatedAt'], modifier.id],
      );
      return modifier.id!;
    }
    _store.execute(
      'INSERT INTO modifier (modifierGroupId,name,priceAdjust,sortOrder,'
      'isDefault,createdAt,updatedAt) VALUES (?,?,?,?,?,?,?)',
      [m['modifierGroupId'], m['name'], m['priceAdjust'],
       m['sortOrder'], m['isDefault'], m['createdAt'], m['updatedAt']],
    );
    final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
    notifyMutation('modifier', id, 'save', modifier.copyWith(id: id).toMap());
    return id;
  }

  @override
  Future<void> deleteModifier(int id) async {
    _store.execute('DELETE FROM modifier WHERE id = ?', [id]);
    notifyMutation('modifier', id, 'delete', {'id': id});
  }

  @override
  List<ModifierGroup> getGroupsForProduct(int productId) =>
      _store.query(
        'SELECT mg.* FROM modifier_group mg '
        'INNER JOIN product_modifier pm ON pm.modifierGroupId = mg.id '
        'WHERE pm.productId = ? ORDER BY mg.sortOrder',
        [productId],
      ).map(ModifierGroup.fromMap).toList();

  @override
  Future<void> setProductGroups(int productId, List<int> groupIds) async {
    _store.execute('DELETE FROM product_modifier WHERE productId = ?', [productId]);
    for (final gid in groupIds) {
      _store.execute(
        'INSERT INTO product_modifier (productId, modifierGroupId) VALUES (?,?)',
        [productId, gid],
      );
    }
  }
}

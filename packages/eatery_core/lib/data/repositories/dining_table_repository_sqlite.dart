import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/dining_table_repository.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';

import '../database/native/eatery_store.dart';

/// SQLite-backed implementation of [DiningTableRepository], powered by the
/// native libeaterystore (Zig + embedded SQLite) over dart:ffi.
///
/// Covers DiningTable + DiningTableCategory.
/// Note: the model's `DiningTable.fromMap` tries to look up category from the
/// Hive `diningTableCategoryBox`, which is empty when the SQLite swap is on.
/// This repo supplies a custom mapping that stores/retrieves `categoryId`
/// directly and leaves `category` null (it is nullable in the model).
class SqliteDiningTableRepository implements DiningTableRepository {
  SqliteDiningTableRepository({required EateryStore store}) : _store = store;

  final EateryStore _store;

  static const _tableColumns =
      'name, categoryId, description, orderId, capacity, status, customerPhone, '
      'posX, posY, shape, width, height, employeeId';
  static const _categoryColumns = 'name, description, isActive';

  // ---------------------------------------------------------------------------
  // Dining Tables
  // ---------------------------------------------------------------------------

  @override
  List<DiningTable> getAllTables() =>
      _store.query('SELECT * FROM dining_table').map(_toTable).toList();

  @override
  DiningTable? getTableById(int id) {
    final rows = _store.query('SELECT * FROM dining_table WHERE id = ?', [id]);
    return rows.isEmpty ? null : _toTable(rows.first);
  }

  @override
  DiningTable? getTableByOrderId(int orderId) {
    final rows = _store.query(
      'SELECT * FROM dining_table WHERE orderId = ? LIMIT 1',
      [orderId],
    );
    return rows.isEmpty ? null : _toTable(rows.first);
  }

  @override
  Future<void> deleteTable(int id) async {
    _store.execute('DELETE FROM dining_table WHERE id = ?', [id]);
    notifyMutation('dining_table', id, 'delete', {'id': id});
  }

  @override
  Future<void> deleteCategory(int id) async {
    _store.execute('DELETE FROM dining_table_category WHERE id = ?', [id]);
    notifyMutation('dining_table_category', id, 'delete', {'id': id});
  }

  @override
  Future<int> saveTable(DiningTable table) async {
    final values = <Object?>[
      table.name,
      table.categoryId,
      table.description,
      table.orderId,
      table.capacity,
      table.status.id,
      table.customerPhone,
      table.posX,
      table.posY,
      table.shape,
      table.width,
      table.height,
      table.employeeId,
    ];

    final int id;
    if (table.id != null && _tableExists(table.id!)) {
      id = table.id!;
      _store.execute(
        'UPDATE dining_table SET name=?, categoryId=?, description=?, '
        'orderId=?, capacity=?, status=?, customerPhone=?, '
        'posX=?, posY=?, shape=?, width=?, height=?, employeeId=? WHERE id=?',
        [...values, id],
      );
    } else {
      _store.execute(
        'INSERT INTO dining_table ($_tableColumns) '
        'VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
        values,
      );
      id = _store.queryScalar('SELECT last_insert_rowid()') as int;
      table = table.copyWith(id: id);
    }
    notifyMutation('dining_table', id, 'save', table.toMap());
    return id;
  }

  // ---------------------------------------------------------------------------
  // Table Categories
  // ---------------------------------------------------------------------------

  /// Returns all dining table categories from the SQLite store.
  /// Note: the original [DiningTableRepository] does not expose a category
  /// repository directly; these helpers exist because the SQLite schema owns
  /// both tables and pages need to render category names.
  @override
  List<DiningTableCategory> getAllCategories() => _store
      .query('SELECT * FROM dining_table_category')
      .map(DiningTableCategory.fromMap)
      .toList();

  @override
  DiningTableCategory? getCategoryById(int id) {
    final rows = _store.query(
      'SELECT * FROM dining_table_category WHERE id = ?',
      [id],
    );
    return rows.isEmpty ? null : DiningTableCategory.fromMap(rows.first);
  }

  @override
  Future<int> saveCategory(DiningTableCategory category) async {
    final values = <Object?>[
      category.name,
      category.description,
      category.isActive ? 1 : 0,
    ];

    final int id;
    if (category.id != null && _catExists(category.id!)) {
      id = category.id!;
      _store.execute(
        'UPDATE dining_table_category SET name=?, description=?, '
        'isActive=? WHERE id=?',
        [...values, id],
      );
    } else {
      _store.execute(
        'INSERT INTO dining_table_category ($_categoryColumns) '
        'VALUES (?,?,?)',
        values,
      );
      id = _store.queryScalar('SELECT last_insert_rowid()') as int;
      category = category.copyWith(id: id);
    }
    notifyMutation('dining_table_category', id, 'save', category.toMap());
    return id;
  }

  // ---------------------------------------------------------------------------
  // Mapping
  // ---------------------------------------------------------------------------

  DiningTable _toTable(Map<String, Object?> row) {
    final status = DiningTableStatus.values.firstWhere(
      (e) => e.id == (row['status'] as int),
    );
    return DiningTable(
      name: row['name'] as String,
      capacity: row['capacity'] as int? ?? 0,
      status: status,
      customerPhone: row['customerPhone'] as String?,
      description: row['description'] as String?,
      orderId: row['orderId'] as int?,
      // category is a Hive-backed object; leave null for now; the model
      // already handles nullable category and pages work without it set.
      id: row['id'] as int,
      posX: (row['posX'] as num?)?.toDouble(),
      posY: (row['posY'] as num?)?.toDouble(),
      shape: row['shape'] as int? ?? 0,
      width: (row['width'] as num?)?.toDouble(),
      height: (row['height'] as num?)?.toDouble(),
      employeeId: row['employeeId'] as int?,
    );
  }

  bool _tableExists(int id) =>
      _store.queryScalar('SELECT 1 FROM dining_table WHERE id = ?', [id]) !=
      null;

  bool _catExists(int id) =>
      _store.queryScalar('SELECT 1 FROM dining_table_category WHERE id = ?', [
        id,
      ]) !=
      null;
}

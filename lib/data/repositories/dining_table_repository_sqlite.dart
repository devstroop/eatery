import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/repositories/dining_table_repository.dart';

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
      'name, categoryId, description, orderId, capacity, status, customerPhone';
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
  Future<int> saveTable(DiningTable table) async {
    final values = <Object?>[
      table.name,
      table.category?.id,
      table.description,
      table.orderId,
      table.capacity,
      table.status.id,
      table.customerPhone,
    ];

    if (table.id != null && _tableExists(table.id!)) {
      _store.execute(
        'UPDATE dining_table SET name=?, categoryId=?, description=?, '
        'orderId=?, capacity=?, status=?, customerPhone=? WHERE id=?',
        [...values, table.id],
      );
      return table.id!;
    }

    _store.execute(
      'INSERT INTO dining_table ($_tableColumns) VALUES (?,?,?,?,?,?,?)',
      values,
    );
    final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
    table.id = id;
    return id;
  }

  // ---------------------------------------------------------------------------
  // Table Categories
  // ---------------------------------------------------------------------------

  /// Returns all dining table categories from the SQLite store.
  /// Note: the original [DiningTableRepository] does not expose a category
  /// repository directly; these helpers exist because the SQLite schema owns
  /// both tables and pages need to render category names.
  List<DiningTableCategory> getAllCategories() => _store
      .query('SELECT * FROM dining_table_category')
      .map(DiningTableCategory.fromMap)
      .toList();

  DiningTableCategory? getCategoryById(int id) {
    final rows = _store.query(
      'SELECT * FROM dining_table_category WHERE id = ?',
      [id],
    );
    return rows.isEmpty ? null : DiningTableCategory.fromMap(rows.first);
  }

  Future<int> saveCategory(DiningTableCategory category) async {
    final values = <Object?>[
      category.name,
      category.description,
      category.isActive ? 1 : 0,
    ];

    if (category.id != null && _catExists(category.id!)) {
      _store.execute(
        'UPDATE dining_table_category SET name=?, description=?, '
        'isActive=? WHERE id=?',
        [...values, category.id],
      );
      return category.id!;
    }

    _store.execute(
      'INSERT INTO dining_table_category ($_categoryColumns) '
      'VALUES (?,?,?)',
      values,
    );
    final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
    category.id = id;
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
    )..id = row['id'] as int;
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

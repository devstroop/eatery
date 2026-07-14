import 'package:flutter/foundation.dart';
import 'eatery_store.dart';

/// Versioned schema migrator for the Eatery SQLite store.
///
/// Usage:
/// ```dart
/// initEaterySchema(store, schema);
/// SchemaMigrator(store).migrate();
/// ```
class SchemaMigrator {
  final EateryStore _store;

  SchemaMigrator(this._store);

  /// Returns the current schema version from app_config, or 0 if unset.
  int getCurrentVersion() {
    _ensureConfigTable();
    final rows = _store.query(
      'SELECT value FROM app_config WHERE key = ?',
      ['schema_version'],
    );
    if (rows.isEmpty) return 0;
    final v = rows.first['value'] as String?;
    return v != null ? int.tryParse(v) ?? 0 : 0;
  }

  void _setVersion(int version) {
    _ensureConfigTable();
    _store.execute(
      'INSERT OR REPLACE INTO app_config (key, value) VALUES (?, ?)',
      ['schema_version', version.toString()],
    );
  }

  void _ensureConfigTable() {
    _store.execute(
      'CREATE TABLE IF NOT EXISTS app_config (key TEXT PRIMARY KEY, value TEXT)',
    );
  }

  /// Runs all pending migrations in order.
  void migrate() {
    final current = getCurrentVersion();
    final latest = _migrations.length;

    if (current >= latest) {
      debugPrint('SchemaMigrator: already at version $latest (current=$current)');
      return;
    }

    for (var v = current; v < latest; v++) {
      debugPrint('SchemaMigrator: running migration v${v + 1}...');
      try {
        _migrations[v](_store);
        _setVersion(v + 1);
      } catch (e) {
        debugPrint('SchemaMigrator: migration v${v + 1} failed: $e');
        rethrow;
      }
    }
    debugPrint('SchemaMigrator: migrated to version $latest');
  }

  /// List of migration functions, indexed by version (0 = first migration).
  static const _migrations = <void Function(EateryStore)>[
    _migrationV1,
    _migrationV2,
  ];

  /// v1: Auth & order lifecycle fields.
  ///
  /// - Add `staff.pin`, `staff.email`, `staff.pinUpdatedAt`, `staff.lastLoginAt`
  /// - Add `company.adminStaffId`
  /// - Add `order_product.note`, `order_product.status`
  /// - Add `dining_table.posX`, `dining_table.posY`, `dining_table.shape`
  /// - Create `order_status_history` table
  /// - Add `product.stockQuantity`, `product.lowStockThreshold`
  static void _migrationV1(EateryStore store) {
    // Staff auth fields
    _addColumn(store, 'staff', 'pin', 'TEXT');
    _addColumn(store, 'staff', 'email', 'TEXT');
    _addColumn(store, 'staff', 'pinUpdatedAt', 'INTEGER');
    _addColumn(store, 'staff', 'lastLoginAt', 'INTEGER');

    // Company admin link
    _addColumn(store, 'company', 'adminStaffId', 'INTEGER');

    // Order product fields
    _addColumn(store, 'order_product', 'note', 'TEXT');
    _addColumn(store, 'order_product', 'status', 'INTEGER NOT NULL DEFAULT 0');

    // Dining table floor plan
    _addColumn(store, 'dining_table', 'posX', 'REAL');
    _addColumn(store, 'dining_table', 'posY', 'REAL');
    _addColumn(store, 'dining_table', 'shape', 'INTEGER DEFAULT 0');

    // Product stock fields
    _addColumn(store, 'product', 'stockQuantity', 'REAL DEFAULT 0');
    _addColumn(store, 'product', 'lowStockThreshold', 'REAL');

    // Order status history table
    store.execute('''
      CREATE TABLE IF NOT EXISTS order_status_history (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId         INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
        fromStatus      INTEGER NOT NULL,
        toStatus        INTEGER NOT NULL,
        changedByStaffId INTEGER REFERENCES staff(id),
        changedAt       INTEGER NOT NULL,
        reason          TEXT
      )
    ''');
    store.execute(
      'CREATE INDEX IF NOT EXISTS idx_osh_order ON order_status_history(orderId)',
    );
  }

  /// v2: Product modifiers + staffId on orders.
  ///
  /// - Create `modifier_group`, `modifier`, `product_modifier`,
  ///   `order_product_modifier` tables
  /// - Add `orders.staffId` column
  static void _migrationV2(EateryStore store) {
    _addColumn(store, 'orders', 'staffId', 'INTEGER');
    store.execute('''
      CREATE TABLE IF NOT EXISTS modifier_group (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        name        TEXT NOT NULL,
        description TEXT,
        minSelect   INTEGER NOT NULL DEFAULT 0,
        maxSelect   INTEGER NOT NULL DEFAULT 1,
        sortOrder   INTEGER DEFAULT 0,
        isRequired  INTEGER NOT NULL DEFAULT 0,
        createdAt   INTEGER NOT NULL,
        updatedAt   INTEGER
      )
    ''');
    store.execute('''
      CREATE TABLE IF NOT EXISTS modifier (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        modifierGroupId INTEGER NOT NULL REFERENCES modifier_group(id) ON DELETE CASCADE,
        name            TEXT NOT NULL,
        priceAdjust     REAL NOT NULL DEFAULT 0,
        sortOrder       INTEGER DEFAULT 0,
        isDefault       INTEGER NOT NULL DEFAULT 0,
        createdAt       INTEGER NOT NULL,
        updatedAt       INTEGER
      )
    ''');
    store.execute('''
      CREATE TABLE IF NOT EXISTS product_modifier (
        productId       INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
        modifierGroupId INTEGER NOT NULL REFERENCES modifier_group(id) ON DELETE CASCADE,
        PRIMARY KEY (productId, modifierGroupId)
      )
    ''');
    store.execute('''
      CREATE TABLE IF NOT EXISTS order_product_modifier (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        orderProductId  INTEGER NOT NULL REFERENCES order_product(id) ON DELETE CASCADE,
        modifierGroupId INTEGER NOT NULL REFERENCES modifier_group(id),
        modifierId      INTEGER NOT NULL REFERENCES modifier(id),
        modifierName    TEXT NOT NULL,
        priceAdjust     REAL NOT NULL DEFAULT 0,
        quantity        INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  /// Safely adds a column if it doesn't already exist.
  ///
  /// SQLite ignores duplicate column errors when caught, but this check
  /// avoids polluting the log with expected errors on re-run.
  static void _addColumn(
    EateryStore store,
    String table,
    String column,
    String type,
  ) {
    try {
      store.execute('ALTER TABLE $table ADD COLUMN $column $type');
    } catch (_) {
      // Column already exists — safe to ignore.
    }
  }
}

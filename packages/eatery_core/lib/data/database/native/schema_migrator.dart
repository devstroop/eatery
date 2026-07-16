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
    final rows = _store.query('SELECT value FROM app_config WHERE key = ?', [
      'schema_version',
    ]);
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

  /// Reads the device role from [app_config]. Returns null if not set.
  ///
  /// Possible values: `admin`, `waiter`, `kds`, `display`.
  String? getDeviceRole() {
    _ensureConfigTable();
    final rows = _store.query('SELECT value FROM app_config WHERE key = ?', [
      'device_role',
    ]);
    return rows.isNotEmpty ? rows.first['value'] as String? : null;
  }

  /// Persists the device role in [app_config].
  ///
  /// Valid values: `admin`, `waiter`, `kds`, `display`.
  void setDeviceRole(String role) {
    _ensureConfigTable();
    _store.execute(
      'INSERT OR REPLACE INTO app_config (key, value) VALUES (?, ?)',
      ['device_role', role],
    );
  }

  /// Runs all pending migrations in order.
  void migrate() {
    final current = getCurrentVersion();
    final latest = _migrations.length;

    if (current >= latest) {
      debugPrint(
        'SchemaMigrator: already at version $latest (current=$current)',
      );
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

  /// The total number of migrations (latest schema version).
  static int get latestVersion => _migrations.length;

  /// List of migration functions, indexed by version (0 = first migration).
  static const _migrations = <void Function(EateryStore)>[
    _migrationV1,
    _migrationV2,
    _migrationV3,
    _migrationV4,
    _migrationV5,
    _migrationV6,
    _migrationV7,
    _migrationV8,
    _migrationV9,
    _migrationV10,
    _migrationV11,
    _migrationV12,
    _migrationV13,
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

  /// v4: Discounts and promotions.
  static void _migrationV4(EateryStore store) {
    store.execute(
      "CREATE TABLE IF NOT EXISTS discount (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, type INTEGER NOT NULL, value REAL NOT NULL, minOrder REAL, maxUses INTEGER, isActive INTEGER NOT NULL DEFAULT 1, startsAt INTEGER, endsAt INTEGER, createdAt INTEGER NOT NULL, updatedAt INTEGER)",
    );
    store.execute(
      "CREATE TABLE IF NOT EXISTS order_discount (id INTEGER PRIMARY KEY AUTOINCREMENT, orderId INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE, discountId INTEGER REFERENCES discount(id), name TEXT NOT NULL, type INTEGER NOT NULL, value REAL NOT NULL, amount REAL NOT NULL, appliedBy INTEGER REFERENCES staff(id), createdAt INTEGER NOT NULL)",
    );
  }

  /// v5: Staff shifts and time tracking.
  static void _migrationV5(EateryStore store) {
    store.execute(
      "CREATE TABLE IF NOT EXISTS shift (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, startTime TEXT NOT NULL, endTime TEXT NOT NULL, isActive INTEGER NOT NULL DEFAULT 1)",
    );
    store.execute(
      "CREATE TABLE IF NOT EXISTS time_entry (id INTEGER PRIMARY KEY AUTOINCREMENT, staffId INTEGER NOT NULL REFERENCES staff(id), shiftId INTEGER REFERENCES shift(id), clockIn INTEGER NOT NULL, clockOut INTEGER, breakStart INTEGER, breakEnd INTEGER, note TEXT, createdAt INTEGER NOT NULL)",
    );
  }

  /// v6: Business hours and holiday hours.
  static void _migrationV6(EateryStore store) {
    store.execute(
      "CREATE TABLE IF NOT EXISTS business_hours (id INTEGER PRIMARY KEY AUTOINCREMENT, dayOfWeek INTEGER NOT NULL, openTime TEXT NOT NULL, closeTime TEXT NOT NULL, isClosed INTEGER NOT NULL DEFAULT 0)",
    );
    store.execute(
      "CREATE TABLE IF NOT EXISTS holiday_hours (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL, openTime TEXT, closeTime TEXT, description TEXT)",
    );
  }

  /// v7: Expense tracking.
  static void _migrationV7(EateryStore store) {
    store.execute(
      "CREATE TABLE IF NOT EXISTS expense_category (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT, isActive INTEGER NOT NULL DEFAULT 1)",
    );
    store.execute(
      "CREATE TABLE IF NOT EXISTS expense (id INTEGER PRIMARY KEY AUTOINCREMENT, categoryId INTEGER REFERENCES expense_category(id), amount REAL NOT NULL, description TEXT NOT NULL, expenseDate INTEGER NOT NULL, paymentMode INTEGER NOT NULL DEFAULT 0, reference TEXT, receipt TEXT, createdBy INTEGER REFERENCES staff(id), createdAt INTEGER NOT NULL)",
    );
  }

  /// v8: Table reservations.
  static void _migrationV8(EateryStore store) {
    store.execute(
      "CREATE TABLE IF NOT EXISTS reservation (id INTEGER PRIMARY KEY AUTOINCREMENT, customerName TEXT NOT NULL, customerPhone TEXT, diningTableId INTEGER REFERENCES dining_table(id), partySize INTEGER NOT NULL, dateTime INTEGER NOT NULL, duration INTEGER DEFAULT 60, status INTEGER NOT NULL DEFAULT 0, note TEXT, createdBy INTEGER REFERENCES staff(id), createdAt INTEGER NOT NULL, updatedAt INTEGER)",
    );
  }

  /// v9: Customer loyalty.
  static void _migrationV9(EateryStore store) {
    store.execute(
      "CREATE TABLE IF NOT EXISTS customer_loyalty (id INTEGER PRIMARY KEY AUTOINCREMENT, customerId INTEGER NOT NULL REFERENCES customer(id), points REAL NOT NULL DEFAULT 0, totalVisits INTEGER NOT NULL DEFAULT 0, totalSpent REAL NOT NULL DEFAULT 0, lastVisitAt INTEGER, tier INTEGER NOT NULL DEFAULT 0, createdAt INTEGER NOT NULL, updatedAt INTEGER)",
    );
    store.execute(
      "CREATE TABLE IF NOT EXISTS loyalty_transaction (id INTEGER PRIMARY KEY AUTOINCREMENT, customerId INTEGER NOT NULL REFERENCES customer(id), points REAL NOT NULL, type INTEGER NOT NULL, referenceId INTEGER, description TEXT, createdAt INTEGER NOT NULL)",
    );
  }

  /// v10: Schema Hardening — missing indices fixing S02-S09, S17.
  ///
  /// S01 default change (0→1) is applied in schema.sql for fresh DBs only.
  /// Existing DBs retain the old DEFAULT 0, but all Dart code paths that
  /// insert into `dining_table_category` explicitly set `isActive` — verified
  /// at runtime by `dining_table_repository_sqlite.dart:saveCategory()` which
  /// always writes `category.isActive ? 1 : 0`. No UPDATE needed for existing
  /// rows.
  static void _migrationV10(EateryStore store) {
    store.transaction(() {
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_orders_staff ON orders(staffId)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_orders_created ON orders(createdAt)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_reservation_datetime ON reservation(dateTime)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_reservation_table ON reservation(diningTableId)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_time_entry_staff ON time_entry(staffId)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_expense_date ON expense(expenseDate)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_stock_adj_product ON stock_adjustment(productId)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_order_discount_order ON order_discount(orderId)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_customer_loyalty_customer ON customer_loyalty(customerId)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_loyalty_transaction_customer ON loyalty_transaction(customerId)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_supplier_phone ON supplier(phone)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_purchase_order_supplier ON purchase_order(supplierId)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_purchase_order_status ON purchase_order(status)",
      );
      store.execute(
        "CREATE INDEX IF NOT EXISTS idx_purchase_order_item_po ON purchase_order_item(purchaseOrderId)",
      );
    });
  }

  /// v11: Staff → Employee rename.
  ///
  /// Renames the `staff` table to `employee` — SQLite auto-updates all FK
  /// references (`REFERENCES staff(id)` → `REFERENCES employee(id)`) in the
  /// `sqlite_master` schema during the rename, including columns whose names
  /// were unchanged (e.g. `createdBy`, `appliedBy`).
  ///
  /// Column renames use `_addColumn` + data copy instead of `RENAME COLUMN`
  /// for compatibility with SQLite < 3.25.0.
  static void _migrationV11(EateryStore store) {
    store.transaction(() {
      // Rename the table. SQLite rewrites all FK REFERENCES in other tables'
      // CREATE statements to point to `employee`.
      store.execute('ALTER TABLE staff RENAME TO employee');

      // Rename FK columns by adding the new column and copying data.
      // Old columns remain (unused) — no DROP COLUMN needed, which would
      // require SQLite 3.35.0+.

      // orders.staffId → employeeId (v2)
      _addColumn(store, 'orders', 'employeeId', 'INTEGER');
      _execOrIgnore(store, 'UPDATE orders SET employeeId = staffId');

      // dining_table.staffId → employeeId
      _addColumn(store, 'dining_table', 'employeeId', 'INTEGER');
      _execOrIgnore(store, 'UPDATE dining_table SET employeeId = staffId');

      // time_entry.staffId → employeeId (v5)
      _addColumn(store, 'time_entry', 'employeeId', 'INTEGER');
      _execOrIgnore(store, 'UPDATE time_entry SET employeeId = staffId');

      // company.adminStaffId → adminEmployeeId (v1)
      _addColumn(store, 'company', 'adminEmployeeId', 'INTEGER');
      _execOrIgnore(store, 'UPDATE company SET adminEmployeeId = adminStaffId');

      // order_status_history.changedByStaffId → changedByEmployeeId (v1)
      _addColumn(
        store,
        'order_status_history',
        'changedByEmployeeId',
        'INTEGER',
      );
      _execOrIgnore(
        store,
        'UPDATE order_status_history SET changedByEmployeeId = changedByStaffId',
      );

      // Recreate indexes with new names (SQLite cannot rename indexes).
      store.execute('DROP INDEX IF EXISTS idx_orders_staff');
      store.execute(
        'CREATE INDEX IF NOT EXISTS idx_orders_employee ON orders(employeeId)',
      );
      store.execute('DROP INDEX IF EXISTS idx_time_entry_staff');
      store.execute(
        'CREATE INDEX IF NOT EXISTS idx_time_entry_employee ON time_entry(employeeId)',
      );
    });
  }

  /// v12: Rename `company.edition` → `company.taxation`.
  ///
  /// Aligns the SQL column name with the Dart `Taxation` enum, completing the
  /// Edition→Taxation rename (N01-N04). Uses `_addColumn` + data copy for
  /// compatibility with SQLite < 3.25.0.
  ///
  /// Also defensively ensures `employee.email`, `pinUpdatedAt` and `lastLoginAt`
  /// exist — they were added by v1 (on the `staff` table) and carried over by
  /// the v11 `ALTER TABLE RENAME TO employee`. In practice every migrated DB
  /// already has them; this catch-all handles any schema that somehow bypassed
  /// v1 (e.g. a fresh schema.sql that predated those columns but had
  /// `eatery_schema.dart` already setting latestVersion).
  static void _migrationV12(EateryStore store) {
    // Company: edition → taxation (old column intentionally left in place;
    // DROP COLUMN requires SQLite 3.35.0+).
    _addColumn(store, 'company', 'taxation', 'INTEGER NOT NULL DEFAULT 0');
    _execOrIgnore(store, 'UPDATE company SET taxation = edition');

    // Employee audit fields (defensive — already present via v1 + v11 chain).
    _addColumn(store, 'employee', 'email', 'TEXT');
    _addColumn(store, 'employee', 'pinUpdatedAt', 'INTEGER');
    _addColumn(store, 'employee', 'lastLoginAt', 'INTEGER');
  }

  /// v13: Company timestamps + orders FK columns.
  ///
  /// Adds `createdAt`/`updatedAt` to `company` (S19), `companyId` to `orders`
  /// (S21), and `customerId` FK to `orders` (S11).
  static void _migrationV13(EateryStore store) {
    // S19: Company timestamps
    _addColumn(store, 'company', 'createdAt', 'INTEGER NOT NULL DEFAULT 0');
    _addColumn(store, 'company', 'updatedAt', 'INTEGER');

    // S21 + S11: Orders FK columns
    _addColumn(store, 'orders', 'customerId', 'INTEGER');
    _addColumn(store, 'orders', 'companyId', 'INTEGER');
  }

  /// Runs [sql] and ignores "no such column" errors that occur when the old
  /// column doesn't exist (e.g. on re-run or in test schemas).
  static void _execOrIgnore(EateryStore store, String sql) {
    try {
      store.execute(sql);
    } catch (_) {
      // Column may not exist — safe to ignore.
    }
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

  /// v3: Suppliers, purchase orders, stock adjustments.
  static void _migrationV3(EateryStore store) {
    store.execute('''
      CREATE TABLE IF NOT EXISTS supplier (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        name        TEXT NOT NULL,
        contactName TEXT, phone TEXT, email TEXT, address TEXT, gstin TEXT,
        isActive    INTEGER NOT NULL DEFAULT 1,
        createdAt   INTEGER NOT NULL, updatedAt INTEGER
      )
    ''');
    store.execute('''
      CREATE TABLE IF NOT EXISTS purchase_order (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        supplierId      INTEGER REFERENCES supplier(id),
        orderDate       INTEGER NOT NULL,
        expectedDate    INTEGER, deliveredDate INTEGER,
        status          INTEGER NOT NULL DEFAULT 0,
        totalAmount     REAL NOT NULL DEFAULT 0, notes TEXT,
        createdBy       INTEGER REFERENCES staff(id),
        createdAt       INTEGER NOT NULL, updatedAt INTEGER
      )
    ''');
    store.execute('''
      CREATE TABLE IF NOT EXISTS purchase_order_item (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        purchaseOrderId INTEGER NOT NULL REFERENCES purchase_order(id) ON DELETE CASCADE,
        productId       INTEGER NOT NULL REFERENCES product(id),
        quantity        REAL NOT NULL, unitPrice REAL NOT NULL,
        totalPrice      REAL NOT NULL, receivedQty REAL DEFAULT 0
      )
    ''');
    store.execute('''
      CREATE TABLE IF NOT EXISTS stock_adjustment (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        productId   INTEGER NOT NULL REFERENCES product(id),
        quantity    REAL NOT NULL, reason TEXT NOT NULL,
        referenceId INTEGER, notes TEXT,
        createdBy   INTEGER REFERENCES staff(id),
        createdAt   INTEGER NOT NULL
      )
    ''');
  }
}

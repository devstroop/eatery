# Specs 03 — Database Schema

## 1. Schema File

The canonical schema lives at `packages/eatery_core/assets/db/schema.sql` (currently at `assets/db/schema.sql`).

## 2. Current Tables (from schema.sql)

| Table | Purpose |
|-------|---------|
| `product_category` | Product categories (Breakfast, Lunch, etc.) |
| `product` | Products with prices, tax, type, station |
| `customer` | Customers with phone, address |
| `orders` | Orders with totals, status, type |
| `order_product` | Order line items |
| `payment` | Payments with amount, mode, reference |
| `tax_slab` | Tax rate config (inclusive/exclusive) |
| `dining_table_category` | Table area categories (Indoor, Outdoor) |
| `dining_table` | Dining tables with status, order link |
| `company` | Company profile with password, tax settings |
| `currency` | Currency config |
| `staff` | Staff with name, type |
| `subscription` | License info |
| `auto_print` | Auto-print settings |
| `kds_station` | KDS stations |
| `compliance_report` | Z/X reports |
| `void_log_entry` | Voided order audit |
| `printer` | Printer config |
| `op_log` | Sync operation log |

## 3. New Tables (Phase 1–2)

```sql
-- Order status audit trail
CREATE TABLE IF NOT EXISTS order_status_history (
  id                INTEGER PRIMARY KEY AUTOINCREMENT,
  order_id          INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  from_status       INTEGER NOT NULL,
  to_status         INTEGER NOT NULL,
  changed_by_staff_id INTEGER REFERENCES staff(id),
  changed_at        INTEGER NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_osh_order ON order_status_history(order_id);
```

```sql
-- Purchase orders (Phase 7)
CREATE TABLE IF NOT EXISTS purchase_order (
  id                INTEGER PRIMARY KEY AUTOINCREMENT,
  supplier_name     TEXT,
  order_date        INTEGER NOT NULL,
  expected_date     INTEGER,
  total_amount      REAL NOT NULL,
  status            INTEGER NOT NULL DEFAULT 0,  -- 0=pending, 1=received, 2=cancelled
  notes             TEXT,
  created_by_staff_id INTEGER REFERENCES staff(id)
);

CREATE TABLE IF NOT EXISTS purchase_order_item (
  id                INTEGER PRIMARY KEY AUTOINCREMENT,
  purchase_order_id INTEGER NOT NULL REFERENCES purchase_order(id) ON DELETE CASCADE,
  product_id        INTEGER REFERENCES product(id),
  quantity          REAL NOT NULL,
  unit_price        REAL NOT NULL,
  total_price       REAL NOT NULL
);

-- Stock adjustments
CREATE TABLE IF NOT EXISTS stock_adjustment (
  id                INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id        INTEGER NOT NULL REFERENCES product(id),
  adjustment        REAL NOT NULL,  -- positive = stock in, negative = stock out
  reason            TEXT,
  created_by_staff_id INTEGER REFERENCES staff(id),
  created_at        INTEGER NOT NULL
);
```

## 4. Schema Changes to Existing Tables (Phase 1–2)

### orders

```sql
-- New columns (Phase 1):
ALTER TABLE orders ADD COLUMN staff_id INTEGER REFERENCES staff(id);
ALTER TABLE orders ADD COLUMN dining_table_id INTEGER REFERENCES dining_table(id);

-- Column change (Phase 1):
-- status changes from TEXT 'active'/'completed'/'voided'/'refunded'
-- to INTEGER (index into OrderStatus enum)
-- Migration: UPDATE orders SET status = 0 WHERE status = 'active';
-- Migration: UPDATE orders SET status = 4 WHERE status = 'completed';
-- Migration: UPDATE orders SET status = 5 WHERE status = 'voided';
```

### staff

```sql
-- New columns (Phase 1):
ALTER TABLE staff ADD COLUMN pin TEXT;
ALTER TABLE staff ADD COLUMN current_dining_table_id INTEGER REFERENCES dining_table(id);
```

### dining_table

```sql
-- New columns (Phase 1):
ALTER TABLE dining_table ADD COLUMN staff_id INTEGER REFERENCES staff(id);
ALTER TABLE dining_table ADD COLUMN pos_x INTEGER;
ALTER TABLE dining_table ADD COLUMN pos_y INTEGER;
```

### product

```sql
-- New columns (Phase 7):
ALTER TABLE product ADD COLUMN stock_quantity REAL;
ALTER TABLE product ADD COLUMN low_stock_threshold REAL;
```

### company

```sql
-- Column deprecation (Phase 2):
-- password column kept for backward compat but no longer used for auth
-- Can be dropped in a later migration:
-- ALTER TABLE company DROP COLUMN password;
```

## 5. Schema Migration Strategy

### Current approach (EaterySchema.init)

```dart
void initEaterySchema(EateryStore store, String schemaDdl) {
  // Splits on "-- ──" section markers
  // Runs CREATE TABLE IF NOT EXISTS for each section
  // Comment lines and blank lines are filtered
}
```

### Target: Versioned migrations

```dart
class SchemaMigrator {
  final EateryStore _store;

  int get currentVersion {
    final row = _store.queryScalar(
      'SELECT MAX(version) FROM schema_version',
    );
    return row as int? ?? 0;
  }

  Future<void> migrate() async {
    if (currentVersion < 1) await _migrationV1();  // Phase 1: auth + status
    if (currentVersion < 2) await _migrationV2();  // Phase 2: order lifecycle
    if (currentVersion < 3) await _migrationV3();  // Phase 7: inventory
  }

  Future<void> _migrationV1() async {
    _store.execute('''CREATE TABLE IF NOT EXISTS schema_version (
      version INTEGER PRIMARY KEY,
      applied_at INTEGER NOT NULL
    )''');
    _store.execute("ALTER TABLE staff ADD COLUMN pin TEXT");
    _store.execute("ALTER TABLE staff ADD COLUMN current_dining_table_id INTEGER");
    _store.execute("ALTER TABLE orders ADD COLUMN staff_id INTEGER");
    _store.execute("ALTER TABLE orders ADD COLUMN dining_table_id INTEGER");
    _store.execute("ALTER TABLE dining_table ADD COLUMN staff_id INTEGER");
    _store.execute("ALTER TABLE dining_table ADD COLUMN pos_x INTEGER");
    _store.execute("ALTER TABLE dining_table ADD COLUMN pos_y INTEGER");
    _store.execute(
      'INSERT INTO schema_version (version, applied_at) VALUES (1, ?)',
      [DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<void> _migrationV2() async {
    _store.execute('''CREATE TABLE IF NOT EXISTS order_status_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
      from_status INTEGER NOT NULL,
      to_status INTEGER NOT NULL,
      changed_by_staff_id INTEGER REFERENCES staff(id),
      changed_at INTEGER NOT NULL
    )''');
    // Migrate existing orders: 'active'→0(pending), 'completed'→4, 'voided'→5
    _store.execute("UPDATE orders SET status = '0' WHERE status = 'active'");
    _store.execute("UPDATE orders SET status = '4' WHERE status = 'completed'");
    _store.execute("UPDATE orders SET status = '5' WHERE status = 'voided'");
    // status column type change from TEXT to INTEGER — handled at app layer
    _store.execute(
      'INSERT INTO schema_version (version, applied_at) VALUES (2, ?)',
      [DateTime.now().millisecondsSinceEpoch],
    );
  }
}
```

## 6. Index Recommendations

| Table | Index | Purpose | Phase |
|-------|-------|---------|-------|
| `orders` | `(staff_id)` | Filter orders by waiter | P1 |
| `orders` | `(dining_table_id)` | Find current order for table | P1 |
| `orders` | `(created_at)` | Date-range queries for reports | P7 |
| `orders` | `(status)` | Active vs completed filtering | P1 |
| `order_status_history` | `(order_id, changed_at)` | Timeline queries | P2 |
| `product` | `(stock_quantity)` | Low-stock queries | P7 |
| `dining_table` | `(staff_id)` | Find tables by waiter | P1 |

## 7. op_log Schema (unchanged)

```sql
CREATE TABLE IF NOT EXISTS op_log (
  clock INTEGER PRIMARY KEY,
  value TEXT NOT NULL  -- JSON serialized OpLogEntry
);
```

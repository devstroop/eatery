# Database Schema

Eatery uses a dual database strategy: Hive (legacy, being phased out) and SQLite (new, via Zig FFI `libeaterystore`).

## Hive Legacy (24 boxes)

The original persistence layer uses Hive with 24 type-annotated boxes. The `EateryDatabase` class (`packages/eatery_core/lib/data/database/eatery_database.dart`) provides typed getters for all boxes, but currently wraps the native SQLite store via EateryStore.

### TypeIndex (immutable — renumbering breaks user data)

| TypeId | Model | TypeId | Model |
|--------|-------|--------|-------|
| 0 | Company | 13 | SubscriptionType |
| 1 | Customer | 14 | TaxSlab |
| 2 | DiningTable | 15 | TaxType |
| 3 | DiningTableCategory | 16 | Staff |
| 4 | Order | 17 | StaffType |
| 5 | OrderType | 18 | Edition |
| 6 | Printer | 19 | KCurrency |
| 7 | PrinterType | 20 | AutoPrint |
| 8 | Product | 21 | Payment |
| 9 | ProductCategory | 22 | PaymentMode |
| 10 | ProductType | 23 | DiningTableStatus |
| 11 | FoodType | 24 | OrderProduct |
| 12 | Subscription | | |

### Initialization Sequence (legacy)

1. `Hive.initFlutter(dataDir)`
2. Register all 24 TypeAdapters
3. Open all 24 boxes by name
4. Set `isInitialized = true`

## SQLite (New)

The canonical SQLite schema file is at `assets/db/schema.sql` (and copied to each companion app under `apps/*/assets/db/schema.sql`).

### Current Tables (from schema.sql)

| Table | Purpose |
|-------|---------|
| `company` | Restaurant/tenant profile |
| `customer` | Customer profiles |
| `dining_table` | Dining tables with status, floor plan |
| `dining_table_category` | Table area categories |
| `orders` | Orders with totals, status, type |
| `order_product` | Order line items |
| `payment` | Payment transactions |
| `product` | Products with prices, tax, type |
| `product_category` | Product categories |
| `tax_slab` | Tax rate config |
| `staff` | Staff members with PIN |
| `printer` | Printer configuration |
| `subscription` | License/subscription info |
| `op_log` | Sync operation log |
| `auto_print` | Auto-print settings |
| `kds_station` | KDS station config |
| `compliance_report` | Z/X compliance reports |
| `void_log_entry` | Voided order audit trail |
| `currency` | Currency config |

### Tables Added via Schema Migrations

| Version | Tables Added |
|---------|-------------|
| v1 | `order_status_history` |
| v2 | `modifier_group`, `modifier`, `product_modifier`, `order_product_modifier` |
| v3 | `supplier`, `purchase_order`, `purchase_order_item`, `stock_adjustment` |
| v4 | `discount`, `order_discount` |
| v5 | `shift`, `time_entry` |
| v6 | `business_hours`, `holiday_hours` |
| v7 | `expense_category`, `expense` |
| v8 | `reservation` |
| v9 | `customer_loyalty`, `loyalty_transaction` |

### Schema Initialization

```dart
// packsges/eatery_core/lib/data/database/native/eatery_schema.dart
initEaterySchema(store, schema);  // runs CREATE TABLE IF NOT EXISTS from schema.sql

// packsges/eatery_core/lib/data/database/native/schema_migrator.dart
SchemaMigrator(store).migrate();  // runs pending versioned migrations
```

Version is tracked in an `app_config` table (`key = 'schema_version'`). The migrator checks current version and runs all pending migrations sequentially.

### op_log Table

```sql
CREATE TABLE IF NOT EXISTS op_log (
  clock INTEGER PRIMARY KEY,
  value TEXT NOT NULL  -- JSON serialized OpLogEntry
);
```

## Migration Feature Flags

Defined in `packages/eatery_core/lib/data/database/native/store_config.dart`. Each flag routes a repository to either SQLite or Hive:

| Flag | Default | Scope |
|------|---------|-------|
| `kUseSqliteProductStore` | true | Product + ProductCategory |
| `kUseSqliteCustomerStore` | true | Customer |
| `kUseSqliteOrderStore` | true | Order + OrderProduct |
| `kUseSqlitePaymentStore` | true | Payment |
| `kUseSqliteTaxStore` | true | TaxSlab |
| `kUseSqliteDiningTableStore` | true | DiningTable + DiningTableCategory |
| `kUseSqliteCompanyStore` | true | Company, Currency |
| `kUseSqliteStaffStore` | true | Staff |
| `kUseSqliteSubscriptionStore` | true | Subscription |
| `kUseSqliteAutoPrintStore` | true | AutoPrint |
| `kUseSqliteKdsStationStore` | true | KdsStation |
| `kUseSqliteComplianceStore` | true | ComplianceReport, VoidLogEntry |
| `kUseSqlitePrinterStore` | true | Printer |
| `kUseSqliteStore` | computed | Aggregate: true if any flag is true |

When `kUseSqliteStore` is true, `main.dart` opens the native EateryStore and overrides `eateryStoreProvider`.

## Migration Path (Hive to SQLite)

1. All flags currently default to `true` — all entities use SQLite
2. The Hive shim (`EateryDB` singleton in `packages/eatery_core/lib/data/database/eatery_db_shim.dart`) still exists for backward compat
3. The `EateryDatabase` class wraps the native store, providing `hasCompany` and `deleteAll`
4. Hive boxes are no longer opened at startup — only the SQLite store is initialized

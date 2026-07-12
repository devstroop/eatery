# Data Layer

> Single source of truth for all persisted data. Built on Hive with a repository abstraction on top.

---

## Architecture

```
Hive Boxes (24) ←── EateryDatabase ←── Repositories (8) ←── Providers ←── Pages
                    (injectable)         (typed CRUD)        (Riverpod)
```

The old `EateryDB.instance` singleton is a **shim** that delegates to `EateryDatabase`. It exists so legacy pages continue working during the strangler-fig migration.

---

## EateryDatabase

[View source](../../lib/data/database/eatery_database.dart)

The `EateryDatabase` class wraps all 24 Hive boxes and provides typed getters:

```dart
class EateryDatabase {
  EateryDatabase({required this.dataDir});
  final String dataDir;
  bool isInitialized = false;
  bool get hasCompany => ...;

  // Box getters (all non-nullable — validated by isInitialized)
  Box<Company> get companyBox => _companyBox!;
  Box<Product> get productBox => _productBox!;
  Box<Order> get orderBox => _orderBox!;
  // ... 21 more

  Future<void> init();      // Opens all boxes
  Future<void> deleteAll(); // Clears all boxes from disk
  Future<void> dispose();   // Closes Hive
}
```

### Initialization Sequence

1. `Hive.initFlutter(dataDir)`
2. Register all 24 TypeAdapters (from `.g.dart` files)
3. Open all 24 boxes by name
4. Set `isInitialized = true`

---

## Hive Models

All models live in `lib/data/models/` organized by domain:

```
models/
├── eatery_db.dart       # Barrel + TypeIndex constants (15 values)
├── company/             # Company, KCurrency, Edition
├── config/              # AutoPrint
├── customer/            # Customer
├── dining_table/        # DiningTable, DiningTableCategory, DiningTableStatus
├── extensions/          # Box extension methods
├── order/               # Order, OrderProduct, OrderType
├── payment/             # Payment, PaymentMode
├── printer/             # Printer, PrinterType
├── product/             # Product, ProductCategory, FoodType, ProductType
├── staff/               # Staff, StaffType
├── subscription/        # Subscription, SubscriptionType
├── tax/                 # TaxSlab, TaxType
└── drawings/            # Custom painting widgets (DineIn, Delivery, TakeAway)
```

### TypeIndex

Each model class has a `@HiveType(typeId: TypeIndex.xxx)` annotation. These are **immutable** — renumbering them breaks existing user data.

| TypeId | Model     | TypeId | Model            |
|--------|-----------|--------|------------------|
| 0      | Company   | 12     | Subscription      |
| 1      | Customer  | 13     | SubscriptionType  |
| 2      | DiningTable | 14  | TaxSlab           |
| 3      | DiningTableCategory | 15 | TaxType |
| 4      | Order     | 16     | Staff             |
| 5      | OrderType | 17     | StaffType         |
| 6      | Printer   | 18     | Edition           |
| 7      | PrinterType | 19   | KCurrency         |
| 8      | Product   | 20     | AutoPrint         |
| 9      | ProductCategory | 21 | Payment        |
| 10     | ProductType | 22   | PaymentMode       |
| 11     | FoodType  | 23     | DiningTableStatus |
|        |           | 24     | OrderProduct      |

### Dual Serialization

All models have BOTH:
- `@HiveField` annotations (for Hive's generated `.g.dart` adapters)
- Handwritten `.fromMap()` / `.toMap()` methods (for Excel/JSON import/export)

Both must match during maintenance.

---

## Repositories

[View all repos](../../lib/data/repositories/)

8 repositories provide typed CRUD operations:

| Repository | Key Methods |
|-----------|-------------|
| `ProductRepository` | `getAllProducts()`, `getProductsByType()`, `searchProducts()`, `isProductNameTaken()`, `saveProduct()`, `deleteProduct()` + category equivalents |
| `OrderRepository` | `getAllOrders()`, `getOrderById()`, `getOrderProducts()`, `saveOrder()`, `saveOrderProduct()`, `addOrderProduct()`, `deleteOrder()` |
| `CustomerRepository` | `getAllCustomers()`, `getCustomerByPhone()`, `saveCustomer()`, `getOutstandingAmount()` |
| `PaymentRepository` | `getAllPayments()`, `getPaymentsByOrder()`, `savePayment()` |
| `TaxRepository` | `getAllTaxSlabs()`, `getTaxSlabById()`, `saveTaxSlab()` |
| `DiningTableRepository` | `getAllTables()`, `getTableById()`, `saveTable()` |
| `CompanyRepository` | `getCurrentCompany()`, `getCurrencyByCode()`, `saveCompany()`, `getAllCurrencies()` |
| `PrinterRepository` | `getAllPrinters()`, `addPrinter()`, `deletePrinter()`, `clearAll()` |

**Pattern:**
```dart
class XRepository {
  XRepository({required EateryDatabase db}) : _db = db;
  final EateryDatabase _db;

  List<T> getAll() => _db.box.values.toList();
  Future<int> save(T item) async { ... }
  Future<void> delete(T item) async { ... }
}
```

---

## Legacy EateryDB Shim

[View source](../../lib/data/database/eatery_db_shim.dart)

The shim provides backward-compatible `EateryDB.instance.*Box` access that delegates to the new `EateryDatabase`. It is bound once in `main.dart` after DB init:

```dart
EateryDB.bind(appDatabase);
```

It includes `_ensureBound()` which throws a descriptive `StateError` if accessed before binding. The shim will be **deleted** once all remaining `EateryDB.instance` calls in model constructors (`nextId()`) and `order.function.dart` are migrated to repositories.

---

## Box Contents at Startup

All 24 boxes are opened during `EateryDatabase.init()`. They are empty until:
- User creates a company (onboarding flow)
- Sample data is loaded (dev menu)
- Data is restored from backup

---

## Related Specs

- [Architecture Overview](architecture.md)
- [State Management](state-management.md) — How providers expose database data
- [Dev Tooling](dev-tooling.md) — Seed data loader populates all boxes

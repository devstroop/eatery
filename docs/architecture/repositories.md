# Repositories

## Pattern

All repositories follow an interface/implementation pattern. The interface defines typed CRUD operations; the implementation (currently `Sqlite*` variants) backs them with the native SQLite store via `EateryStore`.

```dart
abstract class ProductRepository {
  List<Product> getAllProducts();
  Product? getProductById(int id);
  Future<int> saveProduct(Product product);
  Future<void> deleteProduct(Product product);
  // ...
}
```

## Repository Catalog

All interfaces live in `packages/eatery_core/lib/data/repositories/` (abstract classes). SQLite implementations in the same directory with `_sqlite` suffix.

### ProductRepository (`product_repository.dart`)

```dart
abstract class ProductRepository {
  List<Product> getAllProducts();
  List<Product> getProductsPage(int limit, int offset);
  int getProductCount();
  List<Product> getProductsByType(ProductType type);
  List<Product> getProductsByCategory(int? categoryId);
  Product? getProductById(int id);
  List<Product> searchProducts(String query);
  bool isProductNameTaken(String name, {int? excludeId});
  Future<int> saveProduct(Product product);
  Future<void> deleteProduct(Product product);
  List<ProductCategory> getAllCategories();
  ProductCategory? getCategoryById(int id);
  Future<int> saveCategory(ProductCategory category);
  Future<void> deleteCategory(ProductCategory category);
}
```

### OrderRepository (`order_repository.dart`)

```dart
abstract class OrderRepository {
  List<Order> getAllOrders();
  List<Order> getOrdersPage(int limit, int offset);
  int getOrderCount();
  Order? getOrderById(int id);
  List<OrderProduct> getOrderProducts(int orderId);
  Future<int> saveOrder(Order order);
  Future<void> saveOrderProduct(OrderProduct op);
  Future<int> addOrderProduct(OrderProduct op);
  Future<void> deleteOrder(Order order);
  List<OrderStatusHistory> getStatusHistory(int orderId);
  Future<void> recordStatusTransition(OrderStatusHistory transition);
  void adjustStock(int productId, int quantity);
}
```

### CustomerRepository (`customer_repository.dart`)

```dart
abstract class CustomerRepository {
  List<Customer> getAllCustomers();
  Customer? getCustomerByPhone(String phone);
  Future<int> saveCustomer(Customer customer);
  double getOutstandingAmount(int customerId);
}
```

### PaymentRepository (`payment_repository.dart`)

```dart
abstract class PaymentRepository {
  List<Payment> getAllPayments();
  List<Payment> getPaymentsByOrder(int orderId);
  Future<int> savePayment(Payment payment);
}
```

### TaxRepository (`tax_repository.dart`)

```dart
abstract class TaxRepository {
  List<TaxSlab> getAllTaxSlabs();
  TaxSlab? getTaxSlabById(int id);
  Future<int> saveTaxSlab(TaxSlab taxSlab);
}
```

### DiningTableRepository (`dining_table_repository.dart`)

```dart
abstract class DiningTableRepository {
  List<DiningTable> getAllTables();
  DiningTable? getTableById(int id);
  Future<int> saveTable(DiningTable table);
  List<DiningTableCategory> getAllCategories();
  DiningTableCategory? getCategoryById(int id);
  Future<int> saveCategory(DiningTableCategory category);
  Future<void> deleteCategory(DiningTableCategory category);
}
```

### CompanyRepository (`company_repository.dart`)

```dart
abstract class CompanyRepository {
  Company? getCurrentCompany();
  KCurrency? getCurrencyByCode(String code);
  List<KCurrency> getAllCurrencies();
  Future<void> saveCompany(Company company);
}
```

### PrinterRepository (`printer_repository.dart`)

Direct class (not abstract — single implementation in SQLite):

```dart
class PrinterRepository {
  List<Printer> getAllPrinters();
  Future<int> addPrinter(Printer printer);
  Future<void> deletePrinter(Printer printer);
  Future<void> clearAll();
}
```

## Dual Implementation Status

All repositories use SQLite exclusively (all `kUseSqlite*` flags default to `true`). The Hive-backed implementations have been fully migrated.

## OpLog Integration Pattern

Every repository write commits to the OpLog via the MutationHook:

```dart
// In SqliteProductRepository.saveProduct():
_store.execute('INSERT OR REPLACE INTO product ...');
notifyMutation('product', product.id!, 'save', product.toMap());
```

The `MutationHook` (`packages/eatery_core/lib/data/sync/mutation_hook.dart`) is installed by the `SyncCoordinator` during app startup. When no coordinator is active, calls to `notifyMutation` are no-ops �� zero coupling between repositories and the sync layer.

### OpLog Commit Checklist

| Repository | Create | Update | Delete | Notes |
|------------|--------|--------|--------|-------|
| OrderRepository | yes | yes | yes | Also records status transitions |
| ProductRepository | yes | yes | yes | |
| DiningTableRepository | yes | yes | yes | |
| StaffRepository | yes | yes | yes | |
| CustomerRepository | yes | yes | yes | |
| PaymentRepository | yes | no | no | Payments are append-only |
| CompanyRepository | yes | yes | no | Singleton entity |

## Entities Using SqlitePreferenceStore

Instead of dedicated repositories, these 4 entities are managed via `SqlitePreferenceStore` (`packages/eatery_core/lib/data/repositories/sqlite_preference_store.dart`):

- `ComplianceReport` — Z/X report records
- `VoidLogEntry` — Voided order audit log
- `KdsStation` — Kitchen display station config
- `AutoPrint` — Auto-print settings

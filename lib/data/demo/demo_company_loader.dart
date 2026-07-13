import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/models/eatery_db.dart';

const String _baseUrl =
    'https://raw.githubusercontent.com/devstroop/eatery_demo_company/main';

/// Loads a complete demo company from [eatery_demo_company] repo JSON files.
///
/// All records (company, subscription, currency, customers, products, tables,
/// staff, tax slabs, orders, line items, payments) come from the repo.
/// The loader has zero inline creation logic.
///
/// Loading order matches the creation flow: Subscription → Currency → Company,
/// so foreign key references (subscriptionId, currencyCode) resolve correctly.
///
/// Returns `true` on success, `false` on failure.
Future<bool> loadDemoCompany({
  required EateryDatabase db,
  required ProgressDialog pd,
}) async {
  // Loading order: Subscription → Currency → Company → rest
  // Subscription and Currency must precede Company because Company
  // references subscriptionId and currencyCode from the JSON.
  final downloads = <String, Future<bool> Function()>{
    'Subscription': () => _downloadEntity<Subscription>(
          db: db,
          endpoint: 'subscription.json',
          box: db.subscriptionBox,
          fromMap: (m) => Subscription.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Subscription',
          keyFn: (m) => m['id'] as int,
        ),
    'Currency': () => _downloadEntity<KCurrency>(
          db: db,
          endpoint: 'currency.json',
          box: db.currencyBox,
          fromMap: (m) => KCurrency.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Currency',
          // KCurrency has no id field — use box.add()
        ),
    'Company': () => _downloadEntity<Company>(
          db: db,
          endpoint: 'company.json',
          box: db.companyBox,
          fromMap: (m) => Company.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Company',
          keyFn: (m) => m['id'] as int,
        ),
    'Customers': () => _downloadEntity<Customer>(
          db: db,
          endpoint: 'customers.json',
          box: db.customerBox,
          fromMap: (m) => Customer.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Customers',
          keyFn: (m) => m['id'] as int,
        ),
    'Dining Table Categories': () => _downloadEntity<DiningTableCategory>(
          db: db,
          endpoint: 'dining_table_categories.json',
          box: db.diningTableCategoryBox,
          fromMap: (m) => DiningTableCategory.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Dining Table Categories',
          keyFn: (m) => m['id'] as int,
        ),
    'Dining Tables': () => _downloadEntity<DiningTable>(
          db: db,
          endpoint: 'dining_tables.json',
          box: db.diningTableBox,
          fromMap: (m) => DiningTable.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Dining Tables',
          keyFn: (m) => m['id'] as int,
        ),
    'Product Categories': () => _downloadEntity<ProductCategory>(
          db: db,
          endpoint: 'product_categories.json',
          box: db.productCategoryBox,
          fromMap: (m) => ProductCategory.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Product Categories',
          keyFn: (m) => m['id'] as int,
        ),
    'Products': () => _downloadEntity<Product>(
          db: db,
          endpoint: 'products.json',
          box: db.productBox,
          fromMap: (m) => Product.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Products',
          keyFn: (m) => m['id'] as int,
        ),
    'Staffs': () => _downloadEntity<Staff>(
          db: db,
          endpoint: 'staffs.json',
          box: db.staffBox,
          fromMap: (m) => Staff.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Staffs',
          keyFn: (m) => m['id'] as int,
        ),
    'Tax Slabs': () => _downloadEntity<TaxSlab>(
          db: db,
          endpoint: 'tax_slabs.json',
          box: db.taxSlabBox,
          fromMap: (m) => TaxSlab.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Tax Slabs',
          keyFn: (m) => m['id'] as int,
        ),
    'Orders': () => _downloadEntity<Order>(
          db: db,
          endpoint: 'orders.json',
          box: db.orderBox,
          fromMap: (m) => Order.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Orders',
          keyFn: (m) => m['id'] as int,
        ),
    'Order Products': () => _downloadEntity<OrderProduct>(
          db: db,
          endpoint: 'order_products.json',
          box: db.orderProductBox,
          fromMap: (m) => OrderProduct.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Order Products',
          keyFn: (m) => m['id'] as int,
        ),
    'Payments': () => _downloadEntity<Payment>(
          db: db,
          endpoint: 'payments.json',
          box: db.paymentBox,
          fromMap: (m) => Payment.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Payments',
          keyFn: (m) => m['id'] as int,
        ),
  };

  for (final entry in downloads.entries) {
    final success = await entry.value();
    if (!success) {
      pd.update(msg: '⚠️ ${entry.key} download had issues, continuing...');
    }
  }

  pd.update(msg: 'Demo company ready!');
  return true;
}

Future<bool> _downloadEntity<T>({
  required EateryDatabase db,
  required String endpoint,
  required Box<T> box,
  required T Function(Map<String, dynamic>) fromMap,
  required bool clearBeforeInsert,
  required ProgressDialog pd,
  required String label,
  int Function(Map<String, dynamic>)? keyFn,
}) async {
  try {
    pd.update(msg: 'Downloading $label...');
    final url = '$_baseUrl/$endpoint';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      pd.update(msg: '⚠️ $label not available (HTTP ${response.statusCode})');
      return true;
    }
    final list = (jsonDecode(response.body) as List<dynamic>)
        .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>);
    pd.update(msg: 'Saving $label...');

    // All entities share a single box per type. When keyFn is provided,
    // use box.put(explicitKey, obj) so foreign-key lookups resolve by id.
    // When keyFn is null (e.g. KCurrency which has no id field), use add().
    final usePut = keyFn != null;

    if (clearBeforeInsert) {
      await box.clear();
    }
    int count = 0;
    for (final map in list) {
      try {
        final obj = fromMap(map);
        if (usePut) {
          box.put(keyFn(map), obj);
        } else {
          box.add(obj);
        }
        count++;
      } catch (e) {
        pd.update(msg: '⚠️ Error saving $label item: $e');
      }
    }
    pd.update(msg: '✅ $count $label loaded');
    return true;
  } catch (e) {
    pd.update(msg: '⚠️ Error downloading $label: $e');
    return true; // non-fatal
  }
}

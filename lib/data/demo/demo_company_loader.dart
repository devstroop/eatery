import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/models/eatery_db.dart';

const String _baseUrl =
    'https://raw.githubusercontent.com/devstroop/eatery_demo_company/main';

/// Loads a complete demo company with all entity data.
///
/// 1. Creates Company (PIN-less), KCurrency, Subscription inline
/// 2. Downloads products, customers, dining tables, staff, tax slabs,
///    orders, payments from the [eatery_demo_company] repo
/// 3. Reports progress through the [ProgressDialog]
///
/// Returns `true` on success, `false` on failure.
Future<bool> loadDemoCompany({
  required EateryDatabase db,
  required ProgressDialog pd,
}) async {
  // ── 1. Company ──────────────────────────────────────────────────
  try {
    pd.update(msg: 'Creating demo company...');
    final company = Company(
      name: 'Demo Restaurant',
      email: 'demo@eatery.app',
      phone: '+1-555-0100',
      address: '123 Demo Street, Demo City',
      password: null,
      taxation: Taxation.none,
      currencyCode: 'USD',
    );
    await db.companyBox.add(company);

    pd.update(msg: 'Creating demo company... Done');
  } catch (e) {
    pd.update(msg: 'Failed to create company: $e');
    return false;
  }

  // ── 2. Currency ─────────────────────────────────────────────────
  try {
    pd.update(msg: 'Setting up currency...');
    final currency = KCurrency(
      name: 'US Dollar',
      code: 'USD',
      symbol: r'$',
      flag: null,
      number: 840,
      decimalDigits: 2,
      namePlural: 'US dollars',
      decimalSeparator: '.',
      thousandsSeparator: ',',
      symbolOnLeft: true,
      spaceBetweenAmountAndSymbol: false,
    );
    await db.currencyBox.add(currency);
    pd.update(msg: 'Setting up currency... Done');
  } catch (e) {
    pd.update(msg: 'Failed to set up currency: $e');
    return false;
  }

  // ── 3. Subscription ─────────────────────────────────────────────
  try {
    pd.update(msg: 'Setting up subscription...');
    final subscription = Subscription(
      purchaseCode: 'DEMO',
      validFrom: DateTime.now(),
      validTill: DateTime.now().add(const Duration(days: 365)),
      subscriptionType: SubscriptionType.business,
    );
    await db.subscriptionBox.add(subscription);

    // Link subscription to company
    final company = db.companyBox.values.first;
    company.subscriptionId = subscription.id;
    await company.save();
    pd.update(msg: 'Setting up subscription... Done');
  } catch (e) {
    pd.update(msg: 'Failed to set up subscription: $e');
    return false;
  }

  // ── 4. Download entities ───────────────────────────────────────
  final downloads = <String, Future<bool> Function()>{
    'Customers': () => _downloadEntity<Customer>(
          db: db,
          endpoint: 'customers.json',
          box: db.customerBox,
          fromMap: (m) => Customer.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Customers',
        ),
    'Dining Table Categories': () => _downloadEntity<DiningTableCategory>(
          db: db,
          endpoint: 'dining_table_categories.json',
          box: db.diningTableCategoryBox,
          fromMap: (m) => DiningTableCategory.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Dining Table Categories',
        ),
    'Dining Tables': () => _downloadEntity<DiningTable>(
          db: db,
          endpoint: 'dining_tables.json',
          box: db.diningTableBox,
          fromMap: (m) => DiningTable.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Dining Tables',
        ),
    'Product Categories': () => _downloadEntity<ProductCategory>(
          db: db,
          endpoint: 'product_categories.json',
          box: db.productCategoryBox,
          fromMap: (m) => ProductCategory.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Product Categories',
        ),
    'Products': () => _downloadEntity<Product>(
          db: db,
          endpoint: 'products.json',
          box: db.productBox,
          fromMap: (m) => Product.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Products',
        ),
    'Staffs': () => _downloadEntity<Staff>(
          db: db,
          endpoint: 'staffs.json',
          box: db.staffBox,
          fromMap: (m) => Staff.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Staffs',
        ),
    'Tax Slabs': () => _downloadEntity<TaxSlab>(
          db: db,
          endpoint: 'tax_slabs.json',
          box: db.taxSlabBox,
          fromMap: (m) => TaxSlab.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Tax Slabs',
        ),
    'Orders': () => _downloadEntity<Order>(
          db: db,
          endpoint: 'orders.json',
          box: db.orderBox,
          fromMap: (m) => Order.fromMap(m),
          clearBeforeInsert: true,
          pd: pd,
          label: 'Orders',
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
}) async {
  try {
    pd.update(msg: 'Downloading $label...');
    final url = '$_baseUrl/$endpoint';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      pd.update(msg: '⚠️ $label not available (HTTP ${response.statusCode})');
      return true; // non-fatal
    }
    final list = (jsonDecode(response.body) as List<dynamic>)
        .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>);
    pd.update(msg: 'Saving $label...');
    if (clearBeforeInsert) {
      await box.clear();
    }
    int count = 0;
    for (final map in list) {
      try {
        box.add(fromMap(map));
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

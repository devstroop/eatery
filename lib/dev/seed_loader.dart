import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/dev/seed_data.dart';
import 'package:eatery/presentation/providers/database_provider.dart';

/// Loads [SeedData] into the database.
/// Called from the Developer menu in debug mode.
Future<void> loadSeedData(WidgetRef ref) async {
  final db = ref.read(appDatabaseProvider);
  final data = SeedData.defaultData;

  // Tax slabs (no FK dependencies)
  for (final s in data.taxSlabs) {
    final slab = TaxSlab(
      name: s['name'] as String,
      rate: (s['rate'] as num).toDouble(),
      type: TaxType.values[s['type'] as int],
    );
    slab.id = s['id'] as int;
    await db.taxSlabBox.put(slab.id!, slab);
  }

  // Product categories
  for (final c in data.productCategories) {
    final cat = ProductCategory(
      name: c['name'] as String,
      description: c['description'] as String?,
      image: c['image'] as String?,
    );
    cat.id = c['id'] as int;
    await db.productCategoryBox.put(cat.id!, cat);
  }

  // Products
  for (final p in data.products) {
    final product = Product(
      name: p['name'] as String,
      categoryId: p['categoryId'] as int?,
      description: p['description'] as String?,
      image: p['image'] as String?,
      mrpPrice: (p['mrpPrice'] as num).toDouble(),
      salePrice: (p['salePrice'] as num?)?.toDouble(),
      taxSlabId: p['taxSlabId'] as int?,
      foodType: p['foodType'] != null
          ? FoodType.values[p['foodType'] as int]
          : null,
      type: ProductType.values[p['type'] as int],
      isActive: p['isActive'] as bool,
    );
    product.id = p['id'] as int;
    await db.productBox.put(product.id!, product);
  }

  // Dining table categories
  for (final c in data.diningTableCategories) {
    final cat = DiningTableCategory(
      name: c['name'] as String,
      description: c['description'] as String?,
    );
    cat.id = c['id'] as int;
    await db.diningTableCategoryBox.put(cat.id!, cat);
  }

  // Dining tables
  for (final t in data.diningTables) {
    final catId = t['categoryId'] as int?;
    final category = catId != null
        ? db.diningTableCategoryBox.get(catId)
        : null;
    final table = DiningTable(
      name: t['name'] as String,
      category: category,
      capacity: t['capacity'] as int?,
      status: DiningTableStatus.values[t['status'] as int],
    );
    table.id = t['id'] as int;
    await db.diningTableBox.put(table.id!, table);
  }

  // Staff
  for (final s in data.staffs) {
    final staff = Staff(
      name: s['name'] as String,
      phone: s['phone'] as String,
      type: StaffType.values[s['type'] as int],
      isActive: s['isActive'] as bool,
    );
    staff.id = s['id'] as int;
    await db.staffBox.put(staff.id!, staff);
  }

  // Customers
  for (final c in data.customers) {
    final customer = Customer(
      name: c['name'] as String,
      phone: c['phone'] as String,
      address: c['address'] as String?,
      landmark: c['landmark'] as String?,
    );
    customer.id = c['id'] as int;
    await db.customerBox.put(customer.id!, customer);
  }
}

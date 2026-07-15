import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/product_repository.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';

import '../database/native/eatery_store.dart';

/// SQLite-backed implementation of [ProductRepository], powered by the native
/// libeaterystore (Zig + embedded SQLite) over dart:ffi.
///
/// It implements the exact same public surface as the Hive-backed
/// [ProductRepository], so it can be swapped in behind
/// `productRepositoryProvider` without touching any UI code.
///
/// Rows are marshaled to/from [Product] via its existing `toMap()` /
/// `fromMap()`, with two conversions the SQLite boundary requires:
///   * `isActive` is stored as INTEGER 0/1 and converted to/from `bool`
///   * numeric columns are coerced to `double` where the model expects it
class SqliteProductRepository implements ProductRepository {
  SqliteProductRepository({required EateryStore store}) : _store = store;

  final EateryStore _store;

  static const _columns =
      'name, categoryId, description, image, mrpPrice, salePrice, '
      'taxSlabId, foodType, type, isActive, stationId, stationName';

  // ---------------------------------------------------------------------------
  // Products
  // ---------------------------------------------------------------------------

  @override
  @override
  List<Product> getAllProducts() =>
      _store.query('SELECT * FROM product').map(_toProduct).toList();

  @override
  List<Product> getProductsPage(int limit, int offset) => _store
      .query('SELECT * FROM product ORDER BY name LIMIT ? OFFSET ?', [
        limit,
        offset,
      ])
      .map(_toProduct)
      .toList();

  @override
  int getProductCount() =>
      (_store.queryScalar('SELECT COUNT(*) FROM product') as int?) ?? 0;

  @override
  @override
  List<Product> getProductsByType(ProductType type) => _store
      .query('SELECT * FROM product WHERE type = ?', [type.index])
      .map(_toProduct)
      .toList();

  @override
  List<Product> getProductsByCategory(int? categoryId) {
    final rows = categoryId == null
        ? _store.query('SELECT * FROM product WHERE categoryId IS NULL')
        : _store.query('SELECT * FROM product WHERE categoryId = ?', [
            categoryId,
          ]);
    return rows.map(_toProduct).toList();
  }

  @override
  Product? getProductById(int id) {
    final rows = _store.query('SELECT * FROM product WHERE id = ?', [id]);
    return rows.isEmpty ? null : _toProduct(rows.first);
  }

  @override
  List<Product> searchProducts(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return getAllProducts();
    return _store
        .query("SELECT * FROM product WHERE lower(name) LIKE ?", ['%$q%'])
        .map(_toProduct)
        .toList();
  }

  @override
  bool isProductNameTaken(String name, {int? excludeId}) {
    final n = name.toLowerCase().trim();
    final rows = _store.query(
      'SELECT id FROM product WHERE lower(trim(name)) = ? AND id != ?',
      [n, excludeId ?? -1],
    );
    return rows.isNotEmpty;
  }

  @override
  Future<int> saveProduct(Product product) async {
    final m = product.toMap();
    final values = <Object?>[
      m['name'],
      m['categoryId'],
      m['description'],
      m['image'],
      m['mrpPrice'],
      m['salePrice'],
      m['taxSlabId'],
      m['foodType'],
      m['type'],
      (m['isActive'] as bool?) == true ? 1 : 0,
      m['stationId'],
      m['stationName'],
    ];

    final int id;
    if (product.id != null && _exists('product', product.id!)) {
      id = product.id!;
      _store.execute(
        'UPDATE product SET '
        'name=?, categoryId=?, description=?, image=?, mrpPrice=?, '
        'salePrice=?, taxSlabId=?, foodType=?, type=?, isActive=?, '
        'stationId=?, stationName=? WHERE id=?',
        [...values, id],
      );
    } else {
      _store.execute(
        'INSERT INTO product ($_columns) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        values,
      );
      id = _store.queryScalar('SELECT last_insert_rowid()') as int;
      product = product.copyWith(id: id);
    }
    notifyMutation('product', id, 'save', product.toMap());
    return id;
  }

  @override
  Future<void> deleteProduct(Product product) async {
    if (product.id == null) return;
    _store.execute('DELETE FROM product WHERE id = ?', [product.id]);
    notifyMutation('product', product.id!, 'delete', {'id': product.id});
  }

  // ---------------------------------------------------------------------------
  // Product Categories
  // ---------------------------------------------------------------------------

  @override
  List<ProductCategory> getAllCategories() =>
      _store.query('SELECT * FROM product_category').map(_toCategory).toList();

  @override
  ProductCategory? getCategoryById(int id) {
    final rows = _store.query('SELECT * FROM product_category WHERE id = ?', [
      id,
    ]);
    return rows.isEmpty ? null : _toCategory(rows.first);
  }

  @override
  Future<int> saveCategory(ProductCategory category) async {
    final m = category.toMap();
    final values = <Object?>[m['name'], m['description'], m['image']];

    final int id;
    if (category.id != null && _exists('product_category', category.id!)) {
      id = category.id!;
      _store.execute(
        'UPDATE product_category SET name=?, description=?, image=? WHERE id=?',
        [...values, id],
      );
    } else {
      _store.execute(
        'INSERT INTO product_category (name, description, image) VALUES (?,?,?)',
        values,
      );
      id = _store.queryScalar('SELECT last_insert_rowid()') as int;
      category = category.copyWith(id: id);
    }
    notifyMutation('product_category', id, 'save', category.toMap());
    return id;
  }

  @override
  Future<void> deleteCategory(ProductCategory category) async {
    if (category.id == null) return;
    _store.execute('DELETE FROM product_category WHERE id = ?', [category.id]);
    notifyMutation('product_category', category.id!, 'delete', {
      'id': category.id,
    });
  }

  // ---------------------------------------------------------------------------
  // Row mapping
  // ---------------------------------------------------------------------------

  bool _exists(String table, int id) =>
      _store.queryScalar('SELECT 1 FROM $table WHERE id = ?', [id]) != null;

  Product _toProduct(Map<String, Object?> row) => Product.fromMap({
    'id': row['id'],
    'name': row['name'],
    'categoryId': row['categoryId'],
    'description': row['description'],
    'image': row['image'],
    'mrpPrice': (row['mrpPrice'] as num).toDouble(),
    'salePrice': row['salePrice'] == null
        ? null
        : (row['salePrice'] as num).toDouble(),
    'taxSlabId': row['taxSlabId'],
    'foodType': row['foodType'],
    'type': row['type'],
    'isActive': (row['isActive'] as int) == 1,
    'stationId': row['stationId'],
    'stationName': row['stationName'],
  });

  ProductCategory _toCategory(Map<String, Object?> row) =>
      ProductCategory.fromMap({
        'id': row['id'],
        'name': row['name'],
        'description': row['description'],
        'image': row['image'],
      });
}

import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/models/eatery_db.dart';

/// Repository for [Product] and [ProductCategory] CRUD operations.
class ProductRepository {
  ProductRepository({required EateryDatabase db}) : _db = db;

  final EateryDatabase _db;

  // ---------------------------------------------------------------------------
  // Products
  // ---------------------------------------------------------------------------

  List<Product> getAllProducts() => _db.productBox.values.toList();

  List<Product> getProductsByType(ProductType type) =>
      _db.productBox.values.where((p) => p.type == type).toList();

  List<Product> getProductsByCategory(int? categoryId) =>
      _db.productBox.values.where((p) => p.categoryId == categoryId).toList();

  Product? getProductById(int id) {
    try {
      return _db.productBox.values.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Product> searchProducts(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return _db.productBox.values.toList();
    return _db.productBox.values
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  bool isProductNameTaken(String name, {int? excludeId}) {
    return _db.productBox.values.any(
      (p) =>
          p.name.toLowerCase().trim() == name.toLowerCase().trim() &&
          p.id != excludeId,
    );
  }

  Future<int> saveProduct(Product product) async {
    if (product.id != null && _db.productBox.containsKey(product.id)) {
      await product.save();
      return product.id!;
    }
    return await _db.productBox.add(product);
  }

  Future<void> deleteProduct(Product product) async {
    await product.delete();
  }

  // ---------------------------------------------------------------------------
  // Product Categories
  // ---------------------------------------------------------------------------

  List<ProductCategory> getAllCategories() =>
      _db.productCategoryBox.values.toList();

  ProductCategory? getCategoryById(int id) {
    try {
      return _db.productCategoryBox.values.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<int> saveCategory(ProductCategory category) async {
    if (category.id != null &&
        _db.productCategoryBox.containsKey(category.id)) {
      await category.save();
      return category.id!;
    }
    return await _db.productCategoryBox.add(category);
  }

  Future<void> deleteCategory(ProductCategory category) async {
    await category.delete();
  }
}

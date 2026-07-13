import 'package:eatery/data/models/eatery_db.dart';

/// Product repository interface. The SQLite-backed implementation
/// ([SqliteProductRepository]) implements this.
abstract class ProductRepository {
  List<Product> getAllProducts();
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

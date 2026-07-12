import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/repositories/product_repository.dart';
import 'package:eatery/presentation/providers/database_provider.dart';

/// Provides the [ProductRepository] singleton.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return ProductRepository(db: db);
});

/// In-memory list of products — refreshes when data changes.
final productListProvider =
    AsyncNotifierProvider<ProductListNotifier, List<Product>>(
      ProductListNotifier.new,
    );

class ProductListNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getAllProducts();
  }

  Future<void> refresh() async {
    final repo = ref.read(productRepositoryProvider);
    state = AsyncData(repo.getAllProducts());
  }
}

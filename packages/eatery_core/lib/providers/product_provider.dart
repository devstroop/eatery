import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/database/native/store_config.dart';
import 'package:eatery_core/data/repositories/product_repository.dart';
import 'package:eatery_core/data/repositories/product_repository_sqlite.dart';
import 'package:eatery_core/providers/database_provider.dart';

/// Provides the [ProductRepository] singleton.
///
/// When [kUseSqliteProductStore] is enabled, this returns the native
/// SQLite-backed implementation; otherwise the original Hive-backed one.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return SqliteProductRepository(store: ref.read(eateryStoreProvider));
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

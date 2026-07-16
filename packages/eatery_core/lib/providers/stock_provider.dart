import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/database_provider.dart';

class StockInfo {
  final double quantity;
  final double? threshold;

  const StockInfo({required this.quantity, this.threshold});

  bool get isLowStock => threshold != null && quantity <= threshold!;
}

final productStockProvider = FutureProvider.autoDispose<Map<int, StockInfo>>((
  ref,
) async {
  final store = ref.read(eateryStoreProvider);
  final rows = store.query(
    'SELECT id, stockQuantity, lowStockThreshold FROM product',
  );
  return {
    for (final r in rows)
      r['id'] as int: StockInfo(
        quantity: ((r['stockQuantity'] ?? 0) as num).toDouble(),
        threshold: r['lowStockThreshold'] != null
            ? ((r['lowStockThreshold'] as num).toDouble())
            : null,
      ),
  };
});

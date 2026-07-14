import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery_core/eatery_core.dart';

final _categoriesProvider = FutureProvider<List<ProductCategory>>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return repo.getAllCategories();
});

final _selectedCategoryProvider = StateProvider<int?>((ref) => null);

final _filteredProductsProvider = FutureProvider<List<Product>>((ref) {
  final repo = ref.read(productRepositoryProvider);
  final all = repo.getAllProducts();
  final catId = ref.watch(_selectedCategoryProvider);
  if (catId == null) return all;
  return all.where((p) => p.categoryId == catId).toList();
});

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(_categoriesProvider);
    final products = ref.watch(_filteredProductsProvider);
    final cart = ref.watch(cartProvider);
    final selectedCat = ref.watch(_selectedCategoryProvider);
    final session = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          session.activeDiningTable != null
              ? 'Table ${session.activeDiningTable!.name} — Menu'
              : 'Menu',
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => context.push('/cart'),
              ),
              if (cart.cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.cartTotalQuantity}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          categories.when(
            data: (list) => SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  _CategoryChip(
                    label: 'All',
                    selected: selectedCat == null,
                    onTap: () => ref.read(_selectedCategoryProvider.notifier).state = null,
                  ),
                  ...list.map((c) => _CategoryChip(
                    label: c.name,
                    selected: selectedCat == c.id,
                    onTap: () => ref.read(_selectedCategoryProvider.notifier).state = c.id,
                  )),
                ],
              ),
            ),
            loading: () => const SizedBox(height: 48),
            error: (_, _) => const SizedBox(height: 48),
          ),
          Expanded(
            child: products.when(
              data: (list) => GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) => _ProductCard(
                  product: list[index],
                  quantity: ref.read(cartProvider.notifier).cartQuantity(list[index]),
                  onTap: () => ref.read(cartProvider.notifier).addToCart(list[index]),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onTap;
  const _ProductCard({
    required this.product,
    required this.quantity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Icon(Icons.restaurant, size: 32, color: AppColors.primary),
                  if (quantity > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              AppSpacing.gapSm,
              Text(
                product.name,
                style: AppTypography.labelMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.gapXs,
              Text(
                '\$${product.mrpPrice.toStringAsFixed(2)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery_core/eatery_core.dart';
import 'package:eatery/components/eatery_core_widgets/widgets.dart';

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
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.cartTotalQuantity}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.white,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                children: [
                  _CategoryChip(
                    label: 'All',
                    selected: selectedCat == null,
                    onTap: () =>
                        ref.read(_selectedCategoryProvider.notifier).state =
                            null,
                  ),
                  ...list.map(
                    (c) => _CategoryChip(
                      label: c.name,
                      selected: selectedCat == c.id,
                      onTap: () =>
                          ref.read(_selectedCategoryProvider.notifier).state =
                              c.id,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox(height: 48),
            error: (_, _) => const SizedBox(height: 48),
          ),
          Expanded(
            child: products.when(
              data: (list) => GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.85,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final product = list[index];
                  final currencySymbol =
                      ref.read(companyProvider.notifier).currency?.symbol ?? '';
                  final plainKey = CartNotifier.plainCartKey(product);
                  final inCart =
                      plainKey != null && cart.cart.containsKey(plainKey);
                  return _ProductCard(
                    product: product,
                    currencySymbol: currencySymbol,
                    onTap: () {
                      if (inCart) {
                        ref
                            .read(cartProvider.notifier)
                            .removeFromCart(product, cartKey: plainKey);
                      } else {
                        ref.read(cartProvider.notifier).addToCart(product);
                      }
                    },
                    inCart: inCart,
                  );
                },
              ),
              loading: () => GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.85,
                ),
                itemCount: 6,
                itemBuilder: (_, _) => AppSkeleton.card(),
              ),
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
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final String currencySymbol;
  final VoidCallback onTap;
  final bool inCart;

  const _ProductCard({
    required this.product,
    required this.currencySymbol,
    required this.onTap,
    required this.inCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: inCart
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Center(
                  child: product.image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.restaurant,
                              size: 48,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.restaurant,
                          size: 48,
                          color: AppColors.primary,
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                style: AppTypography.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '$currencySymbol${product.mrpPrice.toStringAsFixed(2)}',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

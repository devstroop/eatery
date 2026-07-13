import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.cart.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.cart.length,
                    itemBuilder: (context, index) {
                      final product = cart.cart[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.restaurant,
                              color: AppColors.primary),
                          title: Text(product.name),
                          subtitle: Text(
                            '\$${product.mrpPrice.toStringAsFixed(2)}',
                            style: TextStyle(color: AppColors.primary),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                color: Colors.red),
                            onPressed: () => ref
                                .read(cartProvider.notifier)
                                .removeFromCart(product),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Items: ${cart.cart.length}',
                                style: AppTypography.titleMedium),
                            Text(
                              '\$${cart.cart.fold(0.0, (sum, p) => sum + p.mrpPrice).toStringAsFixed(2)}',
                              style: AppTypography.titleLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.gapMd,
                        SizedBox(
                          width: double.infinity,
                          child: AppButton.primary(
                            label: 'Submit Order',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Order submitted!')),
                              );
                              ref.read(cartProvider.notifier).clearCart();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

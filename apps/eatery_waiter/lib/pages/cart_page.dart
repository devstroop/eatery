import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                if (cart.activeDiningTable != null)
                  Container(
                    width: double.infinity,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'Table: ${cart.activeDiningTable!.name}',
                      style: AppTypography.titleSmall,
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.cart.length,
                    itemBuilder: (context, index) {
                      final product = cart.cart[index];
                      final qty = ref
                          .read(cartProvider.notifier)
                          .cartQuantity(product);
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.restaurant,
                              color: AppColors.primary),
                          title: Text(product.name),
                          subtitle: Text(
                            '\$${product.mrpPrice.toStringAsFixed(2)} x $qty',
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
                            onPressed: () => _submitOrder(context, ref),
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

  Future<void> _submitOrder(BuildContext context, WidgetRef ref) async {
    final cart = ref.read(cartProvider);
    if (cart.cart.isEmpty) return;

    final orderRepo = ref.read(orderRepositoryProvider);

    // Group products by id to get quantities.
    final grouped = <int, int>{};
    final seen = <int>{};
    for (final p in cart.cart) {
      final id = p.id ?? 0;
      grouped[id] = (grouped[id] ?? 0) + 1;
    }
    final uniqueProducts =
        cart.cart.where((p) => seen.add(p.id ?? -1)).toList();

    final subTotal = cart.cart.fold(0.0, (sum, p) => sum + p.mrpPrice);

    final order = Order(
      createdAt: DateTime.now(),
      totalQuantity: cart.cart.length,
      subTotal: subTotal,
      discountTotal: 0,
      taxTotal: 0,
      finalTotal: subTotal,
      roundOff: 0,
      grandTotal: subTotal,
      paidTotal: null,
      type: cart.activeOrderType ?? OrderType.dine,
      status: OrderStatus.pending,
    );

    final orderId = await orderRepo.saveOrder(order);

    final savedOrder = order.copyWith(id: orderId);
    final coordinator = ref.read(syncCoordinatorProvider);
    if (coordinator != null) {
      MutationTracker.trackSave(
        coordinator: coordinator,
        entityType: 'order',
        entity: savedOrder,
      );
    }

    for (final p in uniqueProducts) {
      final qty = grouped[p.id ?? 0] ?? 1;
      final lineTotal = p.mrpPrice * qty;
      final op = OrderProduct(
        orderId: orderId,
        productId: p.id,
        productName: p.name,
        quantity: qty,
        price: p.mrpPrice,
        subTotal: lineTotal,
        total: lineTotal,
        stationId: p.stationId,
        stationName: p.stationName,
      );
      await orderRepo.saveOrderProduct(op);
    }

    ref.read(cartProvider.notifier).clearCart();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order submitted!')),
    );
    context.go('/');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery_core/eatery_core.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(cartProvider);
    final items = session.cart.values.toList();
    final total = items.fold(0.0, (sum, e) => sum + e.lineTotal);
    final totalQty = items.fold(0, (sum, e) => sum + e.quantity);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: session.cart.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : Column(
              children: [
                if (session.activeDiningTable != null)
                  Container(
                    width: double.infinity,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8,
                    ),
                    child: Text(
                      'Table: ${session.activeDiningTable!.name}',
                      style: AppTypography.titleSmall,
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.restaurant,
                              color: AppColors.primary),
                          title: Text(item.product.name),
                          subtitle: Text(
                            '\$${item.unitPrice.toStringAsFixed(2)} x ${item.quantity}',
                            style: TextStyle(color: AppColors.primary),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                color: Colors.red),
                            onPressed: () => ref
                                .read(cartProvider.notifier)
                                .removeFromCart(item.product),
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
                            Text('Total Items: $totalQty',
                                style: AppTypography.titleMedium),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
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
    final session = ref.read(cartProvider);
    if (session.cart.isEmpty) return;

    final orderRepo = ref.read(orderRepositoryProvider);
    final items = session.cart.values.toList();
    final cartProds = items.map((e) => e.product).toList();
    final totalQty = items.fold(0, (sum, e) => sum + e.quantity);
    final subTotal = cartProds.fold(0.0, (sum, p) => sum + (p.salePrice ?? p.mrpPrice));

    final order = Order(
      createdAt: DateTime.now(),
      totalQuantity: totalQty,
      subTotal: subTotal,
      discountTotal: 0,
      taxTotal: 0,
      finalTotal: subTotal,
      roundOff: 0,
      grandTotal: subTotal,
      paidTotal: null,
      type: session.activeOrderType ?? OrderType.dine,
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

    for (final entry in session.cart.entries) {
      final item = entry.value;
      final p = item.product;
      final qty = item.quantity;
      final lineTotal = (p.salePrice ?? p.mrpPrice) * qty;
      final op = OrderProduct(
        orderId: orderId,
        productId: p.id,
        productName: p.name,
        quantity: qty,
        price: p.salePrice ?? p.mrpPrice,
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

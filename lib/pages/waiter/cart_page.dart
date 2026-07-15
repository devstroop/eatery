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
                      horizontal: 16,
                      vertical: 8,
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
                          leading: Icon(
                            Icons.restaurant,
                            color: AppColors.primary,
                          ),
                          title: Text(item.product.name),
                          subtitle: Text(
                            '\$${item.unitPrice.toStringAsFixed(2)} x ${item.quantity}',
                            style: TextStyle(color: AppColors.primary),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
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
                            Text(
                              'Total Items: $totalQty',
                              style: AppTypography.titleMedium,
                            ),
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

    final store = ref.read(eateryStoreProvider);
    final staff = ref.read(authSessionProvider);
    final repo = ref.read(orderRepositoryProvider);
    final tableRepo = ref.read(diningTableRepositoryProvider);

    // Build order from cart
    final now = DateTime.now();
    final items = session.cart.values.toList();
    final total = items.fold(0.0, (sum, e) => sum + e.lineTotal);
    final totalQty = items.fold(0, (sum, e) => sum + e.quantity);

    final order = Order(
      customerPhone: session.activeCustomer?.phone,
      createdAt: now,
      updatedAt: now,
      totalQuantity: totalQty,
      subTotal: total,
      discountTotal: 0,
      taxTotal: 0,
      finalTotal: total,
      roundOff: 0,
      grandTotal: total,
      paidTotal: 0,
      type: session.activeOrderType ?? OrderType.dine,
      status: OrderStatus.pending,
      staffId: staff?.id,
    );

    try {
      final orderId = await repo.saveOrder(order);

      // Save line items
      for (final item in items) {
        await repo.saveOrderProduct(
          OrderProduct(
            orderId: orderId,
            productId: item.product.id,
            productName: item.product.name,
            quantity: item.quantity,
            price: item.unitPrice,
            subTotal: item.lineTotal,
            total: item.lineTotal,
            stationId: item.product.stationId,
            stationName: item.product.stationName,
          ),
        );
      }

      // Mark table as occupied
      if (session.activeDiningTable != null) {
        await tableRepo.saveTable(
          session.activeDiningTable!.copyWith(
            status: DiningTableStatus.occupied,
            orderId: orderId,
          ),
        );
      }

      // Record status transition
      await repo.recordStatusTransition(
        OrderStatusHistory(
          orderId: orderId,
          fromStatus: OrderStatus.pending.id,
          toStatus: OrderStatus.pending.id,
          changedByStaffId: staff?.id,
          changedAt: now,
        ),
      );

      if (!context.mounted) return;
      ref.read(cartProvider.notifier).clearCart();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order submitted!'),
          backgroundColor: Colors.green,
        ),
      );
      GoRouter.of(context).goNamed('tables');
    } catch (e) {
      debugPrint('Order submission failed: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

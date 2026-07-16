import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery_core/eatery_core.dart';
import 'package:eatery/services/printing/print_invoice.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(cartProvider);
    final items = session.cart.values.toList();
    final total = items.fold(0.0, (sum, e) => sum + e.lineTotal);
    final totalQty = items.fold(0, (sum, e) => sum + e.quantity);
    final currencySymbol =
        ref.read(companyProvider.notifier).currency?.symbol ?? '';

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
                            '$currencySymbol${item.unitPrice.toStringAsFixed(2)} x ${item.quantity}',
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
                              '$currencySymbol${total.toStringAsFixed(2)}',
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

    final employee = ref.read(authSessionProvider);
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
      employeeId: employee?.id,
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
          changedByEmployeeId: employee?.id,
          changedAt: now,
        ),
      );

      // Auto-print KOT
      try {
        final printers = ref.read(printerRepositoryProvider).getAllPrinters();
        if (printers.isNotEmpty) {
          final company = ref.read(companyProvider);
          final taxRepo = ref.read(taxRepositoryProvider);
          final cartMap = <int, Map<String, dynamic>>{};
          double totalTax = 0;
          for (var i = 0; i < items.length; i++) {
            final item = items[i];
            final slab = item.product.taxSlabId != null
                ? taxRepo.getTaxSlabById(item.product.taxSlabId!)
                : null;
            final taxRate = slab?.rate ?? 0;
            final taxAmount = item.lineTotal * taxRate / 100;
            totalTax += taxAmount;
            cartMap[i] = {
              'name': item.product.name,
              'quantity': item.quantity,
              'price': item.unitPrice,
              'tax_slab': taxRate,
              'taxType': slab?.type == TaxType.inclusive
                  ? 'inclusive'
                  : 'exclusive',
            };
          }
          final taxableTotal = total;
          final finalTotal = taxableTotal + totalTax;
          final roundOff = finalTotal - finalTotal.roundToDouble();
          final printOrder = <String, dynamic>{
            'id': orderId,
            'cart': cartMap,
            'finalTotal': finalTotal,
            'taxableTotal': taxableTotal,
            'subTotal': total,
            'taxTotal': totalTax,
            'roundOff': roundOff,
            'orderTypeText': session.activeOrderType?.name ?? 'Dine',
            'tableName': session.activeDiningTable?.name,
          };
          await PrintInvoice.printReceipt(
            order: printOrder,
            account: {
              'name': company?.name ?? '',
              'address': company?.address ?? '',
              'phone': company?.phone ?? '',
              'email': company?.email ?? '',
              'taxNo': company?.salesTaxNumber ?? '',
              'taxName': 'Tax',
              'foodLicenseNo': company?.foodLicenseNo ?? '',
              'printerSize': '58mm',
              'currencySymbol':
                  ref.read(companyProvider.notifier).currency?.symbol ?? '',
            },
          );
        }
      } catch (e) {
        debugPrint('Auto-print failed: $e');
      }

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

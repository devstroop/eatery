import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/extensions/double_ext.dart';
import 'package:eatery_core/widgets/app_dialog.dart';
import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery/functions/order.function.dart';
import 'package:eatery_core/providers/cart_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery_core/data/repositories/discount_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/references.dart';
import 'package:go_router/go_router.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  Discount? _activeDiscount;
  @override
  Widget build(BuildContext context) {
    Color themeColor = Color(
      ref.read(cartProvider).activeOrderType?.color ?? AppColors.primary.value,
    );
    return AppPageShell(
      title: 'Cart',
      color: themeColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(100, 100, 0, 100),
              items: [
                PopupMenuItem(
                  child: const Text('Clear Cart'),
                  onTap: () {
                    setState(() {
                      ref.read(cartProvider.notifier).clearCart();
                      _activeDiscount = null;
                    });
                  },
                ),
              ],
            );
          },
        ),
      ],
      child: ref.read(cartProvider).cart.isNotEmpty
          ? ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final product in ref.read(cartProvider).cartProducts)
                  ListTile(
                    leading: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.white600.withOpacity(0.36),
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: LibraryImage(product.image).image,
                          fit: product.type == ProductType.inventoryItem
                              ? BoxFit.contain
                              : BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: themeColor, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              2,
                              1,
                              2,
                              1,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ref
                                            .read(cartProvider.notifier)
                                            .cartQuantity(product) >
                                        0
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            ref
                                                .read(cartProvider.notifier)
                                                .removeFromCart(product);
                                          });
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: themeColor,
                                          size: 24,
                                        ),
                                      )
                                    : Container(),
                                ref
                                            .read(cartProvider.notifier)
                                            .cartQuantity(product) >
                                        0
                                    ? Padding(
                                        padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                              4,
                                              0,
                                              4,
                                              0,
                                            ),
                                        child: Text(
                                          ref
                                              .read(cartProvider.notifier)
                                              .cartQuantity(product)
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      ref
                                          .read(cartProvider.notifier)
                                          .addToCart(product);
                                    });
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: themeColor,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.description != null)
                          Text(product.description!),
                        Row(
                          children: [
                            Text(
                              '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${OrderFunction.calculateProductPriceWithoutTax(product)}',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Builder(
                              builder: (context) {
                                var taxSlab = ref
                                    .read(taxRepositoryProvider)
                                    .getTaxSlabById(product.taxSlabId ?? 0);
                                if (taxSlab != null) {
                                  return Text(
                                    '+ TAX: ${taxSlab.rate}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 7,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Text(
                                  'Amount:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${(ref.read(cartProvider.notifier).cartQuantity(product) * (product.salePrice ?? product.mrpPrice)).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                // Price breakthrough
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          16,
                          8,
                          16,
                          8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Subtotal',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${OrderFunction.calculateCartTotalWithoutTax(ref.read(cartProvider).cartProducts)}',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          16,
                          8,
                          16,
                          8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Tax (Incl./Excl.)',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${OrderFunction.calculateTaxAmount(ref.read(cartProvider).cartProducts)}',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          16,
                          8,
                          16,
                          8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Total',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${OrderFunction.calculateTotalWithTax(ref.read(cartProvider).cartProducts)}',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          16,
                          8,
                          16,
                          8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Round off (+/-)',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${OrderFunction.calculateRoundOff(OrderFunction.calculateTotalWithTax(ref.read(cartProvider).cartProducts)) > 0 ? '+' : '-'} ${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${OrderFunction.calculateRoundOff(OrderFunction.calculateTotalWithTax(ref.read(cartProvider).cartProducts)).abs()}',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // GrandTotal
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          16,
                          8,
                          16,
                          8,
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Grand Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Text(
                              '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${OrderFunction.calculatePayable(ref.read(cartProvider).cartProducts)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (ref
                              .read(customerRepositoryProvider)
                              .getOutstandingAmount(
                                ref.read(cartProvider).activeCustomer?.phone ??
                                    '',
                              ) >
                          0)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            16,
                            8,
                            16,
                            8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Previous',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                              Text(
                                () {
                                  final active = ref
                                      .read(cartProvider)
                                      .activeOrder;
                                  if (active == null) return '0';
                                  final outstanding =
                                      active.grandTotal -
                                      (active.paidTotal ?? 0);
                                  return '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${outstanding.toStringAsFixed(2)}';
                                }(),
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  Text(
                    'Cart is empty',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: ref.read(cartProvider).cart.isNotEmpty
          ? BottomAppBar(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payable Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${OrderFunction.calculatePayable(ref.read(cartProvider).cartProducts) + (ref.read(cartProvider).activeOrder?.grandTotal ?? 0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Text(
                          'includes all taxes and other charges',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final repo = DiscountRepository(
                        ref.read(eateryStoreProvider),
                      );
                      final discounts = repo.getActiveDiscounts();
                      if (discounts.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No active discounts available'),
                          ),
                        );
                        return;
                      }
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Apply Discount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...discounts.map(
                              (d) => ListTile(
                                title: Text(d.name),
                                subtitle: Text(
                                  d.type == 0
                                      ? '${d.value}% off'
                                      : d.type == 1
                                      ? '\$${d.value} off'
                                      : 'BOGO',
                                ),
                                trailing: _activeDiscount?.id == d.id
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : null,
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() => _activeDiscount = d);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${d.name} applied'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      _activeDiscount != null
                          ? 'Remove Discount'
                          : 'Apply Discount',
                    ),
                  ),
                  if (_activeDiscount != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _activeDiscount!.name,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            _activeDiscount!.type == 0
                                ? '-${_activeDiscount!.value}%'
                                : '-\$${_activeDiscount!.value}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  AppButton.primary(
                    label: 'Checkout',
                    onPressed: () => placeOrder(
                      context,
                      ref.read(cartProvider).cart,
                      ref.read(cartProvider).activeCustomer,
                      _activeDiscount,
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  placeOrder(
    BuildContext context,
    Map<int, CartItem> cart,
    Customer? customer,
    Discount? discount,
  ) async {
    if (customer == null) {
      AppDialog.showMessage(
        context,
        message: 'Please select a customer',
        type: MessageType.warning,
      );
      return;
    }
    var type = ref.read(cartProvider).activeOrderType;
    if (type == null) {
      AppDialog.showMessage(
        context,
        message: 'Please select order type',
        type: MessageType.warning,
      );
      return;
    }
    var diningTable = ref.read(cartProvider).activeDiningTable;
    if (type == OrderType.dine && diningTable == null) {
      AppDialog.showMessage(
        context,
        message: 'Please select a table',
        type: MessageType.warning,
      );
      return;
    }

    // Confirm?
    var confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to place this order?'),
            AppSpacing.gapLg,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        AppColors.white800,
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        AppColors.black600,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                AppSpacing.gapLg,
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        AppColors.secondary2,
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        AppColors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirm == null || !confirm) {
      return;
    }

    final cartProducts = cart.values.map((e) => e.product).toList();

    Order order;
    if (ref.read(cartProvider).activeOrder != null) {
      order = ref.read(cartProvider).activeOrder!;
      for (var product in cartProducts) {
        var existing = ref
            .read(orderRepositoryProvider)
            .getOrderProducts(order.id!)
            .where((element) => element.productId == product.id)
            .firstOrNull;
        if (existing != null) {
          final newQuantity = existing.quantity + 1;
          final newPrice = OrderFunction.calculateProductPriceWithoutTax(
            product,
          ).toPrecision(2);
          final newSubTotal =
              (OrderFunction.calculateProductPriceWithoutTax(product) *
                      newQuantity)
                  .toPrecision(2);
          final newTaxRate = OrderFunction.getProductTaxRate(
            product,
          )?.toPrecision(2);
          final newTaxAmount = OrderFunction.calculateProductTaxAmount(
            product,
          )?.toPrecision(2);
          final newTotal = (newSubTotal + (newTaxAmount ?? 0)).toPrecision(2);
          existing = existing.copyWith(
            quantity: newQuantity,
            price: newPrice,
            subTotal: newSubTotal,
            taxRate: newTaxRate,
            taxAmount: newTaxAmount,
            total: newTotal,
          );
          await ref.read(orderRepositoryProvider).saveOrderProduct(existing);
        } else {
          var orderProduct = OrderProduct(
            orderId: order.id,
            productId: product.id,
            productName: product.name,
            quantity: 1,
            price: OrderFunction.calculateProductPriceWithoutTax(
              product,
            ).toPrecision(2),
            subTotal: OrderFunction.calculateProductPriceWithoutTax(
              product,
            ).toPrecision(2),
            taxRate: OrderFunction.getProductTaxRate(product)?.toPrecision(2),
            taxAmount: OrderFunction.calculateProductTaxAmount(
              product,
            )?.toPrecision(2),
            total:
                (OrderFunction.calculateProductPriceWithoutTax(product) +
                        (OrderFunction.calculateProductTaxAmount(product) ?? 0))
                    .toPrecision(2),
          );
          await ref.read(orderRepositoryProvider).addOrderProduct(orderProduct);
        }
      }
      final orderProducts = ref
          .read(orderRepositoryProvider)
          .getOrderProducts(order.id!)
          .where((element) => element.orderId == order.id)
          .toList();
      final newTotalQuantity = orderProducts.fold(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );
      final newSubTotal = orderProducts.fold(
        0.0,
        (previousValue, element) => previousValue + element.subTotal,
      );
      final newTaxTotal = orderProducts.fold(
        0.0,
        (previousValue, element) => previousValue + (element.taxAmount ?? 0),
      );
      final newFinalTotal = orderProducts.fold(
        0.0,
        (previousValue, element) => previousValue + element.total,
      );
      final newRoundOff = OrderFunction.calculateRoundOff(newFinalTotal);
      final newGrandTotal = (newFinalTotal + newRoundOff).toPrecision(2);
      order = order.copyWith(
        totalQuantity: newTotalQuantity,
        subTotal: newSubTotal,
        taxTotal: newTaxTotal,
        finalTotal: newFinalTotal,
        roundOff: newRoundOff,
        grandTotal: newGrandTotal,
        updatedAt: DateTime.now(),
      );
      await ref.read(orderRepositoryProvider).saveOrder(order);
    } else {
      final cartProducts = cart.values.map((e) => e.product).toList();
      final totalQty = cart.values.fold(0, (sum, e) => sum + e.quantity);
      final subtotal = OrderFunction.calculateSubtotal(cartProducts);
      final taxTotal = OrderFunction.calculateTaxAmount(cartProducts);
      final baseTotal = subtotal + taxTotal;
      final roundOff = OrderFunction.calculateRoundOff(baseTotal);
      final discountAmount = discount != null
          ? (discount.type == 0
                ? baseTotal * discount.value / 100
                : discount.value)
          : 0.0;
      final grandTotal = (baseTotal + roundOff - discountAmount).toPrecision(2);
      order = Order(
        customerPhone: ref.read(cartProvider).activeCustomer?.phone,
        type: type,
        status: OrderStatus.pending,
        totalQuantity: totalQty,
        subTotal: subtotal.toPrecision(2),
        taxTotal: taxTotal.toPrecision(2),
        finalTotal: (baseTotal + roundOff).toPrecision(2),
        roundOff: roundOff.toPrecision(2),
        grandTotal: grandTotal,
        discountTotal: discountAmount.toPrecision(2),
        createdAt: DateTime.now(),
      );
      await ref.read(orderRepositoryProvider).saveOrder(order);
      if (discount != null) {
        DiscountRepository(ref.read(eateryStoreProvider)).applyDiscount(
          OrderDiscount(
            orderId: order.id!,
            discountId: discount.id,
            name: discount.name,
            type: discount.type,
            value: discount.value,
            amount: discountAmount.toPrecision(2),
            createdAt: DateTime.now(),
          ),
        );
      }
      for (final entry in cart.entries) {
        final product = entry.value.product;
        final qty = entry.value.quantity;
        for (var i = 0; i < qty; i++) {
          final orderProduct = OrderProduct(
            orderId: order.id,
            productId: product.id,
            productName: product.name,
            quantity: 1,
            price: OrderFunction.calculateProductPriceWithoutTax(
              product,
            ).toPrecision(2),
            subTotal: OrderFunction.calculateProductPriceWithoutTax(
              product,
            ).toPrecision(2),
            taxRate: OrderFunction.getProductTaxRate(product)?.toPrecision(2),
            taxAmount: OrderFunction.calculateProductTaxAmount(
              product,
            )?.toPrecision(2),
            total:
                (OrderFunction.calculateProductPriceWithoutTax(product) +
                        (OrderFunction.calculateProductTaxAmount(product) ?? 0))
                    .toPrecision(2),
          );
          await ref.read(orderRepositoryProvider).addOrderProduct(orderProduct);
        }
      }
    }

    if (type == OrderType.dine && diningTable != null) {
      var existingTable = ref
          .read(diningTableRepositoryProvider)
          .getTableById(ref.read(cartProvider).activeDiningTable?.id ?? 0);
      if (existingTable != null) {
        await ref
            .read(diningTableRepositoryProvider)
            .saveTable(
              existingTable.copyWith(
                status: DiningTableStatus.occupied,
                orderId: order.id,
              ),
            );
      }
    }

    try {
      await ref.read(orderRepositoryProvider).saveOrder(order);

      var printKOT = ref.read(cartProvider).activeOrderType == OrderType.dine;
      var printInvoice =
          ref.read(cartProvider).activeOrderType == OrderType.takeout ||
          ref.read(cartProvider).activeOrderType == OrderType.delivery;
      List<Product> currentCart = List.from(
        ref.read(cartProvider).cartProducts,
      );

      ref.read(cartProvider.notifier).clearCart();

      await AppDialog.showMessage(
        context,
        message: 'Order placed successfully',
        type: MessageType.success,
      );
      if (context.mounted) {
        GoRouter.of(context).goNamed(
          'orderPrint',
          extra: {
            'order': order,
            'currentCart': currentCart,
            'printKOT': printKOT,
            'printInvoice': printInvoice,
          },
        );
      }
    } catch (e) {
      AppDialog.showMessage(
        context,
        message: 'Failed to place order',
        type: MessageType.error,
      );
    }
  }
}

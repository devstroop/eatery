import 'package:eatery/functions/order.function.dart';
import 'package:eatery/references.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    Color themeColor =
        Color(Common.activeOrderType?.color ?? KColors.primary.value);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        title: const Text('Cart'),
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
                        Common.cart.clear();
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Common.cart.isNotEmpty
          ? ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (var product in Common.cart.toSet())
                  ListTile(
                    leading: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: KColors.white600.withOpacity(0.36),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: themeColor,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                2, 1, 2, 1),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Common.cart.contains(product)
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            Common.cart.remove(product);
                                          });
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: themeColor,
                                          size: 24,
                                        ),
                                      )
                                    : Container(),
                                Common.cart.contains(product)
                                    ? Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 0, 4, 0),
                                        child: Text(
                                          Common.cart
                                              .where((element) =>
                                                  element.id == product.id)
                                              .length
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
                                      Common.cart.add(product);
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
                              '${Common.currency?.symbol ?? ''}${OrderFunction.calculateProductPriceWithoutTax(product)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              '(Excl. Tax)',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                              ),
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
                                  '${Common.currency?.symbol ?? ''}${OrderFunction.calculateProductSubtotalInCartWithoutTax(Common.cart, product)}',
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${Common.currency?.symbol ?? ''}${OrderFunction.calculateCartTotalWithoutTax(Common.cart)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Tax (Incl./Excl.)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${Common.currency?.symbol ?? ''}${OrderFunction.calculateTaxAmount(Common.cart)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${Common.currency?.symbol ?? ''}${OrderFunction.calculateFinalTotal(Common.cart)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Round off (+/-)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${Common.currency?.symbol ?? ''}${OrderFunction.calculateRoundOff(Common.cart)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // GrandTotal
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Grand Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${Common.currency?.symbol ?? ''}${OrderFunction.calculatePayable(Common.cart)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
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
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Common.cart.isNotEmpty
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
                          '${Common.currency?.symbol ?? ''}${OrderFunction.calculatePayable(Common.cart)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Text(
                          'Includes taxes and additional charges',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PrimaryButton(
                    color: themeColor,
                    onPressed: () =>
                        placeOrder(context, Common.cart, Common.activeCustomer),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text('Checkout',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  placeOrder(BuildContext context, List<Product> cart, Customer? customer) {
    if (customer == null) {
      showMessageDialog(
          context, 'Please select a customer', MessageType.warning);
      return;
    }
    var type = Common.activeOrderType;
    if (type == null) {
      showMessageDialog(
          context, 'Please select order type', MessageType.warning);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to place this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              final order = Order(
                customer: customer,
                timestamp: DateTime.now(),
                products: cart,
                type: type,
                subtotal: OrderFunction.calculateSubtotal(cart),
                taxTotal: OrderFunction.calculateTaxAmount(cart),
                finalTotal: OrderFunction.calculateFinalTotal(cart),
                roundOff: OrderFunction.calculateRoundOff(cart),
                grandTotal: OrderFunction.calculatePayable(cart),
              );

              EateryDB.instance.orderBox!.put(order.id, order).then((value) {
                Common.cart.clear();
                showMessageDialog(context, 'Order placed successfully',
                        MessageType.success)
                    .whenComplete(() => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrderConfirmationPage(order: order)),
                        (route) => false));
              }).onError((error, stackTrace) {
                showMessageDialog(
                    context, 'Failed to place order', MessageType.error);
              });
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}

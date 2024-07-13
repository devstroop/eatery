import 'package:eatery/functions/order.function.dart';
import 'package:eatery/pages/dashboard/utility/order_print.page.dart';
import 'package:eatery/references.dart';
import 'package:get/get.dart';

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
                            const SizedBox(width: 2,),
                            Builder(builder: (context){
                              var taxSlab = EateryDB.instance.taxSlabBox?.values.where((element) => element.id == product.taxSlabId).firstOrNull;
                              if(taxSlab != null){
                                return Text(
                                  '+ TAX: ${taxSlab.rate}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 7,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
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
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 8, 16, 8),
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
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 8, 16, 8),
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
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 8, 16, 8),
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
                              '${Common.currency?.symbol ?? ''}${OrderFunction.calculateTotalWithTax(Common.cart)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 8, 16, 8),
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
                              '${OrderFunction.calculateRoundOff(OrderFunction.calculateTotalWithTax(Common.cart)) > 0 ? '+' : '-'} ${Common.currency?.symbol ?? ''}${OrderFunction.calculateRoundOff(OrderFunction.calculateTotalWithTax(Common.cart)).abs()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // GrandTotal
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 8, 16, 8),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Grand Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                                ),
                              ),
                            ),
                            Text(
                              '${Common.currency?.symbol ?? ''}${OrderFunction.calculatePayable(Common.cart)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                  fontSize: 18
                              ),
                            ),
                          ],
                        ),
                      ),
                      if((Common.activeCustomer?.getOutstandingAmount ?? 0) > 0)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 8, 16, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Previous',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: KColors.red,
                                ),
                              ),
                            ),
                            Text(
                              '${Common.currency?.symbol ?? ''}${Common.activeOrder?.grandTotal ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: KColors.red,
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
                          '${Common.currency?.symbol ?? ''}${OrderFunction.calculatePayable(Common.cart) + (Common.activeOrder?.grandTotal ?? 0)}',
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
                  PrimaryButton(
                    color: themeColor,
                    onPressed: () => placeOrder(
                        context, Common.cart, Common.activeCustomer),
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

  placeOrder(BuildContext context, List<Product> cart, Customer? customer) async {
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
    var diningTable = Common.activeDiningTable;
    if(type == OrderType.dine && diningTable == null){
      showMessageDialog(
          context, 'Please select a table', MessageType.warning);
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(KColors.white800),
                      foregroundColor: MaterialStateProperty.all(KColors.black600),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(KColors.secondary2),
                      foregroundColor: MaterialStateProperty.all(KColors.white),
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

    if(confirm == null || !confirm){
      return;
    }

    Order order;
    if(Common.activeOrder != null){
      order = Common.activeOrder!;
      for(var product in cart){
        var existing = EateryDB.instance.orderProductBox!.values.where((element) => element.id == product.id).firstOrNull;
        if(existing != null){
          existing.quantity += 1;
          existing.price = OrderFunction.calculateProductPriceWithoutTax(product).toPrecision(2);
          existing.subTotal = (OrderFunction.calculateProductPriceWithoutTax(product) * existing.quantity).toPrecision(2);
          existing.taxRate = OrderFunction.getProductTaxRate(product)?.toPrecision(2);
          existing.taxAmount = OrderFunction.calculateProductTaxAmount(product)?.toPrecision(2);
          existing.total = (existing.subTotal + (existing.taxAmount ?? 0)).toPrecision(2);
          await existing.save();
        }
        else{
          var orderProduct = OrderProduct(
            orderId: order.id,
            productId: product.id,
            productName: product.name,
            quantity: 1,
            price: OrderFunction.calculateProductPriceWithoutTax(product).toPrecision(2),
            subTotal: OrderFunction.calculateProductPriceWithoutTax(product).toPrecision(2),
            taxRate: OrderFunction.getProductTaxRate(product)?.toPrecision(2),
            taxAmount: OrderFunction.calculateProductTaxAmount(product)?.toPrecision(2),
            total: (OrderFunction.calculateProductPriceWithoutTax(product) + (OrderFunction.calculateProductTaxAmount(product) ?? 0)).toPrecision(2),
          );
          await EateryDB.instance.orderProductBox?.put(orderProduct.id, orderProduct);
        }
      }
      order.totalQuantity = EateryDB.instance.orderProductBox!.values.where((element) => element.orderId == order.id).toList().fold(0, (previousValue, element) => previousValue + element.quantity);
      order.subTotal = EateryDB.instance.orderProductBox!.values.where((element) => element.orderId == order.id).toList().fold(0, (previousValue, element) => previousValue + element.subTotal);
      order.taxTotal = EateryDB.instance.orderProductBox!.values.where((element) => element.orderId == order.id).toList().fold(0, (previousValue, element) => previousValue + (element.taxAmount ?? 0));
      order.finalTotal = EateryDB.instance.orderProductBox!.values.where((element) => element.orderId == order.id).toList().fold(0, (previousValue, element) => previousValue + element.total);
      order.roundOff = OrderFunction.calculateRoundOff(order.finalTotal);
      order.grandTotal = (order.finalTotal + order.roundOff).toPrecision(2);
      order.updatedAt = DateTime.now();
      await order.save();
    }
    else{
      order = Order(
        customerPhone: Common.activeCustomer?.phone,
        type: type,
        subTotal: OrderFunction.calculateSubtotal(cart).toPrecision(2),
        taxTotal: OrderFunction.calculateTaxAmount(cart).toPrecision(2),
        finalTotal: OrderFunction.calculateTotalWithTax(cart).toPrecision(2),
        roundOff: OrderFunction.calculateRoundOff(OrderFunction.calculateTotalWithTax(cart)).toPrecision(2),
        grandTotal: OrderFunction.calculatePayable(cart).toPrecision(2),
        totalQuantity: cart.length,
        discountTotal: 0,
      );
      await EateryDB.instance.orderBox?.put(order.id, order);
      for(var product in cart){
        var orderProduct = OrderProduct(
          orderId: order.id,
          productId: product.id,
          productName: product.name,
          quantity: 1,
          price: OrderFunction.calculateProductPriceWithoutTax(product).toPrecision(2),
          subTotal: OrderFunction.calculateProductPriceWithoutTax(product).toPrecision(2),
          taxRate: OrderFunction.getProductTaxRate(product)?.toPrecision(2),
          taxAmount: OrderFunction.calculateProductTaxAmount(product)?.toPrecision(2),
          total: (OrderFunction.calculateProductPriceWithoutTax(product) + (OrderFunction.calculateProductTaxAmount(product) ?? 0)).toPrecision(2),
        );
        await EateryDB.instance.orderProductBox?.put(orderProduct.id, orderProduct);
      }
    }

    if(type == OrderType.dine && diningTable != null){
      var diningTable = EateryDB.instance.diningTableBox?.values.firstWhere((element) => element.id == Common.activeDiningTable?.id);
      diningTable?.status = DiningTableStatus.occupied;
      diningTable?.orderId = order.id;
      await diningTable?.save();
    }



    EateryDB.instance.orderBox!.put(order.id, order).whenComplete(() {
      var printKOT = Common.activeOrderType == OrderType.dine;
      var printInvoice = Common.activeOrderType == OrderType.takeout || Common.activeOrderType == OrderType.delivery;
      List<Product> currentCart = List.from(Common.cart);

      Common.cart.clear();
      Common.activeOrder = null;
      Common.activeDiningTable = null;
      Common.activeCustomer = null;
      Common.activeOrderType = null;

      showMessageDialog(context, 'Order placed successfully', MessageType.success).whenComplete(() => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OrderPrintPage(order: order, currentCart: currentCart, printKOT: printKOT, printInvoice: printInvoice,)), (route) => false));
    }).onError((error, stackTrace) {
      showMessageDialog(context, 'Failed to place order', MessageType.error);
    });
  }

}

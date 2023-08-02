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
                    title: Row(
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
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
                              '${Common.currency?.symbol ?? ''}${(product.salePrice ?? product.mrpPrice)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${Common.currency?.symbol ?? ''}${(product.salePrice ?? product.mrpPrice) * Common.cart.where((element) => element.id == product.id).length}',
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          color: themeColor,
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              Common.cart.remove(product);
                            });
                          },
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Subtotal',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${Common.currency?.symbol ?? ''}${Common.cart.map((e) => e.salePrice ?? e.mrpPrice).reduce((value, element) => value + element)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PrimaryButton(
                      color: themeColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                      order: Order(
                                        customer: Common.activeCustomer!,
                                        products: Common.cart,
                                        type: Common.activeOrderType!,
                                      ),
                                    )));
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text('Checkout',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

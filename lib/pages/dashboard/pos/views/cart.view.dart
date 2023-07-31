import 'package:eatery/references.dart';

class CartView extends StatefulWidget {
  const CartView({super.key, required this.themeColor, this.setParentState, required this.orderType});

  final Color themeColor;
  final VoidCallback? setParentState;
  final OrderType orderType;

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.transparent,
        foregroundColor: KColors.black600,
      ),
      Divider(
        height: 0.5,
        color: Colors.grey[300],
      ),
      Expanded(
        child: ListView(
          children: [
            ...Common.cart.toSet()
                .map((product) => ListTile(
                      title: Text(product.name),
                      subtitle:
                          product.description != null ? Text(product.description!) : null,
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
                      trailing: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: widget.themeColor,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(2, 1, 2, 1),
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
                                        color: widget.themeColor,
                                        size: 24,
                                      ),
                                    )
                                  : Container(),
                              Common.cart.contains(product)
                                  ? Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 0, 4, 0),
                                      child: Text(
                                        Common.cart
                                            .where(
                                                (element) => element.id == product.id)
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
                                  color: widget.themeColor,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      )
    ]);
  }
}

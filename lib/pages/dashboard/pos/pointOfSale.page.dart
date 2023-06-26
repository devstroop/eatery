import 'package:eatery/constants/global_variables.dart';
import 'package:eatery/pages/dashboard/pos/views/dininigTableSelection.view.dart';
import 'package:eatery/pages/dashboard/pos/views/kProduct.view.dart';
import 'package:eatery/pages/dashboard/pos/views/waiterSelection.view.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/bottom_view_grip.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/components/pos_order_type_selection_button.dart';
import 'package:eatery/components/special_button.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery_db/eatery_db.dart';

import '../../../components/product_card.dart';
import '../../../services/utility/library_image.dart';
import '../../../widgets/posWidgets/circularCategory.posWidget.dart';
import '../../../widgets/textFields/search.textField.dart';
import 'views/cart.view.dart';

class PointOfSalePage extends StatefulWidget {
  const PointOfSalePage({Key? key}) : super(key: key);

  @override
  State<PointOfSalePage> createState() => _PointOfSalePageState();
}

class _PointOfSalePageState extends State<PointOfSalePage> {
  OrderType orderType = OrderType.dine;
  ProductCategory? selectedProductCategory;
  DiningTable? selectedDiningTable;

  final TextEditingController _controllerSearch = TextEditingController();
  final ScrollController _scrollControllerCategories = ScrollController();
  final ScrollController _scrollControllerProducts = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {

    });
  }

  @override
  Widget build(BuildContext context) {

    // final productsPanel = SizedBox(
    //   width: double.maxFinite,
    //   height: double.maxFinite,
    //   child: SingleChildScrollView(
    //     scrollDirection: Axis.vertical,
    //     child: productsData.isNotEmpty
    //         ? Wrap(
    //             alignment: WrapAlignment.center,
    //             children: [
    //               /*for (var product in productsData)
    //                 ProductCard(
    //                   currencySymbol: widget.account['currencySymbol'],
    //                   id: product['id'],
    //                   name: product['name'],
    //                   description: product['description'],
    //                   price: product['price'],
    //                   quantity: product['quantity'],
    //                   warningQuantity: product['warningQuantity'],
    //                   image: product['image'],
    //                   foodType: product['foodType'],
    //                   themeColor: orderType.color,
    //                   cartQuantity: Cart.cart.containsKey(product['id']) ? Cart.cart[product['id']]!['quantity'] : 0,
    //                   onAdd: () {
    //                     if (Cart.cart.containsKey(product['id'])) {
    //                       setState(() {
    //                         Cart.cart[product['id']]!['quantity'] += 1; // Unit value
    //                       });
    //                     } else {
    //                       setState(() {
    //                         Cart.cart[product['id']] = {
    //                           'name': product['name'],
    //                           'description': product['description'],
    //                           'price': product['price'],
    //                           'image': product['image'],
    //                           'tax': product['tax'],
    //                           'taxType': product['taxType'],
    //                           'quantity': 1.0, // Unit value
    //                           'unit': product['unit'],
    //                           'customizations': [],
    //                         };
    //                       });
    //                     }
    //                   },
    //                   onRemove: () async {
    //                     if (Cart.cart.containsKey(product['id']) && Cart.cart[product['id']]!['quantity'] > 1) {
    //                       setState(() {
    //                         Cart.cart[product['id']]!['quantity'] -= 1; // Unit value
    //                       });
    //                     } else if (Cart.cart.containsKey(product['id']) && Cart.cart[product['id']]!['quantity'] <= 1) {
    //                       setState(() {
    //                         Cart.cart.remove(product['id']);
    //                       });
    //                     }
    //                   },
    //                   onTap: () => showModalBottomSheet(
    //                       shape: const RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.only(
    //                           topLeft: Radius.circular(24),
    //                           topRight: Radius.circular(24),
    //                           bottomLeft: Radius.circular(0),
    //                           bottomRight: Radius.circular(0),
    //                         ),
    //                       ),
    //                       context: context,
    //                       builder: (context) => buildProductDetailedViewBottomSheet(product: product)),
    //                 ),*/
    //               // Cart.cart.isNotEmpty
    //               //     ? orderType == OrderType.dine
    //               //         ? Container(height: 120)
    //               //         : Container(height: 60)
    //               //     : Container()
    //             ],
    //           )
    //         : SizedBox(
    //             child: Padding(
    //               padding: EdgeInsets.only(
    //                 top: (MediaQuery.of(context).size.width <
    //                             MediaQuery.of(context).size.height
    //                         ? MediaQuery.of(context).size.width
    //                         : 0.0) *
    //                     0.5,
    //               ),
    //               child: Center(
    //                   child: Image.asset(
    //                 'assets/images/2748558.png',
    //                 width: (MediaQuery.of(context).size.width <
    //                             MediaQuery.of(context).size.height
    //                         ? MediaQuery.of(context).size.width
    //                         : MediaQuery.of(context).size.height) *
    //                     0.5,
    //               )),
    //             ),
    //           ),
    //   ),
    // );

    // final diningTableSelectionButton = orderType == OrderType.dine
    //     ? selectedDiningTableId != null
    //         ? FloatingActionButton.extended(
    //             backgroundColor: _pageColor,
    //             icon: const Icon(Icons.chair),
    //             label: Text(selectedDiningTableName!),
    //             onPressed: () => showModalBottomSheet(
    //                 shape: const RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(24),
    //                     topRight: Radius.circular(24),
    //                     bottomLeft: Radius.circular(0),
    //                     bottomRight: Radius.circular(0),
    //                   ),
    //                 ),
    //                 context: context,
    //                 builder: (context) => buildDiningTableViewBottomSheet()),
    //           )
    //         : FloatingActionButton.extended(
    //             backgroundColor: _pageColor,
    //             icon: const Icon(Icons.add),
    //             label: const Text('Select Table'),
    //             onPressed: () => showModalBottomSheet(
    //                 shape: const RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(24),
    //                     topRight: Radius.circular(24),
    //                     bottomLeft: Radius.circular(0),
    //                     bottomRight: Radius.circular(0),
    //                   ),
    //                 ),
    //                 context: context,
    //                 builder: (context) => buildDiningTableViewBottomSheet()),
    //           )
    //     : Container();

    // final cartStrip = GlobalVariables.cart.isNotEmpty
    //     ? Container(
    //         height: 48,
    //         width: double.maxFinite,
    //         color: Colors.green,
    //         child: Padding(
    //           padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
    //           child: InkWell(
    //             onTap: () => showModalBottomSheet(
    //                 shape: const RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(24),
    //                     topRight: Radius.circular(24),
    //                     bottomLeft: Radius.circular(0),
    //                     bottomRight: Radius.circular(0),
    //                   ),
    //                 ),
    //                 context: context,
    //                 builder: (context) => buildCartViewBottomSheet()),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 const Row(
    //                   children: [
    //                     /*Text(
    //                       '${Cart.cart.length} Item | ${widget.account['currencySymbol']}${Calculations.calculateTaxableTotal(cart: Cart.cart)}',
    //                       style: TextStyle(fontWeight: FontWeight.bold, color: ColorStyle.backgroundColorAlter),
    //                     )*/
    //                   ],
    //                 ),
    //                 Row(
    //                   children: [
    //                     Text(
    //                       'Cart',
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.bold,
    //                           color: ColorStyle.backgroundColorAlter),
    //                     ),
    //                     Icon(
    //                       Icons.arrow_right,
    //                       color: ColorStyle.backgroundColorAlter,
    //                     )
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       )
    //     : Container();

    Color _pageColor = Color(orderType.color ?? 0);
    List<ProductCategory> categories =
        EateryDB.instance.productCategoryBox.values.toList();
    List<Product> products =
        EateryDB.instance.productBox.values.where((element) {
      // TODO: implement build
      return true;
    }).toList();
    double crossAxisCount;
    double spacing;
    if (MediaQuery.of(context).size.width < 600) {
      crossAxisCount = 2;
      spacing = 12;
    } else if (MediaQuery.of(context).size.width < 900) {
      crossAxisCount = 3;
      spacing = 16;
    } else {
      crossAxisCount = 4;
      spacing = 24;
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          title: const Text('Point of Sale'),
          backgroundColor: _pageColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(UIcons.regularStraight.arrow_left),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          flexibleSpace: Container(
            margin: const EdgeInsets.only(top: 102, left: 12, right: 12),
            width: double.maxFinite,
            child: SearchTextField(
              controller: _controllerSearch,
              onChanged: (value) {
                // loadProducts();
              },
              themeColor: _pageColor,
              hintText: 'Search a product...',
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          Flexible(
            flex: 2,
            child: ListView(
              controller: _scrollControllerCategories,
              padding: const EdgeInsets.all(6.0),
              children: [
                CircularCategoryPOSWidget(
                  margin: const EdgeInsets.only(bottom: 6),
                  image: const AssetImage('assets/icons/all.png'),
                  themeColor: _pageColor,
                  selected: selectedProductCategory?.id == null,
                  onTap: () {
                    setState(() {
                      selectedProductCategory = null;
                    });
                  },
                  label: 'All',
                ),
                ...EateryDB.instance.productCategoryBox.values.map((each) {
                  return CircularCategoryPOSWidget(
                    margin: const EdgeInsets.only(bottom: 6),
                    image: LibraryImage(each.image).image,
                    themeColor: _pageColor,
                    selected: selectedProductCategory?.id == each.id,
                    onTap: () {
                      setState(() {
                        selectedProductCategory = each;
                      });
                    },
                    label: each.name,
                  );
                })
              ],
            ),
          ),
          Flexible(
              flex: 8,
              child: products.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: _scrollControllerProducts,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          ...products.map((product) {
                            final width =
                                ((MediaQuery.of(context).size.width * 0.8 - 1)
                                            .abs() -
                                        (crossAxisCount + 1) * spacing) /
                                    crossAxisCount;
                            final height = width * 4 / 3;
                            return ProductCard(
                              product: product,
                              width: width,
                              height: height,
                              themeColor: _pageColor,
                              onAdd: () {
                                setState(() {
                                  GlobalVariables.cart.add(product);
                                });
                              },
                              onRemove: () {
                                setState(() {
                                  GlobalVariables.cart.remove(product);
                                });
                              },
                              onTap: () => _showProductDetails(product),
                            );
                          })
                        ],
                      ),
                    )
                  : Center(
                      child: Opacity(
                        opacity: 0.50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty-folder.png',
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                              'No dish found',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Add a dish to get started',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                            const SizedBox(
                              height: 48,
                            ),
                          ],
                        ),
                      ),
                    )),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PosOrderTypeSelectionButton(
              onTap: _showOrderTypeSelection,
              iconData: orderType.icon!,
              themeColor: _pageColor,
              text: orderType.name!,
            ),
            if (orderType == OrderType.dine) // dining table selection
              IconButton(
                  onPressed: _pickDiningTable,
                  icon: Icon(
                    UIcons.regularStraight.chair,
                    color: _pageColor,
                  )),
            if (orderType == OrderType.dine) // waiter selection
              IconButton(
                  onPressed: _pickWaiter,
                  icon: Icon(
                    UIcons.regularStraight.man_head,
                    color: _pageColor,
                  )),
            if (orderType == OrderType.delivery)
              IconButton(
                  onPressed: _pickDeliveryLocation,
                  icon: Icon(
                    UIcons.regularStraight.map_marker,
                    color: _pageColor,
                  )),


            IconButton(
                onPressed: _cartView,
                icon: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: _pageColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(
                        UIcons.regularStraight.shopping_cart,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        ' ${GlobalVariables.cart.length}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                )),


            if (GlobalVariables.cart.isNotEmpty && GlobalVariables.expressMode)
              IconButton(
                  onPressed: _expressCheckout,
                  icon: Icon(
                    UIcons.regularStraight.angle_double_right,
                    color: _pageColor,
                  )),
            if (GlobalVariables.cart.isNotEmpty && !GlobalVariables.expressMode)
              IconButton(
                  onPressed: _checkout,
                  icon: Icon(
                    UIcons.regularStraight.angle_right,
                    color: _pageColor,
                  )),
          ],
        ),
      ),
    );
  }

  void _pickDiningTable() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        builder: (context) => const DiningTableSelectionView());
  }

  void _pickDeliveryLocation() {
  }

  void _expressCheckout() {
  }

  void _checkout() {
  }

  void _cartView() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        builder: (context) =>
        // StatefulBuilder(builder: (context, state) => const CartPage())
        const CartView()
    );
  }

  void _showProductDetails(Product product) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        context: context,
        builder: (context) =>
            KProductView(product: product));
  }

  void _pickWaiter() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        builder: (context) => const WaiterSelectionView());
  }

  void _showOrderTypeSelection() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        context: context,
        builder: (context) => ListView(
          shrinkWrap: true,
          children: [
            const Center(
              child: BottomViewGrip(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  16.0, 12.0, 16.0, 12.0),
              child: Text(
                'Select a order type',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: ColorStyle.text200),
              ),
            ),
            for (var orderType in OrderType.values)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: SpecialButton(
                  icon: orderType.icon!,
                  text: orderType.name!,
                  color: Color(orderType.color!),
                  foreColor: Colors.white,
                  onTap: () {
                    setState(() {
                      this.orderType = orderType;
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ));
  }
}

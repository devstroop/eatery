import 'dart:io';
import 'package:eatery/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/bottom_view_grip.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/components/pos_order_type_selection_button.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/components/special_button.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery_db/eatery_db.dart';

import '../../../widgets/textFields/search.textField.dart';

class PointOfSalePage extends StatefulWidget {
  const PointOfSalePage({Key? key}) : super(key: key);

  @override
  State<PointOfSalePage> createState() => _PointOfSalePageState();
}

class _PointOfSalePageState extends State<PointOfSalePage> {
  Offset position = const Offset(20.0, 20.0);
  String? openOrderId;
  String? openOrderCustomerName;
  String? openOrderCustomerPhone;
  String? openOrderCustomerAddress;
  String? openOrderWaiterId;
  String? openOrderWaiterName;

  late OrderType orderType;
  late String? selectedProductCategory;
  late String? selectedDiningTableCategory;
  late String? selectedDiningTableId;
  late String? selectedDiningTableName;
  final TextEditingController _controllerSearch = TextEditingController();
  late List<Map<String, dynamic>> productCategoriesData;
  late List<Map<String, dynamic>> productsData;
  bool posModeChangeExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      setState(() {
        orderType = OrderType.dine;
        selectedProductCategory = null;
        selectedDiningTableCategory = null;
        selectedDiningTableId = null;
        selectedDiningTableName = null;
        productCategoriesData = [];
        productsData = [];
      });
      loadCategories();
      loadProducts();  
    });
  }

  void loadCategories() async {
    /*var productCategoriesData = await ProductCategoryOld.getAll();
    setState(() {
      this.productCategoriesData = productCategoriesData;
    });*/
  }

  void loadProducts() async {
    /*var productsData = await Product.getAll(category: selectedProductCategory, query: _controllerSearch.text);
    setState(() {
      this.productsData = productsData;
    });*/
  }

  Widget buildDiningTableViewBottomSheet() =>
      StatefulBuilder(builder: (context, state) {
        return ListView(shrinkWrap: true, children: [
          const Center(
            child: BottomViewGrip(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            child: Text(
              'Select Dining Table',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: ColorStyle.text200),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 60,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    PosCategoryWidget(
                        active: selectedDiningTableCategory == null,
                        image: Image.asset(
                          'assets/images/all.png',
                          width: 18,
                          height: 18,
                          fit: BoxFit.cover,
                        ),
                        label: 'All',
                        onTap: () {
                          selectedDiningTableCategory = null;
                          setState(() {});
                          state(() {});
                        }),
                    // FutureBuilder(
                    //     future: DiningTableCategory.getAll(),
                    //     builder: (BuildContext context,
                    //         AsyncSnapshot<dynamic> snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.done) {
                    //         if (snapshot.hasData) {
                    //           return Row(
                    //             children: [
                    //               for (var diningTableCategory in snapshot.data)
                    //                 PosCategoryWidget(
                    //                     active: selectedDiningTableCategory ==
                    //                         diningTableCategory['id'],
                    //                     image: diningTableCategory['image'] !=
                    //                                 null &&
                    //                             File(diningTableCategory[
                    //                                     'image'])
                    //                                 .existsSync()
                    //                         ? Image.file(File(
                    //                             diningTableCategory['image']))
                    //                         : null,
                    //                     label: diningTableCategory['name'],
                    //                     onTap: () {
                    //                       selectedDiningTableCategory =
                    //                           diningTableCategory['id'];
                    //                       setState(() {});
                    //                       state(() {});
                    //                     })
                    //             ],
                    //           );
                    //         }
                    //         return Container();
                    //       } else {
                    //         return LoadingScreen();
                    //       }
                    //     }),
                  ],
                ),
              ),
            ),
          ),
          // FutureBuilder(
          //     future: DiningTable.getAll(category: selectedDiningTableCategory),
          //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         if (snapshot.hasData && snapshot.data.isNotEmpty) {
          //           return Wrap(
          //             alignment: WrapAlignment.center,
          //             children: [
          //               DiningTableCard(
          //                 active: selectedDiningTableId == null,
          //                 id: null,
          //                 name: 'None',
          //                 onTap: () {
          //                   selectedDiningTableId = null;
          //                   selectedDiningTableName = null;
          //                   setState(() {});
          //                   state(() {});
          //                   // Navigator.of(context).pop();
          //                 },
          //               ),
          //               /*for (var _diningTable in snapshot.data)
          //                 DiningTableCard(
          //                   active: selectedDiningTableId == _diningTable['id'],
          //                   id: _diningTable['id'],
          //                   name: _diningTable['name'],
          //                   currencySymbol: widget.account['currencySymbol'],
          //                   due: _diningTable['due'],
          //                   onTap: () async {
          //                     selectedDiningTableId = _diningTable['id'];
          //                     selectedDiningTableName = _diningTable['name'];
          //                     if(_diningTable['due'] != null){
          //                       Map<String, dynamic>? _order = await Order.get(_diningTable['orderId']);
          //                       orderType = OrderType.dineIn;
          //                       Cart.cart = Map<String, Map<String, dynamic>>.from(_order!['cart']);
          //                       openOrderId = _diningTable['orderId'];
          //                       openOrderCustomerName = _diningTable['customerName'];
          //                       openOrderCustomerPhone = _diningTable['customerPhone'];
          //                       openOrderCustomerAddress = _diningTable['customerAddress'];
          //                       openOrderWaiterId = _diningTable['customerPhone'];
          //                       openOrderWaiterName = _diningTable['customerAddress'];
          //                     }
          //                     setState(() {});
          //                     state(() {});
          //                     // Navigator.of(context).pop();
          //                   },
          //                 )*/
          //             ],
          //           );
          //         }
          //         return SizedBox(
          //           child: Center(
          //               child: Image.asset(
          //             'assets/images/2748558.png',
          //             width: (MediaQuery.of(context).size.width <
          //                         MediaQuery.of(context).size.height
          //                     ? MediaQuery.of(context).size.width
          //                     : MediaQuery.of(context).size.height) *
          //                 0.5,
          //           )),
          //         );
          //       } else {
          //         return LoadingScreen();
          //       }
          //     }),
          const SizedBox(
            height: 20.0,
          ),
        ]);
      });

  Widget buildCartViewBottomSheet() =>
      StatefulBuilder(builder: (context, state) {
        return ListView(shrinkWrap: true, children: [
          const Center(
            child: BottomViewGrip(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cart',
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: ColorStyle.text200),
                ),
                Row(
                  children: [
                    Text(
                      'Subtotal',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          color: ColorStyle.text200),
                    ),
                    const SizedBox(
                      width: 6.0,
                    ),
                    /*Text(
                      '${widget.account['currencySymbol']}${Calculations.calculateTaxableTotal(cart: Cart.cart)}',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                    )*/
                  ],
                )
              ],
            ),
          ),
          /*for (var id in Cart.cart.keys)
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
              child: CartProductCard(
                id: id,
                name: Cart.cart[id]!['name'],
                description: Cart.cart[id]!['description'],
                priceTotal: Cart.cart[id]!['price'] * Cart.cart[id]!['quantity'],
                image: Cart.cart[id]!['image'],
                cartQuantity: Cart.cart[id]!['quantity'],
                currencySymbol: widget.account['currencySymbol'],
                mode: 0,
                onAdd: () {
                  if (Cart.cart.containsKey(id)) {
                    Cart.cart[id]!['quantity'] += 1; // Unit value
                    setState(() {});
                    state(() {});
                  }
                },
                onRemove: () {
                  if (Cart.cart.containsKey(id) && Cart.cart[id]!['quantity'] > 1) {
                    Cart.cart[id]!['quantity'] -= 1; // Unit value
                    setState(() {});
                    state(() {});
                  } else if (Cart.cart.containsKey(id) && Cart.cart[id]!['quantity'] <= 1) {
                    Cart.cart.remove(id);
                    setState(() {});
                    state(() {});
                    if (Cart.cart.isEmpty) {
                      Navigator.of(context).pop();
                    }
                  }
                  state(() {});
                  setState(() {});
                },
                onDeleteAll: () {
                  Cart.cart.remove(id);
                  state(() {});
                  setState(() {});
                  if (Cart.cart.isEmpty) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),*/
          const SizedBox(
            height: 20.0,
          ),
        ]);
      });

  Widget buildProductDetailedViewBottomSheet(
          {required Map<String, dynamic> product}) =>
      StatefulBuilder(builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          children: const [
            Center(
              child: BottomViewGrip(),
            ),
            ////////////////////////////////////////////////////////////
            /*DetailedProductView(
              currencySymbol: widget.account['currencySymbol'],
              id: product['id'],
              name: product['name'],
              description: product['description'],
              price: product['price'],
              quantity: product['quantity'],
              warningQuantity: product['warningQuantity'],
              image: product['image'],
              foodType: product['foodType'],
              themeColor: orderType.color,
              onAdd: () {
                if (Cart.cart.containsKey(product['id'])) {
                  Cart.cart[product['id']]!['quantity'] += 1; // Unit value
                  setState(() {});
                  state(() {});
                } else {
                  Cart.cart[product['id']] = {
                    'name': product['name'],
                    'description': product['description'],
                    'price': product['price'],
                    'image': product['image'],
                    'tax': product['tax'],
                    'taxType': product['taxType'],
                    'quantity': 1.0, // Unit value
                    'unit': product['unit'],
                    'customizations': [],
                  };
                  setState(() {});
                  state(() {});
                }
              },
              onRemove: () async {
                if (Cart.cart.containsKey(product['id']) && Cart.cart[product['id']]!['quantity'] > 1) {
                  Cart.cart[product['id']]!['quantity'] -= 1; // Unit value
                  setState(() {});
                  state(() {});
                } else if (Cart.cart.containsKey(product['id']) && Cart.cart[product['id']]!['quantity'] <= 1) {
                  Cart.cart.remove(product['id']);
                  setState(() {});
                  state(() {});
                }
              },
            ),*/

            ////////////////////////////////////////////////////////////
            SizedBox(
              height: 20.0,
            ),
          ],
        );
      });

  @override
  Widget build(BuildContext context) {
    Color _pageColor = Color(orderType.color!);
    final appBar = PreferredSize(
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
          child: InkWell(
            onTap: () {
            Focus.of(context).unfocus();
          },
          child: SearchTextField(
            controller: _controllerSearch,
            onChanged: (value) {
              loadProducts();
            },
            themeColor: _pageColor,
            hintText: 'Search a product...',
          ),
        ),
      ),
    );

    final categoryBar = SizedBox(
      width: double.maxFinite,
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Stack(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  PosCategoryWidget(
                      active: selectedProductCategory == null,
                      image: Image.asset(
                        'assets/images/all.png',
                        width: 18,
                        height: 18,
                        fit: BoxFit.cover,
                      ),
                      label: 'All',
                      onTap: () {
                        setState(
                          () {
                            selectedProductCategory = null;
                          },
                        );
                        loadProducts();
                      }),
                  Row(
                    children: [
                      for (var category in productCategoriesData)
                        PosCategoryWidget(
                            active: selectedProductCategory == category['id'],
                            image: category['image'] != null &&
                                    File(category['image']).existsSync()
                                ? Image.file(File(category['image']))
                                : null,
                            label: category['name'],
                            onTap: () {
                              setState(
                                () {
                                  selectedProductCategory = category['id'];
                                },
                              );
                              loadProducts();
                            })
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final productsPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: productsData.isNotEmpty
            ? Wrap(
                alignment: WrapAlignment.center,
                children: [
                  /*for (var product in productsData)
                    ProductCard(
                      currencySymbol: widget.account['currencySymbol'],
                      id: product['id'],
                      name: product['name'],
                      description: product['description'],
                      price: product['price'],
                      quantity: product['quantity'],
                      warningQuantity: product['warningQuantity'],
                      image: product['image'],
                      foodType: product['foodType'],
                      themeColor: orderType.color,
                      cartQuantity: Cart.cart.containsKey(product['id']) ? Cart.cart[product['id']]!['quantity'] : 0,
                      onAdd: () {
                        if (Cart.cart.containsKey(product['id'])) {
                          setState(() {
                            Cart.cart[product['id']]!['quantity'] += 1; // Unit value
                          });
                        } else {
                          setState(() {
                            Cart.cart[product['id']] = {
                              'name': product['name'],
                              'description': product['description'],
                              'price': product['price'],
                              'image': product['image'],
                              'tax': product['tax'],
                              'taxType': product['taxType'],
                              'quantity': 1.0, // Unit value
                              'unit': product['unit'],
                              'customizations': [],
                            };
                          });
                        }
                      },
                      onRemove: () async {
                        if (Cart.cart.containsKey(product['id']) && Cart.cart[product['id']]!['quantity'] > 1) {
                          setState(() {
                            Cart.cart[product['id']]!['quantity'] -= 1; // Unit value
                          });
                        } else if (Cart.cart.containsKey(product['id']) && Cart.cart[product['id']]!['quantity'] <= 1) {
                          setState(() {
                            Cart.cart.remove(product['id']);
                          });
                        }
                      },
                      onTap: () => showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
                          ),
                          context: context,
                          builder: (context) => buildProductDetailedViewBottomSheet(product: product)),
                    ),*/
                  // Cart.cart.isNotEmpty
                  //     ? orderType == OrderType.dine
                  //         ? Container(height: 120)
                  //         : Container(height: 60)
                  //     : Container()
                ],
              )
            : SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.width <
                                MediaQuery.of(context).size.height
                            ? MediaQuery.of(context).size.width
                            : 0.0) *
                        0.5,
                  ),
                  child: Center(
                      child: Image.asset(
                    'assets/images/2748558.png',
                    width: (MediaQuery.of(context).size.width <
                                MediaQuery.of(context).size.height
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.height) *
                        0.5,
                  )),
                ),
              ),
      ),
    );

    final bottomAppBar = Container(
      width: double.maxFinite,
      height: 72,
      decoration: BoxDecoration(
        color: ColorStyle.backgroundColorAlter,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: PosOrderTypeSelectionButton(
                onTap: () => showModalBottomSheet(
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
                                'Select type of order',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: ColorStyle.text200),
                              ),
                            ),
                            for (var orderType in OrderType.values)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 4, 12, 8),
                                child: SpecialButton(
                                  icon: orderType.icon!,
                                  text: orderType.name!,
                                  color: _pageColor,
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
                        )),
                iconData: orderType.icon!,
                themeColor: _pageColor,
                text: orderType.name!,
              ),
            ),
            Flexible(
              flex: 1,
              child: PrimaryButton(
                color: _pageColor,
                onPressed: () {
                  // if (Cart.cart.isEmpty) {
                  //   showSnackBar(context, '* Empty cart');
                  //   return;
                  // }
                  // if (orderType == OrderType.dine &&
                  //     selectedDiningTableId == null) {
                  //   showSnackBar(context, '* Select dining table');
                  //   return;
                  // }
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                              account: widget.account,
                              orderType: orderType,
                              cart: Cart.cart,
                              diningTable: selectedDiningTableId,
                              diningTableName: selectedDiningTableName,
                          openOrderId: openOrderId,
                          openOrderCustomerName: openOrderCustomerName,
                          openOrderCustomerPhone: openOrderCustomerPhone,
                          openOrderCustomerAddress: openOrderCustomerAddress,
                            )),
                  ).then((value) {
                    if (value == "changeOrderType") {
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
                          builder: (context) => buildPOSModeSelectionBottomSheet());
                    } else if (value == 'cartUpdate') {
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
                          builder: (context) => buildCartViewBottomSheet());
                    }else if (value == 'clear'){
                      selectedDiningTableCategory = null;
                      selectedDiningTableId = null;
                      selectedDiningTableName = null;
                      selectedProductCategory = null;
                    }
                    setState((){});
                  });*/
                },
                child: const Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );

    final diningTableSelectionButton = orderType == OrderType.dine
        ? selectedDiningTableId != null
            ? FloatingActionButton.extended(
                backgroundColor: _pageColor,
                icon: const Icon(Icons.chair),
                label: Text(selectedDiningTableName!),
                onPressed: () => showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    context: context,
                    builder: (context) => buildDiningTableViewBottomSheet()),
              )
            : FloatingActionButton.extended(
                backgroundColor: _pageColor,
                icon: const Icon(Icons.add),
                label: const Text('Select Table'),
                onPressed: () => showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    context: context,
                    builder: (context) => buildDiningTableViewBottomSheet()),
              )
        : Container();

    final cartStrip = GlobalVariables.cart.isNotEmpty
        ? Container(
            height: 48,
            width: double.maxFinite,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: InkWell(
                onTap: () => showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    context: context,
                    builder: (context) => buildCartViewBottomSheet()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        /*Text(
                          '${Cart.cart.length} Item | ${widget.account['currencySymbol']}${Calculations.calculateTaxableTotal(cart: Cart.cart)}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: ColorStyle.backgroundColorAlter),
                        )*/
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Cart',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorStyle.backgroundColorAlter),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: ColorStyle.backgroundColorAlter,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: categoryBar,
          ),
          Positioned(
              top: 60.0,
              left: 0.0,
              right: 0.0,
              bottom: 72,
              child: productsPanel),
          Positioned(left: 0.0, right: 0.0, bottom: 72, child: cartStrip),
          Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: bottomAppBar),
          Positioned(
            bottom: GlobalVariables.cart.isNotEmpty ? 132.0 : 84.0,
            right: 12.0,
            child: Draggable(
                feedback: diningTableSelectionButton,
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    position = details.offset;
                  });
                },
                child: diningTableSelectionButton),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/bottom_view_grip.dart';
import 'package:restaurant_pos/components/cart_product_card.dart';
import 'package:restaurant_pos/components/detailed_product_view.dart';
import 'package:restaurant_pos/components/dining_table_card.dart';
import 'package:restaurant_pos/components/food_type_badge.dart';
import 'package:restaurant_pos/components/pos_category_widget.dart';
import 'package:restaurant_pos/components/pos_order_type_selection_button.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/product_card.dart';
import 'package:restaurant_pos/components/special_button.dart';
import 'package:restaurant_pos/database/cart.dart';
import 'package:restaurant_pos/database/dining_table.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';

import 'package:restaurant_pos/database/product.dart';
import 'package:restaurant_pos/database/product_category.dart';
import 'package:restaurant_pos/extensions/calculations.dart';
import 'package:restaurant_pos/models/order_type.dart';
import 'package:restaurant_pos/style/color_style.dart';

class PointOfSalePage extends StatefulWidget {
  const PointOfSalePage({Key? key, required this.account}) : super(key: key);
  final dynamic account;

  @override
  State<PointOfSalePage> createState() => _PointOfSalePageState();
}

class _PointOfSalePageState extends State<PointOfSalePage> {
  Offset position = const Offset(20.0, 20.0);
  late OrderType orderType;
  late String? selectedProductCategory;
  late String? selectedDiningTableCategory;
  late String? selectedDiningTable;
  late String? selectedDiningTableName;
  late TextEditingController _controllerSearch;
  late List<Map<String, dynamic>> productCategoriesData;
  late List<Map<String, dynamic>> productsData;
  bool posModeChangeExpanded = false;

  @override
  void initState() {
    super.initState();
    _controllerSearch = TextEditingController();
    setState(() {
      orderType = OrderType.dineIn;
      selectedProductCategory = null;
      selectedDiningTableCategory = null;
      selectedDiningTable = null;
      selectedDiningTableName = null;
      productCategoriesData = [];
      productsData = [];
    });
    loadCategories();
    loadProducts();
  }

  void loadCategories() async {
    var productCategoriesData = await ProductCategory.getAll();
    setState(() {
      this.productCategoriesData = productCategoriesData;
    });
  }

  void loadProducts() async {
    var productsData = await Product.getAll(category: selectedProductCategory);
    setState(() {
      this.productsData = productsData;
    });
  }

  Widget buildPOSModeSelectionBottomSheet() => ListView(
        shrinkWrap: true,
        children: [
          const Center(
            child: BottomViewGrip(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            child: Text(
              'Select type of order',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
            ),
          ),
          for (var orderType in OrderType.values)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: SpecialButton(
                icon: orderType.icon!,
                text: orderType.text!,
                color: orderType.color!,
                foreColor: orderType.foreColor!,
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
      );

  Widget buildDiningTableViewBottomSheet() => StatefulBuilder(builder: (context, state) {
        return ListView(shrinkWrap: true, children: [
          const Center(
            child: BottomViewGrip(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            child: Text(
              'Select Dining Table',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
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
                    FutureBuilder(
                        future: DiningTableCategory.getAll(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Row(
                                children: [
                                  for (var diningTableCategory in snapshot.data)
                                    PosCategoryWidget(
                                        active: selectedDiningTableCategory == diningTableCategory['id'],
                                        image: diningTableCategory['image'] != null &&
                                                File(diningTableCategory['image']).existsSync()
                                            ? Image.file(File(diningTableCategory['image']))
                                            : null,
                                        label: diningTableCategory['name'],
                                        onTap: () {
                                          selectedDiningTableCategory = diningTableCategory['id'];
                                          setState(() {});
                                          state(() {});
                                        })
                                ],
                              );
                            }
                            return Container();
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder(
              future: DiningTable.getAll(category: selectedDiningTableCategory),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    return Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        DiningTableCard(
                          active: selectedDiningTable == null,
                          id: null,
                          name: 'None',
                          image: null,
                          onTap: () {
                            selectedDiningTable = null;
                            selectedDiningTableName = null;
                            setState(() {});
                            state(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                        for (var product in snapshot.data)
                          DiningTableCard(
                            active: selectedDiningTable == product['id'],
                            id: product['id'],
                            name: product['name'],
                            image: product['image'],
                            onTap: () {
                              selectedDiningTable = product['id'];
                              selectedDiningTableName = product['name'];
                              setState(() {});
                              state(() {});
                              Navigator.of(context).pop();
                            },
                          )
                      ],
                    );
                  }
                  return SizedBox(
                    child: Center(
                        child: Image.asset(
                      'assets/images/2748558.png',
                      width: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
                              ? MediaQuery.of(context).size.width
                              : MediaQuery.of(context).size.height) *
                          0.5,
                    )),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          const SizedBox(
            height: 20.0,
          ),
        ]);
      });

  Widget buildCartViewBottomSheet() => StatefulBuilder(builder: (context, state) {
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
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                ),
                Row(
                  children: [
                    Text(
                      'Subtotal',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: ColorStyle.text200),
                    ),
                    const SizedBox(width: 6.0,),
                    Text(
                      '${widget.account['currencySymbol']}${Calculations.calculateSubtotal()}',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                    )
                  ],
                )
              ],
            ),
          ),
          for (var id in Cart.cart.keys)
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
              child: CartProductCard(
                id: id,
                name: Cart.cart[id]!['name'],
                description: Cart.cart[id]!['description'],
                price: Cart.cart[id]!['price'] * Cart.cart[id]!['quantity'],
                customizationPrice: Calculations.calculateCustomizationsTotal(Cart.cart[id]!['customizations']),
                image: Cart.cart[id]!['image'],
                cartQuantity: Cart.cart[id]!['quantity'],
                currencySymbol: widget.account['currencySymbol'],
                onAdd: () {
                  print(Cart.cart[id]);
                  /*Cart.cart.add({
                    'id': each['id'],
                    'customization': 'NA',
                    'price': each['price'],
                    'name': each['name'],
                    'description': each['description'],
                    'image': each['image']
                  });*/
                  state(() {});
                  setState(() {});
                },
                onRemove: () {
                  print(Cart.cart[id]);
                  /*if (Cart.cart.where((element) => element['id'] == each['id']).isNotEmpty) {
                    Cart.cart.remove(Cart.cart.where((element) => element['id'] == each['id']).last);
                  }*/
                  state(() {});
                  setState(() {});
                },
                onDeleteAll: (){},
              ),
            ),
          const SizedBox(
            height: 20.0,
          ),
        ]);
      });

  Widget buildWaiterSelectionViewBottomSheet() => StatefulBuilder(builder: (context, state) {
        return ListView(shrinkWrap: true, children: [
          const Center(
            child: BottomViewGrip(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            child: Text(
              'Select Waiter',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ]);
      });

  Widget buildProductDetailedViewBottomSheet({required Map<String, dynamic> product}) =>
      StatefulBuilder(builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          children: [
            const Center(
              child: BottomViewGrip(),
            ),
            ////////////////////////////////////////////////////////////
            DetailedProductView(
              currencySymbol: widget.account['currencySymbol'],
              id: product['id'],
              name: product['name'],
              description: product['description'],
              mrp: product['mrp'],
              salePrice: product['salePrice'],
              quantity: product['quantity'],
              warningQuantity: product['warningQuantity'],
              image: product['image'],
              foodType: product['foodType'],
              themeColor: orderType.color,
              onAdd: () {
                if(Cart.cart.containsKey(product['id'])){
                  Cart.cart[product['id']]!['quantity'] += 1; // Unit value
                  setState(() {});
                  state(() {});
                }
                else{
                  Cart.cart[product['id']] = {
                    'name': product['name'],
                    'description': product['description'],
                    'price': Calculations.getProductBillingPrice(
                        mrp: product['mrp'] != null ? double.parse(product['mrp']) : null, salePrice: product['salePrice'] != null ? double.parse(product['salePrice']) : null),
                    'image': product['image'],
                    'discount': product['discount'],
                    'tax': product['tax'],
                    'quantity': 1.0, // Unit value
                    'unit': product['unit'],
                    'customizations': [],

                  };
                  setState(() {});
                  state(() {});
                }
              },
              onRemove: () async {
                if(Cart.cart.containsKey(product['id']) && Cart.cart[product['id']]!['quantity'] > 1){
                  Cart.cart[product['id']]!['quantity'] -= 1; // Unit value
                  setState(() {});
                  state(() {});
                } else if(Cart.cart.containsKey(product['id']) && Cart.cart[product['id']]!['quantity'] <= 1){
                  Cart.cart.remove([product['id']]);
                  setState(() {});
                  state(() {});
                }
              },
            ),

            ////////////////////////////////////////////////////////////
            const SizedBox(
              height: 20.0,
            ),
          ],
        );
      });

  @override
  Widget build(BuildContext context) {
    final appBar = PreferredSize(
      child: AppBar(
        title: const Text('POS'),
        backgroundColor: orderType.color,
        flexibleSpace: Container(
          margin: const EdgeInsets.only(top: 90, left: 12, right: 12),
          width: double.maxFinite,
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: _controllerSearch,
            decoration: InputDecoration(
              hintText: 'Search a product...',
              hintStyle: TextStyle(
                color: ColorStyle.text400,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              //prefixIcon: const Icon(Icons.search),
              //prefixIconColor: ColorStyle.text100,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorStyle.text400,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: orderType.color!.withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
            ),
            style: TextStyle(
              color: ColorStyle.text200,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      preferredSize: const Size.fromHeight(116),
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
                            image: File(category['image']).existsSync() ? Image.file(File(category['image'])) : null,
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
                  for (var product in productsData)
                    ProductCard(
                      currencySymbol: widget.account['currencySymbol'],
                      id: product['id'],
                      name: product['name'],
                      description: product['description'],
                      billingPrice:
                      Calculations.getProductBillingPrice(
                          mrp: product['mrp'] != null ? double.parse(product['mrp']) : null, salePrice: product['salePrice'] != null ? double.parse(product['salePrice']) : null),
                      otherPrice:
                      Calculations.getProductOtherPrice(
                          mrp: product['mrp'] != null ? double.parse(product['mrp']) : null, salePrice: product['salePrice'] != null ? double.parse(product['salePrice']) : null),
                      quantity: product['quantity'],
                      warningQuantity: product['warningQuantity'],
                      image: product['image'],
                      foodType: product['foodType'],
                      themeColor: orderType.color,
                      cartQuantity: Cart.cart.containsKey(product['id']) ? Cart.cart[product['id']]!['quantity'] : 0,
                      onAdd: () {
                        if(Cart.cart.containsKey(product['id'])){
                          setState((){
                            Cart.cart[product['id']]!['quantity'] += 1; // Unit value
                          });
                        }
                        else{
                          setState((){
                            Cart.cart[product['id']] = {
                              'name': product['name'],
                              'description': product['description'],
                              'price': Calculations.getProductBillingPrice(
                                  mrp: product['mrp'] != null ? double.parse(product['mrp']) : null, salePrice: product['salePrice'] != null ? double.parse(product['salePrice']) : null),
                              'image': product['image'],
                              'discount': product['discount'],
                              'tax': product['tax'],
                              'quantity': 1.0, // Unit value
                              'unit': product['unit'],
                              'customizations': [],

                            };
                          });
                        }
                      },
                      onRemove: () async {
                        if(Cart.cart.containsKey(product['id']) && Cart.cart[product['id']]!['quantity'] > 1){
                          setState((){
                            Cart.cart[product['id']]!['quantity'] -= 1; // Unit value
                          });
                        } else if(Cart.cart.containsKey(product['id']) && Cart.cart[product['id']]!['quantity'] <= 1){
                          setState((){
                            Cart.cart.remove([product['id']]);
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
                    ),
                  Cart.cart.isNotEmpty
                      ? orderType == OrderType.dineIn
                          ? Container(height: 120)
                          : Container(height: 60)
                      : Container()
                ],
              )
            : SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
                            ? MediaQuery.of(context).size.width
                            : 0.0) *
                        0.5,
                  ),
                  child: Center(
                      child: Image.asset(
                    'assets/images/2748558.png',
                    width: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
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
        color: ColorStyle.background200,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
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
                    builder: (context) => buildPOSModeSelectionBottomSheet()),
                iconData: orderType.icon!,
                themeColor: orderType.color!,
                text: orderType.text!,
              ),
            ),
            Flexible(
              flex: 1,
              child: PrimaryButton(
                color: orderType.foreColor!,
                text: 'Checkout',
                height: 50.0,
                backgroundColor: orderType.color!,
              ),
            ),
          ],
        ),
      ),
    );

    final diningTableSelectionButton = orderType == OrderType.dineIn
        ? selectedDiningTable != null
            ? FloatingActionButton.extended(
                backgroundColor: orderType.color,
                icon: const Icon(Icons.local_dining),
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
                backgroundColor: orderType.color,
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

    final waiterSelectionButton = orderType == OrderType.dineIn
        ? selectedDiningTable != null
            ? FloatingActionButton.extended(
                backgroundColor: orderType.color,
                icon: const Icon(Icons.local_dining),
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
                    builder: (context) => buildWaiterSelectionViewBottomSheet()),
              )
            : FloatingActionButton.extended(
                backgroundColor: orderType.color,
                icon: const Icon(Icons.add),
                label: const Text('Select Waiter'),
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
                    builder: (context) => buildWaiterSelectionViewBottomSheet()),
              )
        : Container();

    final cartStrip = Cart.cart.isNotEmpty
        ? Container(
            height: 48,
            width: double.maxFinite,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${Cart.cart.length} Item | ${widget.account['currencySymbol']}${Calculations.calculateSubtotal()}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: ColorStyle.background200),
                      )
                    ],
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        Text(
                          'Cart',
                          style: TextStyle(fontWeight: FontWeight.bold, color: ColorStyle.background200),
                        ),
                        Icon(
                          Icons.arrow_drop_up_outlined,
                          color: ColorStyle.background200,
                        )
                      ],
                    ),
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
                  ),
                ],
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
          Positioned(top: 60.0, left: 0.0, right: 0.0, bottom: 72, child: productsPanel),
          Positioned(left: 0.0, right: 0.0, bottom: 72, child: cartStrip),
          Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: bottomAppBar),
          Positioned(
            bottom: Cart.cart.isNotEmpty ? 132.0 : 84.0,
            right: 12.0,
            child: Draggable(
                feedback: diningTableSelectionButton,
                child: diningTableSelectionButton,
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    position = details.offset;
                  });
                  print(position);
                  print(position.dx);
                  print(position.dy);
                }),
          ),
          /*Positioned(
            bottom: Cart.cart.isNotEmpty ? 132.0 : 84.0,
            left: 12.0,
            child: Draggable(
                feedback: waiterSelectionButton,
                child: waiterSelectionButton,
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    position = details.offset;
                  });
                  print(position);
                  print(position.dx);
                  print(position.dy);
                }),
          ),*/
        ],
      ),
    );
  }
}

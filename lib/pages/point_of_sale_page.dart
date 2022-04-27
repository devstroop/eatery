import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/bottom_view_grip.dart';
import 'package:restaurant_pos/components/detailed_product_view.dart';
import 'package:restaurant_pos/components/food_type_badge.dart';
import 'package:restaurant_pos/components/pos_category_widget.dart';
import 'package:restaurant_pos/components/pos_order_type_selection_button.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/product_card.dart';
import 'package:restaurant_pos/components/special_button.dart';
import 'package:restaurant_pos/database/cart.dart';

import 'package:restaurant_pos/database/product.dart';
import 'package:restaurant_pos/database/product_category.dart';
import 'package:restaurant_pos/models/order_type.dart';
import 'package:restaurant_pos/style/color_style.dart';

class PointOfSalePage extends StatefulWidget {
  const PointOfSalePage({Key? key, required this.account}) : super(key: key);
  final dynamic account;

  @override
  State<PointOfSalePage> createState() => _PointOfSalePageState();
}

class _PointOfSalePageState extends State<PointOfSalePage> {
  late OrderType orderType;
  late String? selectedCategory;
  late TextEditingController _controllerSearch;
  late List<Map<String, dynamic>> categoriesData;
  late List<Map<String, dynamic>> productsData;
  bool posModeChangeExpanded = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _controllerSearch = TextEditingController();
      orderType = OrderType.dineIn;
      selectedCategory = null;
      categoriesData = [];
      productsData = [];
    });
    loadCategories();
    loadProducts();
  }

  void loadCategories() async {
    var categoriesData = await ProductCategory.getAll();
    setState(() {
      this.categoriesData = categoriesData;
    });
  }

  void loadProducts() async {
    var productsData = await Product.getAll(category: selectedCategory);
    setState(() {
      this.productsData = productsData;
    });
  }

  Widget buildPOSModeSheet() => ListView(
        shrinkWrap: true,
        children: [
          const Center(
            child: BottomViewGrip(),
          ),
          for (var orderType in OrderType.values)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
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

  Widget buildProductDetailedView({required Map<String, dynamic> product}) => ListView(
        shrinkWrap: true,
        children: [
          const Center(
            child: BottomViewGrip(),
          ),
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
              setState(() {
                Cart.cart.add({'id': product['id'], 'customizationNote': 'NA'});
              });
            },
            onRemove: () async {
              setState(() {
                if (Cart.cart.where((element) => element['id'] == product['id']).isNotEmpty) {
                  Cart.cart.remove(Cart.cart.where((element) => element['id'] == product['id']).last);
                }
              });
            },
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final appBar = PreferredSize(
      child: AppBar(
        title: const Text('POS'),
        backgroundColor: orderType.color,
        flexibleSpace: Container(
          margin: const EdgeInsets.only(top: 80, left: 16, right: 16),
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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              PosCategoryWidget(
                  active: selectedCategory == null,
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
                        selectedCategory = null;
                      },
                    );
                  }),
              Row(
                children: [
                  for (var category in categoriesData)
                    PosCategoryWidget(
                        active: selectedCategory == category['id'],
                        image: File(category['image']).existsSync() ? Image.file(File(category['image'])) : null,
                        label: category['name'],
                        onTap: () {
                          setState(
                            () {
                              selectedCategory = category['id'];
                            },
                          );
                          loadProducts();
                        })
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
                      mrp: product['mrp'],
                      salePrice: product['salePrice'],
                      quantity: product['quantity'],
                      warningQuantity: product['warningQuantity'],
                      image: product['image'],
                      foodType: product['foodType'],
                      themeColor: orderType.color,
                      cartQuantity: Cart.cart.where((element) => element['id'] == product['id']).length,
                      onAdd: () {
                        setState(() {
                          Cart.cart.add({'id': product['id'], 'customizationNote': 'NA'});
                        });
                      },
                      onRemove: () async {
                        setState(() {
                          if (Cart.cart.where((element) => element['id'] == product['id']).isNotEmpty) {
                            Cart.cart.remove(Cart.cart.where((element) => element['id'] == product['id']).last);
                          }
                        });
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
                          builder: (context) => buildProductDetailedView(product: product)),
                    )
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
                    builder: (context) => buildPOSModeSheet()),
                iconData: Icons.dinner_dining,
                themeColor: orderType.color!,
                text: orderType.text!,
              ),
            ),
            Flexible(
              flex: 1,
              child: PrimaryButton(
                color: orderType.foreColor!,
                text: 'Continue',
                height: 50.0,
                backgroundColor: orderType.color!,
              ),
            ),
          ],
        ),
      ),
    );

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
                      //${Cart.calculateCartSubtotal()}
                      Text(
                        '${Cart.cart.length} Item | ${widget.account['currencySymbol']}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: ColorStyle.background200),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'View Item',
                        style: TextStyle(fontWeight: FontWeight.bold, color: ColorStyle.background200),
                      ),
                      Icon(
                        Icons.arrow_drop_up_outlined,
                        color: ColorStyle.background200,
                      )
                    ],
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
          Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: bottomAppBar),
          Positioned(left: 0.0, right: 0.0, bottom: 72, child: cartStrip),
          // Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: posModeChangePanel),
        ],
      ),
    );
  }
}

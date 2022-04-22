import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/food_type_badge.dart';
import 'package:restaurant_pos/components/pos_category_widget.dart';
import 'package:restaurant_pos/components/pos_order_type_selection_button.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/product_card.dart';
import 'package:restaurant_pos/database/linker.dart';
import 'package:restaurant_pos/models/order_type.dart';
import 'package:restaurant_pos/style/color_style.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late OrderType orderType;
  late int? selectedCategory;
  final TextEditingController _controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      orderType = OrderType.dineIn;
      selectedCategory = null;
    });
  }

  Color getThemeColor() {
    if (orderType == OrderType.dineIn) {
      return ColorStyle.tertiary;
    } else if (orderType == OrderType.takeAway) {
      return ColorStyle.secondary;
    } else if (orderType == OrderType.delivery) {
      return ColorStyle.alternate;
    } else {
      return ColorStyle.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: SizedBox(
        width: double.maxFinite,
        child: TextFormField(
          keyboardType: TextInputType.text,
          controller: _controllerSearch,
          decoration: InputDecoration(
            hintText: 'Search a dish...',
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
                color: getThemeColor().withOpacity(0.5),
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
              for (var category in Linker.getCategories())
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
                    })
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
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            for(var product in Linker.getProducts(query: _controllerSearch.text, category: selectedCategory))
              ProductCard(
                id: product['id'],
                name: product['name'],
                description: product['description'],
                mrp: product['mrp'],
                salePrice: product['salePrice'],
                quantity: product['quantity'],
                warningQuantity: product['warningQuantity'],
                image: product['image'],
                foodType:  product['foodType'],
                themeColor: getThemeColor(),
              ),

          ],
        ),
      ),
    );

    final detailedProduct = Container();


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
          Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: detailedProduct),

        ],
      ),
    );
  }
}

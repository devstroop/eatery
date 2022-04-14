import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/food_type_badge.dart';
import 'package:restaurant_pos/components/pos_category_widget.dart';
import 'package:restaurant_pos/components/pos_order_type_selection_button.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/product_card.dart';
import 'package:restaurant_pos/database/linker.dart';
import 'package:restaurant_pos/models/food_type.dart';
import 'package:restaurant_pos/models/order_type.dart';
import 'package:restaurant_pos/style/color_style.dart';

class PointOfSalePage extends StatefulWidget {
  const PointOfSalePage({Key? key}) : super(key: key);

  @override
  State<PointOfSalePage> createState() => _PointOfSalePageState();
}

class _PointOfSalePageState extends State<PointOfSalePage> {
  late OrderType orderType;
  late int? selectedCategory;

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
          controller: null,
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
            for(var product in Linker.getProducts())
              ProductCard(
                id: product['id'] as int,
                name: product['name'] as String,
                description: product['description'] as String,
                mrp: product['mrp'] as double,
                salePrice: product['salePrice'] as double,
                quantity: product['quantity'] as double,
                warningQuantity: product['warningQuantity'] != null ? double.parse((product['warningQuantity']).toString()) : null,
                image: product['image'] as String,
                themeColor: getThemeColor(),
                foodType: FoodType.values.firstWhere((e) => e.toString() == product['foodType']),
                onAdd: () {
                  setState(() {
                    Linker.cart.add({'id': 1, 'customization': ''});
                  });
              },
              onRemove: (){
                setState(() {
                  Linker.cart.remove(Linker.cart
                      .where((product) => product['id'] == 1)
                      .last);
                });
              },
            ),

          ],
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
                iconData: Icons.dinner_dining,
                themeColor: getThemeColor(),
                text: (orderType == OrderType.dineIn)
                    ? 'Dine In'
                    : (orderType == OrderType.takeAway)
                        ? 'Take Away'
                        : (orderType == OrderType.delivery)
                            ? 'Delivery'
                            : 'Dine In',
              ),
            ),
            Flexible(
              flex: 1,
              child: PrimaryButton(
                color: ColorStyle.background200,
                text: 'Continue',
                height: 50.0,
                backgroundColor: getThemeColor(),
              ),
            ),
          ],
        ),
      ),
    );

    final detailedProduct = Container();

    final cartStrip = Linker.cart.isNotEmpty ? Container(
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
                Text('${Linker.cart.length} Item', style: TextStyle(fontWeight: FontWeight.bold, color: ColorStyle.background200),)
              ],
            ),
            Row(
              children: [
                Text('View Item', style: TextStyle(fontWeight: FontWeight.bold, color: ColorStyle.background200),),
                Icon(Icons.arrow_drop_up_outlined, color: ColorStyle.background200,)
              ],
            ),

          ],
        ),
      ),
    ) : Container();

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
          Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: detailedProduct),

        ],
      ),
    );
  }
}

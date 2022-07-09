import 'dart:io';

import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/food_type_badge.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/components/pos_order_type_selection_button.dart';
import 'package:eatery/components/primary_button.dart';
import 'package:eatery/components/product_card.dart';

import 'package:eatery/database/product.dart';
import 'package:eatery/database/product_category.dart';
import 'package:eatery/extensions/calculations.dart';
import 'package:eatery/models/order_type.dart';
import 'package:eatery/pages/add_kitchen_dish_page.dart';
import 'package:eatery/pages/edit_kitchen_dish_page.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/style/color_style.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({Key? key, required this.account}) : super(key: key);
  final dynamic account;
  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  late String? selectedCategory;
  final TextEditingController _controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedCategory = null;
    });
  }

  Color getThemeColor() {
    return const Color(0xFF2FC289)/*ColorStyle.tertiary*/;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = PreferredSize(
      child: AppBar(
        title: const Text('Kitchen'),
        backgroundColor: getThemeColor(),
        flexibleSpace: Container(
          margin: const EdgeInsets.only(top: 90, left: 12, right: 12),
          width: double.maxFinite,
          child: TextFormField(
            onChanged: (value){
              setState((){});
            },
            keyboardType: TextInputType.text,
            controller: _controllerSearch,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
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
                    setState(() {
                        selectedCategory = null;
                    });
                  }),
              FutureBuilder(
                  future: ProductCategory.getAll(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            for (var category in snapshot.data)
                              PosCategoryWidget(
                                  active: selectedCategory == category['id'],
                                  image: category['image'] != null && File(category['image']).existsSync() ? Image.file(File(category['image'])) : null,
                                  label: category['name'],
                                  onTap: () {
                                    setState(
                                      () {
                                        selectedCategory = category['id'];
                                      },
                                    );
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
    );

    final productsPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
            future: Product.getAll(productAs: 'dish', category: selectedCategory, query: _controllerSearch.text),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      for (var product in snapshot.data)
                        ProductCard(
                          currencySymbol: widget.account['currencySymbol'],
                          id: product['id'],
                          name: product['name'],
                          description: product['description'],
                          price: product['price'],
                          quantity: product['quantity'] != null && product['quantity'] != ''
                              ? double.parse(product['quantity'])
                              : null,
                          warningQuantity: product['warningQuantity'] != null && product['warningQuantity'] != ''
                              ? double.parse(product['warningQuantity'])
                              : null,
                          image: product['image'],
                          foodType: product['foodType'],
                          themeColor: getThemeColor(),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditKitchenDish(account: widget.account, id: product['id'])),
                            ).then((_) => setState(() {}));
                          },
                        )
                    ],
                  );
                }
                return SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(top: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height ? MediaQuery.of(context).size.width: 0.0) * 0.5,),
                    child: Center(
                        child: Image.asset('assets/images/2748558.png', width: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height ? MediaQuery.of(context).size.width: MediaQuery.of(context).size.height) * 0.5,)
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
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
          Positioned(top: 60.0, left: 0.0, right: 0.0, bottom: 0, child: productsPanel),
          Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: detailedProduct),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getThemeColor(),
        child: const Icon(Icons.add),
        onPressed: () async {
          /*if((await ProductCategory.getAll()).isEmpty){
            showSnackBar(context, '* Create product category first');
            return;
          }*/
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddKitchenDish(account: widget.account,)),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}

import 'dart:io';
import 'package:eatery/constants/global_variables.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/components/product_card.dart';
import 'package:eatery/constants/style/color_style.dart';
import '../../../../widgets/bottomSheets/productInternalView.bottomsheet.dart';
import 'add_kitchenDish.page.dart';
import 'edit_kitchenDish.page.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({Key? key}) : super(key: key);

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  ProductCategory? selectedCategory;
  final TextEditingController _controllerSearch = TextEditingController();
  @override
  void initState() {
    super.initState();
    selectedCategory = null;
    setState(() {});
  }

  Color getThemeColor() {
    return ColorStyle.secondary;
  }

  _edit(Product product) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditKitchenDish(product: product)),
      ).then((_) {
        setState(() {});
        Navigator.of(context).pop();
      });

  _delete(Product product) async {
    await product.delete().whenComplete(() {
      Navigator.of(context).pop();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Kitchen'),
      backgroundColor: getThemeColor(),
      bottom: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 72),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            onChanged: (value) {
              setState(() {});
            },
            keyboardType: TextInputType.text,
            controller: _controllerSearch,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: getThemeColor(),
              ),
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
              contentPadding:
                  const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
            ),
            style: TextStyle(
              color: ColorStyle.text200,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
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
                    setState(() {
                      selectedCategory = null;
                    });
                  }),
              Row(
                children: [
                  for (var category
                      in EateryDB.instance.productCategoryBox.values)
                    PosCategoryWidget(
                        active: selectedCategory == category,
                        image: category.image != null &&
                                File(category.image!).existsSync()
                            ? Image.file(File(category.image!))
                            : null,
                        label: category.name,
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                            _controllerSearch.text = '';
                          });
                        }),
                ],
              )
            ],
          ),
        ),
      ),
    );

    final productsPanel = SizedBox(
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (var product in EateryDB.instance.productBox.values.where(
                  (element) => element.type == ProductType.kitchenDish &&
                          selectedCategory != null
                      ? element.categoryId == selectedCategory?.id
                      : true &&
                          element.name
                              .toLowerCase()
                              .contains(_controllerSearch.text.toLowerCase())))
                ProductCard(
                  currencySymbol: GlobalVariables.currency?.symbol,
                  product: product,
                  themeColor: getThemeColor(),
                  onTap: () => showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                      builder: (context) {
                        return ProductInternalViewBottomsheet(
                          color: getThemeColor(),
                          product: product,
                          onEdit: () => _edit(product),
                          onDelete: () => _delete(product),
                        );
                      }).then((value) => setState(() {})),
                )
            ],
          )),
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
          Positioned(
              top: 60.0,
              left: 0.0,
              right: 0.0,
              bottom: 0,
              child: productsPanel),
          Positioned(
              bottom: 0.0, left: 0.0, right: 0.0, child: detailedProduct),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getThemeColor(),
        child: const Icon(Icons.add),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddKitchenDish(
                      company: GlobalVariables.company!,
                    )),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}

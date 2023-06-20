import 'dart:io';
import 'package:eatery/pages/dashboard/product/inventoryItem/add_inventoryItem.page.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_services/eatery_services.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/components/product_card.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery_components/bottomsheets/product_internal_view.bottomsheet.dart';

import 'edit_inventoryItem.page.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key, required this.company}) : super(key: key);
  final Company company;

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  ProductCategory? _category;
  final TextEditingController _ctrlSearch = TextEditingController();
  String? _currencySymbol;

  @override
  void initState() {
    super.initState();
    try {
      _currencySymbol = EateryDB.instance.currencyBox.values
          .singleWhere((element) => element.id == widget.company.currencyId)
          .symbol;
    } catch (_) {}
    _category = null;
    setState(() {});
  }

  Color getThemeColor() {
    return ColorStyle.secondary;
  }

  _edit(Product product) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditInventoryItem(company: widget.company, product: product)),
      ).then((_) {
        setState(() {});
        Navigator.of(context).pop();
      });

  _delete(Product product) async {
    product.delete().then((value) {
      Navigator.of(context).pop();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Inventory'),
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
            controller: _ctrlSearch,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: getThemeColor(),
              ),
              hintText: 'Search an item...',
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
                  active: _category == null,
                  image: Image.asset(
                    'assets/images/all.png',
                    width: 18,
                    height: 18,
                    fit: BoxFit.cover,
                  ),
                  label: 'All',
                  onTap: () {
                    setState(() {
                      _category = null;
                    });
                  }),
              Row(
                children: [
                  for (var _category
                      in EateryDB.instance.productCategoryBox.values)
                    FutureBuilder<String>(
                        future: FileServices.absImage(_category.image ?? ''),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          } else {
                            return PosCategoryWidget(
                                active: this._category == _category,
                                image: snapshot.data != null &&
                                        File(snapshot.data!).existsSync()
                                    ? Image.file(File(snapshot.data!))
                                    : null,
                                label: _category.name,
                                onTap: () {
                                  setState(() {
                                    this._category = _category;
                                    _ctrlSearch.text = '';
                                  });
                                });
                          }
                        })
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
                  (element) => element.type == ProductType.inventoryItem &&
                          _category != null
                      ? element.categoryId == _category?.id
                      : true &&
                          element.name
                              .toLowerCase()
                              .contains(_ctrlSearch.text.toLowerCase())))
                ProductCard(
                  currencySymbol: _currencySymbol,
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
                builder: (context) => AddInventoryItem(
                      company: widget.company,
                    )),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}

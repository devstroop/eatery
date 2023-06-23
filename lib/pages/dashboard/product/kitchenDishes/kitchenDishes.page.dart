import 'dart:io';
import 'package:eatery/constants/global_variables.dart';
import 'package:eatery/services/utility/library_image.dart';
import 'package:eatery/widgets/posWidgets/circularCategory.posWidget.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/components/product_card.dart';
import 'package:eatery/constants/style/color_style.dart';
import '../../../../widgets/bottomSheets/productInternalView.bottomsheet.dart';
import '../../../../widgets/textFields/search.textField.dart';
import 'addKitchenDish.page.dart';
import 'editKitchenDish.page.dart';

Color _pageColor = ColorStyle.secondary;

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
    Future.delayed(Duration.zero, () {});
    selectedCategory = null;
    setState(() {});
  }

  _edit(Product product) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditKitchenDish(product: product)),
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
    /*final categoryBar = SizedBox(
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
    );*/
    /*final productsPanel = SizedBox(
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
                  themeColor: _pageColor,
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
                          color: _pageColor,
                          product: product,
                          onEdit: () => _edit(product),
                          onDelete: () => _delete(product),
                        );
                      }).then((value) => setState(() {})),
                )
            ],
          )),
    );

    final detailedProduct = Container();*/

    List<Product> products = EateryDB.instance.productBox.values.where((element) => element.type == ProductType.kitchenDish).toList();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          title: const Text('Kitchen'),
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
                setState(() {});
              },
              themeColor: _pageColor,
              hintText: 'Search a dish...',
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          Flexible(
            flex: 2,
            child: ListView(
              padding: const EdgeInsets.all(6.0),
              children: [
                CircularCategoryPOSWidget(
                  margin: const EdgeInsets.only(bottom: 6),
                  image: const AssetImage('assets/icons/all.png'),
                  themeColor: _pageColor,
                  selected: selectedCategory?.id == null,
                  onTap: () {
                    setState(() {
                      selectedCategory = null;
                    });
                  },
                  label: 'All',
                ),
                ...EateryDB.instance.productCategoryBox.values.map((each) {
                  return CircularCategoryPOSWidget(
                    margin: const EdgeInsets.only(bottom: 6),
                    image: LibraryImage(each.image).image,
                    themeColor: _pageColor,
                    selected: selectedCategory?.id == each.id,
                    onTap: () {
                      setState(() {
                        selectedCategory = each;
                      });
                    },
                    label: each.name,
                  );
                })
              ],
            ),
          ),
          Container(
            width: 1,
            height: MediaQuery.of(context).size.height - 215,
            color: Colors.grey[200],
          ),
          Flexible(
            flex: 8,
            child: products.isNotEmpty ? SingleChildScrollView(
              child: Wrap(
                children: [
                  ...products.map((each) {
                    return Card(child: Text(each.name),);
                  })
                ],
              ),
            ) : Center(
              child: Opacity(
                opacity: 0.50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/empty-folder.png', width: 100, height: 100,),
                    const SizedBox(height: 16,),
                    const Text('No dish found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    const Text('Add a dish to get started', style: TextStyle(fontSize: 16, color: Colors.black54),),
                    const SizedBox(height: 48,),
                  ],
                ),
              ),
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        icon: Icon(UIcons.regularStraight.plus_small),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddKitchenDish(
                      company: GlobalVariables.company!,
                    )),
          ).then((_) => setState(() {}));
        }, label: const Text('Add Dish'),
      ),
    );
  }
}

import 'package:eatery/pages/dashboard/product/inventoryItem/addInventoryItem.page.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/product_card.dart';
import 'package:eatery/constants/style/color_style.dart';
import '../../../../services/utility/library_image.dart';
import '../../../../widgets/posWidgets/circularCategory.posWidget.dart';
import '../../../../widgets/textFields/search.textField.dart';
import 'editInventoryItem.page.dart';

Color _pageColor = ColorStyle.alternate;

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  ProductCategory? selectedCategory;
  final TextEditingController _controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        selectedCategory = null;
      });
    });
  }

  final ScrollController _scrollControllerCategories = ScrollController();
  final ScrollController _scrollControllerProducts = ScrollController();
  @override
  Widget build(BuildContext context) {

    List<Product> products = EateryDB.instance.productBox.values
        .where((element) => element.type == ProductType.inventoryItem).toList();
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
          title: const Text('Inventory'),
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
              hintText: 'Search an item...',
            ),
          ),
        ),
      ),
      body:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              child: products.isNotEmpty
                  ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollControllerProducts,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ...products.map((each) {
                      final width = ((MediaQuery.of(context).size.width * 0.8 - 1).abs() - (crossAxisCount + 1) * spacing) / crossAxisCount;
                      final height = width * 4/3;
                      return ProductCard(product: each, width: width,height: height,themeColor: _pageColor, onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditInventoryItemPage(product: each)),
                        ).then((_) => setState(() {}));
                      },);
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        icon: Icon(UIcons.regularStraight.plus_small),
        label: const Text('Add Inventory Item'),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddInventoryItem()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}

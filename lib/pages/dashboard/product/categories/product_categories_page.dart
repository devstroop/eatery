import 'dart:io';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_services/eatery_services.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'add_product_category_page.dart';
import 'edit_product_category_page.dart';

class ProductCategoriesPage extends StatefulWidget {
  const ProductCategoriesPage({Key? key}) : super(key: key);

  @override
  State<ProductCategoriesPage> createState() => _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage> {
  final themeColor = ColorStyle.tertiary;
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: themeColor,
      title: const Text('Product Categories'),
    );
    final categoriesPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              height: 50.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PosCategoryWidget(
                    label: "Uncategorized",
                    image: null,
                    onTap: (){ },
                  ),
                ],
              ),
            ),
            for (var category in EateryDB().productCategoryBox().values)
              SizedBox(
                height: 50.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<String>(
                      future: FileServices.absImage(category.image ?? ''),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        } else {
                          return PosCategoryWidget(
                            label: category.name,
                            image: category.image != null &&
                                File(snapshot.data!).existsSync()
                                ? Image.file(File(snapshot.data!))
                                : null,
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProductCategoryPage(category: category,)),
                              ).then((_) => setState(() {}));
                            },
                          );
                        }
                      },
                    ),

                  ],
                ),
              )
          ],
        )
      ),
    );
    return Scaffold(
      backgroundColor: ColorStyle.backgroundColor,
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
              top: 12.0,
              left: 0.0,
              right: 0.0,
              bottom: 72,
              child: categoriesPanel
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: themeColor,
        icon: const Icon(Icons.add),
        label: const Text('New'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductCategoryPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}

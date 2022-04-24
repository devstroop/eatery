import 'package:flutter/material.dart';
import 'package:restaurant_pos/database/product_category.dart';
import 'package:restaurant_pos/style/color_style.dart';

class ProductCategoriesPage extends StatefulWidget {
  const ProductCategoriesPage({Key? key}) : super(key: key);

  @override
  State<ProductCategoriesPage> createState() => _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage> {

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Product Categories'),
    );
    final categoriesPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            FutureBuilder(
              future: ProductCategory.getAll(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                  return Container();
                }
            )
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
              top: 60.0,
              left: 0.0,
              right: 0.0,
              bottom: 72,
              child: categoriesPanel
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getThemeColor(),
        child: const Icon(Icons.add),
        onPressed: () {  },
      ),
    );
  }
}

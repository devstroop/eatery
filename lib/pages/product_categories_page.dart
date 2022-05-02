import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/product_category_card.dart';
import 'package:restaurant_pos/database/product_category.dart';
import 'package:restaurant_pos/pages/add_product_category_page.dart';
import 'package:restaurant_pos/pages/edit_product_category_page.dart';
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
        child: FutureBuilder(
            future: ProductCategory.getAll(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
              if (snapshot.connectionState == ConnectionState.done) {
                if(snapshot.hasData && snapshot.data.isNotEmpty){
                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      for (var category in snapshot.data)
                        ProductCategoryCard(
                          id: category['id'],
                          name: category['name'],
                          image: category['image'],
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProductCategoryPage(id: category['id'],)),
                            ).then((_) => setState(() {}));
                          },
                        )
                    ],
                  );
                }
                return SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(top: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height ? MediaQuery.of(context).size.width: 0.0) * 0.5,)
                  ,
                    child: Center(
                        child: Image.asset('assets/images/2748558.png', width: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height ? MediaQuery.of(context).size.width: MediaQuery.of(context).size.height) * 0.5,)
                    ),
                  ),
                );
              }
              else{
                return const Center(child: CircularProgressIndicator(),);
              }
            }
        )
      ),
    );
    return Scaffold(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: getThemeColor(),
        child: const Icon(Icons.add),
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

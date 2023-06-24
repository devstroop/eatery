import 'package:eatery/services/utility/library_image.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'addProductCategory.page.dart';
import 'editProductCategory.page.dart';

class ProductCategoriesPage extends StatefulWidget {
  const ProductCategoriesPage({Key? key}) : super(key: key);

  @override
  State<ProductCategoriesPage> createState() => _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage> {
  final themeColor = ColorStyle.tertiary;
  @override
  Widget build(BuildContext context) {
    List<ProductCategory> categories = EateryDB.instance.productCategoryBox.values.toList();
    return Scaffold(
      backgroundColor: ColorStyle.backgroundColor,
      appBar: AppBar(
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          title: const Text('Product Categories'),
          leading: IconButton(
            icon: Icon(UIcons.regularStraight.arrow_left),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: categories.isNotEmpty ? ListView(
        children: [
          ListTile(
            title: const Text('Default',
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Uncategorized'),
            leading: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/default.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
          ...categories.map((e) {
            return ListTile(
              title: Text(e.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: e.description != null && e.description?.trim() != ''
                  ? Text(e.description ?? '')
                  : null,
              trailing: Icon(UIcons.regularStraight.arrow_small_right),
              leading: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: LibraryImage(e.image ?? '').image,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProductCategoryPage(
                            category: e,
                          )),
                ).then((_) => setState(() {}));
              },
            );
          }),
        ],
      ) : Center(
        child: Opacity(
          opacity: 0.50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/empty-folder.png', width: 100, height: 100,),
              const SizedBox(height: 16,),
              const Text('No categories found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              const Text('Add a product category to get started', style: TextStyle(fontSize: 16, color: Colors.black54),),
              const SizedBox(height: 48,),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: themeColor,
        icon: Icon(UIcons.regularStraight.plus_small),
        label: const Text('Add Product Category'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddProductCategoryPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
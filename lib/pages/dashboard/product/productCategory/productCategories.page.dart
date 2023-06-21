import 'dart:io';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'add_productCategory.page.dart';
import 'edit_productCategory.page.dart';

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
        foregroundColor: Colors.white,
        title: const Text('Product Categories'),
        leading: IconButton(
          icon: Icon(UIcons.regularStraight.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ));
    return Scaffold(
      backgroundColor: ColorStyle.backgroundColor,
      appBar: appBar,
      body: ListView(
        children: [
          ListTile(
            title: const Text('Default',
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Uncategorized'),
            trailing: Icon(
              UIcons.regularStraight.arrow_small_right,
              size: 18,
            ),
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
          ...EateryDB.instance.productCategoryBox.values.map((e) {
            return ListTile(
              title: Text(e.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(e.description ?? ''),
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
                        image: (e.image != null && File(e.image!).existsSync()
                                ? Image.file(File(e.image!))
                                : Image.asset(
                                    'assets/images/no-image.jpg',
                                    fit: BoxFit.cover,
                                  ))
                            .image,
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: themeColor,
        icon: Icon(UIcons.regularStraight.add_folder),
        label: const Text('New Category'),
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

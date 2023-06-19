import 'dart:io';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_services/eatery_services.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:uicons/uicons.dart';

import '../categories/edit_product_category_page.dart';
import '../productCategory/add_productCategory.page.dart';

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
            title: const Text('None',
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('No category'),
            trailing: Icon(
              UIcons.regularStraight.ban,
              size: 18,
            ),
            leading: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {},
          ),
          ...EateryDB().productCategoryBox().values.map((e) {
            return ListTile(
              title: Text(e.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(e.description ?? ''),
              trailing: Icon(UIcons.regularStraight.arrow_small_right),
              leading: FutureBuilder<String>(
                future: FileServices.absImage(e.image ?? ''),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  } else {
                    return Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            image: (e.image != null &&
                                        File(snapshot.data!).existsSync()
                                    ? Image.file(File(snapshot.data!))
                                    : Image.asset(
                                        'assets/images/no-image.jpg',
                                        fit: BoxFit.cover,
                                      ))
                                .image,
                            fit: BoxFit.cover,
                          ),
                        ));
                  }
                },
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
        label: const Text('New'),
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

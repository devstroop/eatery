import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/dining_table_card.dart';
import 'package:restaurant_pos/components/pos_category_widget.dart';
import 'package:restaurant_pos/components/product_card.dart';
import 'package:restaurant_pos/database/dining_table.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';
import 'package:restaurant_pos/pages/add_dining_table_page.dart';
import 'package:restaurant_pos/pages/dining_table_categories_page.dart';
import 'package:restaurant_pos/style/color_style.dart';

class DiningTablesPage extends StatefulWidget {
  const DiningTablesPage({Key? key}) : super(key: key);

  @override
  State<DiningTablesPage> createState() => _DiningTablesPageState();
}

class _DiningTablesPageState extends State<DiningTablesPage> {
  late dynamic selectedCategory;
  final TextEditingController _controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedCategory = null;
    });
  }

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(backgroundColor: getThemeColor(), title: const Text('Dining Tables'), actions: [
      TextButton(
        child: Text(
          'Manage Categories',
          style: TextStyle(color: ColorStyle.background200),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiningTableCategoriesPage()),
          );
        },
      ),
    ]);

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
                    setState(
                      () {
                        selectedCategory = null;
                      },
                    );
                  }),
              FutureBuilder(
                  future: DiningTableCategory.getAll(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            for (var category in snapshot.data)
                              PosCategoryWidget(
                                  active: selectedCategory == category['id'],
                                  image:
                                      File(category['image']).existsSync() ? Image.file(File(category['image'])) : null,
                                  label: category['name'],
                                  onTap: () {
                                    setState(
                                      () {
                                        selectedCategory = category['id'];
                                      },
                                    );
                                  })
                          ],
                        );
                      }
                      return Container();
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );

    final productsPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:
        FutureBuilder(
            future: DiningTable.getAll(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      for (var product in snapshot.data)
                        DiningTableCard(
                          id: product['id'],
                          name: product['name'],
                          image: product['image'],
                        )

                    ],
                  );
                }
                return Container();
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
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
          Positioned(top: 60.0, left: 0.0, right: 0.0, bottom: 72, child: productsPanel),
          Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: detailedProduct),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getThemeColor(),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDiningTablePage()),
          );
        },
      ),
    );
  }
}

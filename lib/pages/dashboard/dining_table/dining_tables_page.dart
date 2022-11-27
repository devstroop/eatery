import 'dart:io';

import 'package:eatery/components/loaders/loading_screen.dart';
import 'package:eatery_db/models/company/company.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/dining_table_card.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/components/product_card.dart';
import 'package:eatery/database/dining_table.dart';
import 'package:eatery/database/dining_table_category.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'add_dining_table_page.dart';
import 'dining_table_categories_page.dart';
import 'edit_dining_table_page.dart';

class DiningTablesPage extends StatefulWidget {
  const DiningTablesPage({Key? key, required this.company}) : super(key: key);
  final Company company;
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
          style: TextStyle(color: ColorStyle.backgroundColorAlter),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiningTableCategoriesPage()),
          ).then((_) => setState(() {}));
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
                      return LoadingScreen();
                    }
                  }),
            ],
          ),
        ),
      ),
    );

    final diningTablesPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:
        FutureBuilder(
            future: DiningTable.getAll(category: selectedCategory),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      for (var product in snapshot.data)
                        DiningTableCard(
                          id: product['id'],
                          name: product['name'],
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditDiningTablePage(id: product['id'])),
                            ).then((_) => setState(() {}));
                          },
                        )

                    ],
                  );
                }
                return SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(top: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height ? MediaQuery.of(context).size.width: 0.0) * 0.5,),
                    child: Center(
                        child: Image.asset('assets/images/2748558.png', width: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height ? MediaQuery.of(context).size.width: MediaQuery.of(context).size.height) * 0.5,)
                    ),
                  ),
                );
              } else {
                return LoadingScreen();
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
          Positioned(top: 60.0, left: 0.0, right: 0.0, bottom: 72, child: diningTablesPanel),
          Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: detailedProduct),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getThemeColor(),
        child: const Icon(Icons.add),
        onPressed: () async {
          if((await DiningTableCategory.getAll()).isEmpty){
            showSnackBar(context, '* Create category first');
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDiningTablePage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}

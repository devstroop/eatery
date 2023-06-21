import 'package:eatery/services/utility/file.utility.service.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/dining_table_card.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'add_diningTable.page.dart';
import 'category/diningTable_categories.page.dart';
import 'edit_diningTable.page.dart';

Color _pageColor = ColorStyle.tertiary;

class DiningTablesPage extends StatefulWidget {
  const DiningTablesPage({Key? key}) : super(key: key);
  @override
  State<DiningTablesPage> createState() => _DiningTablesPageState();
}

class _DiningTablesPageState extends State<DiningTablesPage> {
  late dynamic selectedCategory;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Dining Tables'),
        leading: IconButton(
          icon: Icon(UIcons.regularStraight.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              UIcons.regularStraight.list,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DiningTableCategoriesPage()),
              ).then((_) => setState(() {}));
            },
          ),
        ]);

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              width: double.maxFinite,
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                children: [
                  PosCategoryWidget(
                      active: selectedCategory == null,
                      image: Image.asset(
                        'assets/images/all.png',
                        width: 18,
                        height: 18,
                        fit: BoxFit.cover,
                      ),
                      label: 'All Categories',
                      onTap: () {
                        setState(() {
                            selectedCategory = null;
                          },
                        );
                      }),
                  ...EateryDB.instance.diningTableCategoryBox.values.map((e) {
                    return PosCategoryWidget(
                      active: selectedCategory == e.id,
                      label: e.name,
                      image: Image.asset(
                        e.image != null
                            ? FileUtilityService.getAbsolutePath(e.image!)
                            : 'assets/images/default.jpg',
                        width: 18,
                        height: 18,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        setState(() {
                          selectedCategory = e.id;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60.0,
            left: 0.0,
            right: 0.0,
            bottom: 72,
            child: Wrap(
              children: [
                ...EateryDB.instance.diningTableBox.values
                    .where((element) =>
                        selectedCategory == null ||
                        element.categoryId == selectedCategory)
                    .map((e) {
                  return DiningTableCard(
                    diningTable: e,
                    order: EateryDB.instance.orderBox.get(e.orderId),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditDiningTablePage(id: e.id)),
                      ).then((_) => setState(() {}));
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: _pageColor,
        child: Icon(
          UIcons.regularStraight.plus,
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDiningTablePage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}

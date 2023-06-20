import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/dining_table_category_card.dart';
import 'package:eatery/constants/style/color_style.dart';

import 'add_diningTable_category.page.dart';
import 'edit_diningTable_category.page.dart';

Color _pageColor = ColorStyle.tertiary;

class DiningTableCategoriesPage extends StatefulWidget {
  const DiningTableCategoriesPage({Key? key}) : super(key: key);

  @override
  State<DiningTableCategoriesPage> createState() =>
      _DiningTableCategoriesPageState();
}

class _DiningTableCategoriesPageState extends State<DiningTableCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(UIcons.regularStraight.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Dining Table Categories'),
      ),
      body: ListView(
        children: [
          ...EateryDB.instance.diningTableCategoryBox.values.map((e) {
            return DiningTableCategoryCard(
              id: e.id,
              name: e.name,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditDiningTableCategoryPage(id: e.id)),
                ).then((_) => setState(() {}));
              },
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        child: Icon(
          UIcons.regularStraight.plus,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddDiningTableCategoryPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}

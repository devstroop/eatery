import 'dart:io';

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
          ...EateryDB.instance.diningTableCategoryBox.values.map((e) {
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
                          'assets/images/default.jpg',
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
                      builder: (context) => EditDiningTableCategoryPage(
                            id: e.id,
                          )),
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

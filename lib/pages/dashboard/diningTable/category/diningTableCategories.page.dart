import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';
import '../../../../services/utility/library_image.dart';
import 'addDiningTableCategory.page.dart';
import 'editDiningTableCategory.page.dart';

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
          ...EateryDB.instance.diningTableCategoryBox.values.map((each) {
            return ListTile(
              title: Text(each.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      UIcons.regularStraight.pencil,
                      color: _pageColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditDiningTableCategoryPage(category: each,)),
                      ).then((_) => setState(() {}));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      UIcons.regularStraight.trash,
                      color: _pageColor,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          // category exists in dining table then show message and return
                          if (EateryDB.instance.diningTableBox.values
                              .any((element) => element.categoryId == each.id)) {
                            return AlertDialog(
                              title: const Text('Delete Category'),
                              content: const Text(
                                  'This category is currently in use. Please remove it from dining tables before deleting.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          }
                          return AlertDialog(
                            title: const Text('Delete Category'),
                            content: const Text(
                                'Are you sure you want to delete this category?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  each.delete().whenComplete(() {
                                    Navigator.pop(context);
                                    setState(() {});
                                  });
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              subtitle: Text(each.description ?? ''),
              leading: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: LibraryImage(each.image).image,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              onTap: () {},
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Category'),
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        icon: Icon(
          UIcons.regularStraight.plus_small,
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

import 'package:eatery/services/utility/library_image.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
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
/*
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
                        setState(
                          () {
                            selectedCategory = null;
                          },
                        );
                      }),
                  ...EateryDB.instance.diningTableCategoryBox.values.map((e) {
                    return PosCategoryWidget(
                      active: selectedCategory == e.id,
                      label: e.name,
                      image: Image(
                        image: LibraryImage(
                            e.image ?? '').image,
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

*/
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          Flexible(
            flex: 2,
            child: ListView(
              padding: const EdgeInsets.all(6.0),
              children: [
                ...EateryDB.instance.diningTableCategoryBox.values.map((e) {
                  return Column(
                    children: [
                      const SizedBox(height: 6),
                      Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                            image: DecorationImage(
                                image: LibraryImage(e.image ?? '').image,
                                fit: BoxFit.cover,
                                scale: 5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        e.name,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                    ],
                  );
                  // return PosCategoryWidget(
                  //   active: selectedCategory == e.id,
                  //   label: e.name,
                  //   image: Image(
                  //     image: LibraryImage(e.image ?? '').image,
                  //     width: 18,
                  //     height: 18,
                  //     fit: BoxFit.cover,
                  //   ),
                  //   onTap: () {
                  //     setState(() {
                  //       selectedCategory = e.id;
                  //     });
                  //   },
                  // );
                }),
              ],
            ),
          ),
          Container(
            width: 1,
            height: MediaQuery.of(context).size.height - 150,
            color: Colors.grey[200],
          ),
          Flexible(
            flex: 8,
            child: ListView(
              children: [
                ...EateryDB.instance.diningTableBox.values
                    .where((element) =>
                        selectedCategory == null ||
                        element.categoryId == selectedCategory)
                    .map((e) {
                  return ListTile(
                    title: Text(e.name),
                    subtitle:
                        e.description != null && e.description?.trim() != ''
                            ? Text(e.description!)
                            : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditDiningTablePage(id: e.id)),
                      ).then((_) => setState(() {}));
                    },
                  );
                })
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

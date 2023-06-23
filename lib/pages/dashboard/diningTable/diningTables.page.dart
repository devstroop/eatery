import 'package:eatery/constants/global_variables.dart';
import 'package:eatery/services/utility/library_image.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';
import '../../../widgets/imageWidgets/leading.imageWidget.dart';
import '../../../widgets/labels/caption.label.dart';
import '../../../widgets/posWidgets/circularCategory.posWidget.dart';
import 'addDiningTable.page.dart';
import 'category/diningTableCategories.page.dart';
import 'editDiningTable.page.dart';

Color _pageColor = ColorStyle.tertiary;

class DiningTablesPage extends StatefulWidget {
  const DiningTablesPage({Key? key}) : super(key: key);

  @override
  State<DiningTablesPage> createState() => _DiningTablesPageState();
}

class _DiningTablesPageState extends State<DiningTablesPage> {
  DiningTableCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        selectedCategory = null;
      });
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
      body: Row(
        children: [
          Flexible(
            flex: 2,
            child: ListView(
              padding: const EdgeInsets.all(6.0),
              children: [
                CircularCategoryPOSWidget(
                  margin: const EdgeInsets.only(bottom: 6),
                  onTap: () {
                    setState(() {
                      selectedCategory = null;
                    });
                  },
                  themeColor: _pageColor,
                  selected: selectedCategory?.id == null,
                  label: 'All',
                  image: const AssetImage('assets/icons/all.png'),
                ),
                ...EateryDB.instance.diningTableCategoryBox.values.map((e) {
                  return CircularCategoryPOSWidget(
                    margin: const EdgeInsets.only(bottom: 6),
                    onTap: () {
                      setState(() {
                        selectedCategory = e;
                      });
                    },
                    themeColor: _pageColor,
                    selected: selectedCategory?.id == e.id,
                    label: e.name,
                    image: LibraryImage(e.image ?? '').image,
                  );
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
                        element.categoryId == selectedCategory?.id)
                    .map((e) {
                  DiningTableCategory? category = e.categoryId != null
                      ? EateryDB.instance.diningTableCategoryBox.values
                          .singleWhere((element) => element.id == e.categoryId)
                      : null;
                  Order? order = e.orderId != null
                      ? EateryDB.instance.orderBox.values
                          .singleWhere((elem) => elem.id == e.orderId)
                      : null;
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          e.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        if (category != null)
                          CaptionLabel(label: category.name)
                      ],
                    ),
                    leading: LeadingImageWidget(
                        image: LibraryImage(e.image ?? '').image,
                      elevation: 0.0,
                    ),
                    trailing: order != null
                        ? Text(
                            '${GlobalVariables.currency?.symbol ?? ''}${order.finalTotal}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: ColorStyle.error),
                          )
                        : null,
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
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Dining Table'),
        foregroundColor: Colors.white,
        backgroundColor: _pageColor,
            icon: Icon(
          UIcons.regularStraight.plus_small,
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

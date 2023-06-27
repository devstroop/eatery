import 'package:eatery/widgets/card/diningTableSelection.card.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';

import '../../../../constants/style/color_style.dart';
import '../../../../services/utility/library_image.dart';
import '../../../../widgets/posWidgets/circularCategory.posWidget.dart';

class DiningTableSelectionView extends StatefulWidget {
  const DiningTableSelectionView({super.key, this.themeColor});

  final Color? themeColor;

  @override
  State<DiningTableSelectionView> createState() =>
      _DiningTableSelectionViewState();
}

class _DiningTableSelectionViewState extends State<DiningTableSelectionView> {
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
    return Column(children: [
      AppBar(
          title: const Text('Select Dining Table'),
          backgroundColor: Colors.transparent,
          foregroundColor: ColorStyle.text200,
          leading: IconButton(
            icon: Icon(UIcons.regularStraight.arrow_left),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(6.0),
          children: [
            CircularCategoryPOSWidget(
              margin: const EdgeInsets.only(right: 12),
              onTap: () {
                setState(() {
                  selectedCategory = null;
                });
              },
              themeColor: widget.themeColor,
              selected: selectedCategory?.id == null,
              label: 'All',
              image: const AssetImage('assets/icons/all.png'),
            ),
            ...EateryDB.instance.diningTableCategoryBox.values.map((e) {
              return CircularCategoryPOSWidget(
                margin: const EdgeInsets.only(right: 12),
                onTap: () {
                  setState(() {
                    selectedCategory = e;
                  });
                },
                themeColor: widget.themeColor,
                selected: selectedCategory?.id == e.id,
                label: e.name,
                image: LibraryImage(e.image ?? '').image,
              );
            }),
          ],
        ),
      ),
      Flexible(
        child: GridView(
          padding: const EdgeInsets.all(12.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
          ),
          children: [
            ...EateryDB.instance.diningTableBox.values
                .map((e) => DiningTableSelectionCard(
                      diningTable: e,
                      order: e.orderId != null
                          ? EateryDB.instance.orderBox.values
                              .singleWhere((element) => element.id == e.orderId)
                          : null,
                    )
            ),
          ],
        ),
      )
    ]);
  }
}

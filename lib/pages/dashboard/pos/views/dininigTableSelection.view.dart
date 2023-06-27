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
    return Column(
        children: [
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
            Container(
              decoration: BoxDecoration(
                color: ColorStyle.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                    width: 1.0,
                    color: ColorStyle.success),
              ),
              child: Stack(
                children: [

                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorStyle.success.withOpacity(0.24),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  width: 2.0,
                    color: ColorStyle.success,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Icon(UIcons.regularStraight.check, color: ColorStyle.success, size: 18.0,),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorStyle.error.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                    width: 1.0,
                    color: ColorStyle.error),
              ),
              child: Stack(
                children: [

                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorStyle.error.withOpacity(0.24),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  width: 2.0,
                    color: ColorStyle.error,
                ),
              ),
              child: Stack(
                children: [

                ],
              ),
            ),
          ],
        ),
      )
    ]);
  }
}

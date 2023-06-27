import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';

import '../../../../constants/style/color_style.dart';


class WaiterSelectionView extends StatelessWidget {
  const WaiterSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(
          title: const Text('Select Waiter'),
          backgroundColor: Colors.transparent,
          foregroundColor: ColorStyle.text200,
          leading: IconButton(
            icon: Icon(UIcons.regularStraight.arrow_left),
            onPressed: () {
              Navigator.pop(context);
            },
          )
      ),

      Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        height: 0.5,
        color: ColorStyle.text400,
      ),
    ]);
  }
}

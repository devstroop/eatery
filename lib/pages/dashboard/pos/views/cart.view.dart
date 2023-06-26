import 'package:eatery_components/titles/page.title.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import '../../../../constants/style/color_style.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(
          title: const Text('Cart'),
          backgroundColor: Colors.transparent,
          foregroundColor: ColorStyle.text200,
          leading: IconButton(
            icon: Icon(UIcons.regularStraight.arrow_left),
            onPressed: () {
              Navigator.pop(context);
            },
          )
      )
    ]);
  }
}

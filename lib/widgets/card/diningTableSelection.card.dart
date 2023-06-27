import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';

import '../../constants/style/color_style.dart';

class DiningTableSelectionCard extends StatelessWidget {
  const DiningTableSelectionCard(
      {super.key, required this.diningTable, this.order});

  final DiningTable diningTable;
  final Order? order;

  @override
  Widget build(BuildContext context) {
    bool active = diningTable.isActive;
    bool available =
        active && order != null ? order!.id == diningTable.orderId : false;
    Color color = active
        ? (available ? ColorStyle.success : ColorStyle.text300)
        : ColorStyle.text300;
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.24),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          width: 2.0,
          color: color,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 6,
            right: 6,
            child: Icon(
              UIcons.regularStraight.check,
              color: color,
              size: 18.0,
            ),
          )
        ],
      ),
    );
  }
}

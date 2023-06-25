import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';

class PosOrderTypeSelectionButton extends StatelessWidget {
  const PosOrderTypeSelectionButton({Key? key, required this.iconData, required this.text, this.onTap, required this.themeColor}) : super(key: key);
  final IconData iconData;
  final Color themeColor;
  final String text;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
            child: Icon(iconData, color: themeColor,),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: ColorStyle.text200,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            UIcons.regularStraight.arrow_small_up,
            color: themeColor,
            size: 18,
          ),
        ],
      ),
    );
  }
}

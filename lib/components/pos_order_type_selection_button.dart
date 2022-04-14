import 'package:flutter/material.dart';
import 'package:restaurant_pos/style/color_style.dart';

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
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        child: Row(
          mainAxisSize: MainAxisSize.max,
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
                  color: ColorStyle.text100,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.arrow_right_outlined,
              color: ColorStyle.text100,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

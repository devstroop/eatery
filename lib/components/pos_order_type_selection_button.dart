import 'package:eatery/references.dart';

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
          Icon(iconData, color: themeColor,),
          const SizedBox(width: 6.0),
          Text(
            text,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: ColorStyle.text200,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 3.0),
          Icon(
            UIcons.regularStraight.arrow_small_up,
            color: themeColor,
            size: 16,
          ),
        ],
      ),
    );
  }
}

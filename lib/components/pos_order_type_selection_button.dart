import 'package:eatery/references.dart';

class PosOrderTypeSelectionButton extends StatelessWidget {
  const PosOrderTypeSelectionButton({Key? key, required this.icon, required this.text, this.onTap, required this.themeColor}) : super(key: key);
  final Widget icon;
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
          icon, // TODO: Implement icon color override
          const SizedBox(width: 6.0),
          Text(
            text,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color(0xFF2F2F2F),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 3.0),
          Icon(
            Icons.arrow_drop_up,
            color: themeColor,
            size: 24,
          ),
        ],
      ),
    );
  }
}

import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    Key? key,
    required this.color,
    required this.borderColor,
    required this.text,
    this.height,
    this.onTap,
    this.width,
  }) : super(key: key);

  final Color color;
  final Color borderColor;
  final String text;
  final double? width;
  final double? height;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: color, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

class SpecialButton extends StatelessWidget {
  const SpecialButton({
    Key? key,
    this.onTap,
    required this.icon,
    required this.text,
    required this.color,
    required this.foreColor,
  }) : super(key: key);
  final Function()? onTap;
  final Widget icon;
  final String text;
  final Color color;
  final Color foreColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.30),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(height: 24, width: 24, child: icon),
                  const SizedBox(width: 8.0),
                  Text(
                    text,
                    style: TextStyle(
                      color: foreColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Icon(Icons.chevron_right, color: foreColor),
            ],
          ),
        ),
      ),
    );
  }
}

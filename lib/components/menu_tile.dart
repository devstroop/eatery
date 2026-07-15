import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.prefixIcon,
    required this.postfixIcon,
    this.color,
    this.onTap,
  }) : super(key: key);
  final String title;
  final String? subtitle;
  final IconData prefixIcon;
  final IconData postfixIcon;
  final Color? color;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(prefixIcon, color: color ?? AppColors.black500),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.black500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey700),
            )
          : null,
      trailing: Icon(postfixIcon, color: AppColors.grey400),
    );
  }
}

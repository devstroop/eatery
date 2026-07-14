import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

class PosCategoryWidget extends StatelessWidget {
  const PosCategoryWidget({
    Key? key,
    this.active = false,
    required this.label,
    this.image,
    this.onTap,
  }) : super(key: key);

  final bool active;
  final String label;
  final Widget? image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 12),
      child: InkWell(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              color:
                  active ? AppColors.black600 : AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: active
                      ? AppColors.black600
                      : AppColors.white,
                ),
              ],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active
                    ? AppColors.black600
                    : AppColors.white,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (image != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 6),
                      child: image,
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(right: 3),
                    ),
                  const SizedBox(width: 2,),
                  Text(
                    label,
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: active
                          ? AppColors.white
                          : AppColors.black600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

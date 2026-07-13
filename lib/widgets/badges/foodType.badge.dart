import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

class FoodTypeBadge extends StatelessWidget {
  const FoodTypeBadge({Key? key, required this.foodType, this.backgroundColor, this.size = 18})
      : super(key: key);
  final FoodType? foodType;
  final Color? backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (foodType != null) {
      if (foodType == FoodType.veg) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: const Color(0xFF43A047),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF43A047),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: const AlignmentDirectional(0, 0),
            ),
          ),
        );
      } else if (foodType == FoodType.nonVeg) {
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: const Color(0xFFE53935),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: const AlignmentDirectional(0, 0),
            ),
          ),
        );
      }
    }
    return Container();
  }
}

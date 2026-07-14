import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

class LeadingImageWidget extends StatelessWidget {
  const LeadingImageWidget({super.key, required this.image, this.size = 48, this.elevation = 0, this.borderRadius, this.backgroundCo0lor, this.border});
  final ImageProvider image;
  final double size;
  final double elevation;
  final BorderRadius? borderRadius;
  final Color? backgroundCo0lor;
  final Border? border;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: borderRadius ?? BorderRadius.circular(size/2),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          border: border ?? Border.all(
              width: 0.5,
              color: (backgroundCo0lor ?? AppColors.white600).withOpacity(0.5)
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(size/2),
          color: backgroundCo0lor ?? AppColors.white,
          image: DecorationImage(
              image: image,
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}

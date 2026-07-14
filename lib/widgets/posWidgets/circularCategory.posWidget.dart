import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

class CircularCategoryPOSWidget extends StatelessWidget {
  const CircularCategoryPOSWidget({super.key, required this.image, required this.label, this.selected = false, this.themeColor, this.onTap, this.margin});
  final ImageProvider image;
  final String label;
  final bool selected;
  final Color? themeColor;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  @override
  Widget build(BuildContext context) {
    double imageBlockSize = 54;
    return Container(
      margin: margin,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  if(selected)
                  const BoxShadow(
                    color: Color(0x2F000000),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                    spreadRadius: 1,
                  ),
                  if(!selected)
                  const BoxShadow(
                    color: Color(0x00000000),
                    blurRadius: 0,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
                borderRadius: BorderRadius.circular(imageBlockSize/2),
              ),
              child: Container(
                height: imageBlockSize,
                width: imageBlockSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(imageBlockSize/2),
                  color: AppColors.white,
                  image: DecorationImage(
                      image: image,
                      fit: BoxFit.cover,
                      scale: 5
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

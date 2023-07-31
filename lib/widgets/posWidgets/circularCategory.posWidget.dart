import 'package:eatery/references.dart';

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
            Material(
              elevation: selected ? 6 : 0,
              shadowColor: selected ?  themeColor : null,
              borderRadius: BorderRadius.circular(imageBlockSize/2),
              child: Container(
                height: imageBlockSize,
                width: imageBlockSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(imageBlockSize/2),
                  color: Colors.white,
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

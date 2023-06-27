import 'package:eatery/references.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer(
      {Key? key,
      this.height,
      this.width,
      required this.onTap,
      required this.image,
      this.onLongPress})
      : super(key: key);
  final double? height;
  final double? width;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  final ImageProvider image;
  @override
  Widget build(BuildContext context) {
    // double imageSizeS = screenWidth / 4 - 15;
    // double imageSizeM = screenWidth / 6 - 15;
    // double imageSizeL = screenWidth / 8 - 15;
    // double imageSizeXL = screenWidth / 12 - 15;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F8),
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: image,
          ),
        ),
      ),
    );
  }
}

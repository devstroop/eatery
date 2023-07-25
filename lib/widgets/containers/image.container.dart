import 'package:eatery/references.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer(
      {Key? key,
      this.height,
      this.width,
      required this.onTap,
      required this.image,
      this.onLongPress, this.label, this.fit = BoxFit.cover})
      : super(key: key);
  final double? height;
  final double? width;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final BoxFit fit;

  final ImageProvider image;
  final String? label;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F8),
          borderRadius: BorderRadius.circular(4),
          boxShadow:const [
            BoxShadow(
              color: Color(0x2F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            fit: fit,
            image: image,
          ),
        ),
        child: label != null ? Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                height: 18,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                  color: Color(0x6F000000),
                ),
                child: Center(
                  child: Text(
                    label!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ) : null,
      ),
    );
  }
}

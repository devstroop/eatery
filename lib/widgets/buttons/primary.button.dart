import 'package:eatery/references.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
        required this.color,
        required this.child,
        this.onPressed,
        this.width,
        this.height, this.borderRadius = 12})
      : super(key: key);

  final Color color;
  final Widget child;
  final double? width;
  final double? height;
  final Function()? onPressed;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: child,
      ),
    );
  }
}

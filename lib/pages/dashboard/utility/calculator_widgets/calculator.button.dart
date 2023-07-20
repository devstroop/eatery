import 'package:eatery/references.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({super.key, required this.label, required this.onPressed, this.textColor, this.fontSize, this.backgroundColor});
  final String label;
  final VoidCallback onPressed;
  final Color? textColor;
  final double? fontSize;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    // This element has 4 crossAxis count
    // need to set a size for each element with spacing and run spacing of 8, rest all must be captured by the element

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: backgroundColor ?? Colors.grey[300],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize ?? 20,
          color: textColor ?? Colors.black,
        ),
      ),
    );
  }

}

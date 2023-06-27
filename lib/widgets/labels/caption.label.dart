import 'package:eatery/references.dart';

class CaptionLabel extends StatelessWidget {
  const CaptionLabel({super.key, required this.label, this.borderRadius, this.border, this.color, this.fontSize, this.fontWeight, this.padding, this.margin});
  final String label;
  final BorderRadius? borderRadius;
  final Border? border;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(0),
      padding: padding ?? const EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(4)),
          color: (color ?? Colors.blueAccent).withOpacity(0.25),
          border: border ?? Border.all(
              color: color ?? Colors.blueAccent, width: 1)),
      child: Text(
        label,
        style: TextStyle(
            fontSize: fontSize ?? 8,
            fontWeight: fontWeight ?? FontWeight.w600,
            color: color ?? Colors.blueAccent),
      ),
    );
  }
}

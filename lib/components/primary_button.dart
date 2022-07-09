import 'package:flutter/material.dart';


class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.color,
    required this.backgroundColor,
    this.text,
    this.icon,
    required this.height,
    this.onTap, this.flex, this.borderRadius
  });

  final Color color;
  final Color backgroundColor;
  final String? text;
  final Icon? icon;
  final double height;
  final int? flex;
  final Function()? onTap;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) {
    return flex != null ? Flexible(
      flex: flex!,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.maxFinite,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null ? Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: icon,
              ) : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: text != null ? Text(
                  text!,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ) : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    ):
    InkWell(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null ? Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: icon,
            ) : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: text != null ? Text(
                text!,
                style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ) : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
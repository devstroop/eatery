import 'package:flutter/material.dart';

class ToggleSwitch extends StatelessWidget {
  const ToggleSwitch({super.key, this.padding, this.margin, this.borderRadius, required this.children, this.onChange, this.selectedIndex, this.highlightColor, this.backgroundColor, this.foregroundColor, this.inactiveForegroundColor});
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final List<String> children;
  final int? selectedIndex;
  final Function(int)? onChange;
  final Color? highlightColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? inactiveForegroundColor;
  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = this.borderRadius ?? const BorderRadius.all(
      Radius.circular(12.0),
    );
    return Container(
      padding: padding ?? const EdgeInsets.all(6.0),
      height: 60,
      margin: margin,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < children.length; i++)
            InkWell(
              onTap: () => onChange!(i),
              child: Container(
                margin: const EdgeInsets.only(right: 6.0),
                child: Material(
                  elevation: selectedIndex == i ? 5 : 0,
                  borderRadius: borderRadius,
                  child: AnimatedContainer(
                    height: 60,
                    width: 100,
                    decoration: BoxDecoration(
                        color: selectedIndex == i ? highlightColor : backgroundColor,
                        borderRadius: borderRadius),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.decelerate,
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          children[i],
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: selectedIndex == i ? foregroundColor : inactiveForegroundColor,
                              fontSize: 16),
                        )),
                  ),
                ),
              ),
            ),
        ],
      )
    );
  }
}

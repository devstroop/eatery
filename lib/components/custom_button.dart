import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.text, this.onTap}) : super(key: key);
  final String text;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 56,
          height: 30,
          decoration: BoxDecoration(
            borderRadius : const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
            color : const Color.fromRGBO(236, 253, 254, 1),
            border : Border.all(
              color: const Color.fromRGBO(48, 167, 206, 1),
              width: 1,
            ),
          ),
        child: Center(
          child: Text(text, textAlign: TextAlign.left, style: TextStyle(
              color: ColorStyle.primary,
              fontSize: 13,
          ),),
        ),
      ),
    );
  }
}

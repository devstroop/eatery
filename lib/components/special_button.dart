import 'package:flutter/material.dart';

class SpecialButton extends StatelessWidget {
  const SpecialButton({Key? key, this.onTap, required this.icon, required this.text, required this.color, required this.foreColor}) : super(key: key);
  final Function()? onTap;
  final IconData icon;
  final String text;
  final Color color;
  final Color foreColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: foreColor,
                    size: 36.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    text,
                    style: TextStyle(
                        color: foreColor, fontWeight: FontWeight.w600, fontSize: 18.0),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_sharp,
                color: foreColor,
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 4.0,
            ),
          ],
        ),
      ),
    );
  }
}

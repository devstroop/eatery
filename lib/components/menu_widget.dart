import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    Key? key,
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  }) : super(key: key);

  final IconData iconData;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double itemWidth = screenWidth <= 500
    //     ? screenWidth / 2.5
    //     : screenWidth <= 1000
    //         ? screenWidth / 5
    //         : screenWidth / 7.5;
    final double itemWidth =
        screenWidth > 500 ? (screenWidth / 2) * 0.4 : screenWidth * 0.4;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: itemWidth,
        height: itemWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x37000000),
              offset: Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                0,
                screenWidth > 600 ? 16 : 12,
                0,
                0,
              ),
              child: Icon(
                iconData,
                color: Colors.white,
                size: screenWidth > 600 ? 44 : 32,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                0,
                screenWidth > 600 ? 8 : 4,
                0,
                0,
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth > 600 ? 18 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  8,
                  4,
                  8,
                  0,
                ),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xB3FFFFFF),
                    fontSize: screenWidth > 600 ? 12 : 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

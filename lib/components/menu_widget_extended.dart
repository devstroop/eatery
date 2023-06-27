import 'package:eatery/references.dart';

class MenuWidgetExtended extends StatelessWidget {
  const MenuWidgetExtended({
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
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double itemWidth =
        screenWidth > 500 ? (screenWidth / 2) * 0.85 : screenWidth * 0.85;
    final double iconSize = screenWidth > 600 ? 44 : 36;
    final double titleFontSize = screenWidth > 600 ? 18 : 14;
    final double subtitleFontSize = screenWidth > 600 ? 12 : 10;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: itemWidth,
        height: 75,
        decoration: BoxDecoration(
          color: color,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x37000000),
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: Icon(
                iconData,
                color: Colors.white,
                size: iconSize,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xB3FFFFFF),
                        fontSize: subtitleFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

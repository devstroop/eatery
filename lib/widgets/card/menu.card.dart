import 'package:eatery/references.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    Key? key,
    required this.iconData,
    required this.title,
    this.subtitle,
    required this.color,
    this.onTap,
    this.width,
    this.height,
    this.iconSize,
    this.titleSize,
    this.subtitleSize,
    this.padding,
  }) : super(key: key);

  final IconData iconData;
  final String title;
  final String? subtitle;
  final Color color;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? iconSize;
  final double? titleSize;
  final double? subtitleSize;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(12),
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x37000000),
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: Colors.white, size: iconSize),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xB3FFFFFF),
                  fontSize: subtitleSize,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

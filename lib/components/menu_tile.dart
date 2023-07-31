import 'package:eatery/references.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({Key? key, required this.title, this.subtitle, required this.prefixIcon, required this.postfixIcon, this.color, this.onTap}) : super(key: key);
  final String title;
  final String? subtitle;
  final IconData prefixIcon;
  final IconData postfixIcon;
  final Color? color;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: KColors.backgroundColorAlter,
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Icon(
                        prefixIcon,
                        color: color,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:
                          TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: KColors.text200),
                        ),
                        subtitle != null ?
                        Text(
                          subtitle!,
                          style:
                          TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: KColors.text400),
                        ) : Container()
                      ],
                    )
                  ],
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                child: Icon(
                  postfixIcon,
                  size: 16,
                  color: KColors.text400,
                  //style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                )),
          ],
        ),
      ),
    );
  }
}

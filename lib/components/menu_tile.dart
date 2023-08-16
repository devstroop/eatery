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
    return ListTile(
      onTap: onTap,
      leading: Icon(prefixIcon, color: color ?? KColors.black500),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color ?? KColors.black500)),
      subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(color: Colors.grey[700])) : null,
      trailing: Icon(postfixIcon, color: Colors.grey[400]),
    );
  }
}

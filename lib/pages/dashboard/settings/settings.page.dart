import 'package:eatery/references.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  Color getThemeColor() {
    return ColorStyle.primary;
  }

  SizedBox options() {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child:
          ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        MenuTile(
          prefixIcon: UIcons.regularStraight.business_time,
          title: 'Company',
          subtitle: 'Manage Company Profile',
          postfixIcon: UIcons.regularStraight.arrow_right,
          color: getThemeColor(),
          onTap: () {
            Navigator.push(
              this.context,
              MaterialPageRoute(builder: (context) => const ShowCompanyPage()),
            ).then((_) => setState(() {}));
          },
        ),
        MenuTile(
          prefixIcon: UIcons.regularStraight.user,
          title: 'Currency and Region',
          subtitle: 'Manage Currency and Region Settings',
          postfixIcon: UIcons.regularStraight.arrow_right,
          color: getThemeColor(),
          onTap: () => Navigator.push(
            this.context,
            MaterialPageRoute(
                builder: (context) => const ShowCurrencyRegionPage()),
          ),
        ),
        MenuTile(
          prefixIcon: UIcons.regularStraight.percentage,
          title: 'Tax',
          subtitle: 'Manage Tax Slabs',
          postfixIcon: UIcons.regularStraight.arrow_right,
          color: getThemeColor(),
          onTap: () => Navigator.push(
            this.context,
            MaterialPageRoute(
                builder: (context) =>
                    const TaxSlabsSettingsPage()),
          ),
        ),
        MenuTile(
          prefixIcon: UIcons.regularStraight.print,
          title: 'Printer',
          subtitle: 'Manage Printing Devices',
          postfixIcon: UIcons.regularStraight.arrow_right,
          color: getThemeColor(),
          /*onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrinterSettingsPage(account: widget.account)),
          ),*/
        ),
        MenuTile(
          prefixIcon: UIcons.regularStraight.comment_user,
          title: 'Help',
          subtitle: 'Get support',
          postfixIcon: UIcons.regularStraight.arrow_right,
          color: getThemeColor(),
          onTap: () => showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              context: this.context,
              builder: (context) => const HelpBottomSheet()),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Settings'),
      leading: IconButton(
        icon: Icon(UIcons.regularStraight.arrow_left),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    );
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
              top: 12.0, left: 0.0, right: 0.0, bottom: 72, child: options()),
        ],
      ),
    );
  }
}

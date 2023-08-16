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
    return KColors.primary;
  }

  SizedBox options() {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child:
          ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        MenuTile(
          prefixIcon: Icons.business,
          title: 'Company',
          subtitle: 'Manage Company Profile',
          postfixIcon: Icons.arrow_right,
          color: getThemeColor(),
          onTap: () {
            Navigator.push(
              this.context,
              MaterialPageRoute(builder: (context) => const ShowCompanyPage()),
            ).then((_) => setState(() {}));
          },
        ),
        MenuTile(
          prefixIcon: Icons.attach_money,
          title: 'Currency and Region',
          subtitle: 'Manage Currency and Region Settings',
          postfixIcon: Icons.arrow_right,
          color: getThemeColor(),
          onTap: () => Navigator.push(
            this.context,
            MaterialPageRoute(
                builder: (context) => const ShowCurrencyRegionPage()),
          ),
        ),
        MenuTile(
          prefixIcon: Icons.percent,
          title: 'Tax',
          subtitle: 'Manage Tax Slabs',
          postfixIcon: Icons.arrow_right,
          color: getThemeColor(),
          onTap: () => Navigator.push(
            this.context,
            MaterialPageRoute(
                builder: (context) =>
                    const TaxSlabsSettingsPage()),
          ),
        ),
        MenuTile(
          prefixIcon: Icons.print,
          title: 'Printer',
          subtitle: 'Manage Printing Devices',
          postfixIcon: Icons.arrow_right,
          color: getThemeColor(),
          /*onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrinterSettingsPage(account: widget.account)),
          ),*/
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Settings'),
      foregroundColor: Colors.white,
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

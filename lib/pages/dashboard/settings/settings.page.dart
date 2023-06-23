import 'package:eatery/components/bottomsheets/help_bottom_sheet.dart';
import 'package:eatery/pages/dashboard/settings/taxSlab/taxSlabs.page.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/menu_tile.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'company/showCompany.page.dart';
import 'currency/showCurrencyRegion.page.dart';

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
          prefixIcon: Icons.business,
          title: 'Company',
          subtitle: 'Manage Company Profile',
          postfixIcon: Icons.arrow_forward_ios_sharp,
          color: getThemeColor(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ShowCompanyPage()),
            ).then((_) => setState(() {}));
          },
        ),
        MenuTile(
          prefixIcon: Icons.currency_exchange,
          title: 'Currency and Region',
          subtitle: 'Manage Currency and Region Settings',
          postfixIcon: Icons.arrow_forward_ios_sharp,
          color: getThemeColor(),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ShowCurrencyRegionPage()),
          ),
        ),
        MenuTile(
          prefixIcon: Icons.percent,
          title: 'Tax',
          subtitle: 'Manage Tax Slabs',
          postfixIcon: Icons.arrow_forward_ios_sharp,
          color: getThemeColor(),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const TaxSlabsSettingsPage()),
          ),
        ),
        MenuTile(
          prefixIcon: Icons.print,
          title: 'Printer',
          subtitle: 'Manage Printing Devices',
          postfixIcon: Icons.arrow_forward_ios_sharp,
          color: getThemeColor(),
          /*onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrinterSettingsPage(account: widget.account)),
          ),*/
        ),
        MenuTile(
          prefixIcon: Icons.help,
          title: 'Help',
          subtitle: 'Get support',
          postfixIcon: Icons.arrow_forward_ios_sharp,
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
              context: context,
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

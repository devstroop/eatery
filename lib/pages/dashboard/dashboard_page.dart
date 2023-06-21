import 'package:eatery/components/menu_widget.dart';
import 'package:eatery/components/menu_widget_extended.dart';
import 'package:eatery/constants/global_variables.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/pages/backup_restore/backup_restore_page.dart';
import 'package:eatery/pages/dashboard/components/dashboard_header.dart';
import 'package:eatery/pages/dashboard/components/notifications/low_battery_warning_notification.dart';
import 'package:eatery/pages/dashboard/components/notifications/upgrade_notification.dart';
import 'package:eatery/pages/dashboard/diningTable/diningTables.page.dart';
import 'package:eatery/pages/dashboard/product/productCategory/productCategories.page.dart';
import 'package:eatery/pages/dashboard/product/inventoryItem/inventory.page.dart';
import 'package:eatery/pages/dashboard/product/kitchenDishes/kitchenDishes.page.dart';
import 'package:eatery/pages/dashboard/pos/pointOfSale.page.dart';
import 'package:eatery/pages/dashboard/reports/reports_page.dart';
import 'package:eatery/pages/dashboard/settings/settings.page.dart';
import 'package:eatery/pages/dashboard/waiter/waiters_page.dart';
import 'package:eatery/services/utility/file.utility.service.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/logout_page.dart';
import 'importExport/importExport.page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.company}) : super(key: key);
  final Company company;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      GlobalVariables.company = widget.company;
      GlobalVariables.currency = EateryDB.instance.currencyBox
          .get(GlobalVariables.company?.currencyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    double crossAxisItemCount;
    double menuSize;
    double spacing;
    double iconSize;
    double titleSize;
    double subtitleSize;

    if (screenWidth >= 1200) {
      crossAxisItemCount = 5;
      spacing = 32;
      iconSize = 72;
      titleSize = 24;
      subtitleSize = 18;
    } else if (screenWidth >= 800) {
      crossAxisItemCount = 4;
      spacing = 24;
      iconSize = 60;
      titleSize = 20;
      subtitleSize = 16;
    } else if (screenWidth >= 600) {
      crossAxisItemCount = 3;
      spacing = 20;
      iconSize = 48;
      titleSize = 18;
      subtitleSize = 14;
    } else {
      crossAxisItemCount = 2;
      spacing = 16;
      iconSize = 36;
      titleSize = 16;
      subtitleSize = 12;
    }

    menuSize = (screenWidth - (spacing * (crossAxisItemCount + 1))) / crossAxisItemCount;


    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffoldKey,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: spacing, vertical: 60),
          children: [
            DashboardHeader(
              companyName: GlobalVariables.company!.name,
              logoPath: FileUtilityService.getAbsolutePath(GlobalVariables.company?.logo ?? ''),
              suffix: [
                IconButton(icon: Icon(UIcons.regularStraight.log_out,), onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LogoutPage(),
                                  ),
                                );
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'),
                            ),
                          ],
                        );
                      });
                },)
              ],
            ),
            UpgradeNotification(
                company: GlobalVariables.company,),
            const LowBatteryWarningNotification(),
            const SizedBox(height: 16),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              alignment: WrapAlignment.spaceBetween,
              children: [
                MenuWidget(
                  iconData: UIcons.regularStraight.calculator,
                  iconSize: iconSize,
                  title: 'Point of Sale',
                  subtitle: 'Tap here to start your sale',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  color: ColorStyle.primary,
                  width: menuSize,
                  height: menuSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PointOfSalePage(),
                      ),
                    );
                  },
                ),
                MenuWidget(
                  iconData: UIcons.regularStraight.table_tree,
                  iconSize: iconSize,
                  title: 'Categories',
                  subtitle: 'Manage your product categories here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  color: ColorStyle.tertiary,
                  width: menuSize,
                  height: menuSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ProductCategoriesPage(),
                      ),
                    );
                  },
                ),
                MenuWidget(
                  iconData: UIcons.regularStraight.restaurant,
                  iconSize: iconSize,
                  title: 'Kitchen',
                  subtitle: 'Manage your dishes here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  color: const Color(0xFF2FC289),
                  width: menuSize,
                  height: menuSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KitchenPage(),
                      ),
                    );
                  },
                ),
                MenuWidget(
                  iconData: UIcons.regularStraight.boxes,
                  iconSize: iconSize,
                  title: 'Inventory',
                  subtitle: 'Manage your items here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  color: const Color(0xFF6850EF),
                  width: menuSize,
                  height: menuSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InventoryPage(),
                      ),
                    );
                  },
                ),
                MenuWidget(
                  iconData: UIcons.regularStraight.terrace,
                  iconSize: iconSize,
                  title: 'Dining Tables',
                  subtitle: 'Manage your dining tables here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  color: const Color(0xFFEF9050),
                  width: menuSize,
                  height: menuSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiningTablesPage(),
                      ),
                    );
                  },
                ),
                MenuWidget(
                  iconData: UIcons.regularStraight.people_poll,
                  iconSize: iconSize,
                  title: 'Waiters',
                  subtitle: 'Manage your waiters here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  color: const Color(0xFFC2592F),
                  width: menuSize,
                  height: menuSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WaitersPage(),
                      ),
                    );
                  },
                ),
                MenuWidget(
                  iconData: UIcons.regularStraight.list,
                  iconSize: iconSize,
                  title: 'Reports',
                  subtitle: 'All reports and record are here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  color: const Color(0xFFF5B942),
                  width: menuSize,
                  height: menuSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportsPage(),
                      ),
                    );
                  },
                ),
                MenuWidget(
                  iconData: UIcons.regularStraight.settings,
                  iconSize: iconSize,
                  title: 'Settings',
                  subtitle: 'Manage your settings here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  width: menuSize,
                  height: menuSize,
                  color: const Color(0xFF222222),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingPage(),
                      ),
                    ).then((_) async {
                      setState(() {});
                    });
                  },
                ),
                MenuWidget(
                  iconData: UIcons.regularStraight.exchange,
                  iconSize: iconSize,
                  title: 'Import / Export',
                  subtitle: 'Import Products/Invoices here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  width: menuSize,
                  height: menuSize,
                  color: const Color(0xFFEF9050),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImportExportPage(),
                      ),
                    );
                  },
                ),
                MenuWidget(
                  iconData: UIcons.regularStraight.time_past,
                  iconSize: iconSize,
                  title: 'Backup / Restore',
                  subtitle: 'Backup and Restore is here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  width: menuSize,
                  height: menuSize,
                  color: const Color(0xFF2FC289),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BackupRestorePage(),
                      ),
                    );
                  },
                ),
                // MenuWidgetExtended(
                //   iconData: UIcons.regularStraight.log_out,
                //   title: 'Logout',
                //   subtitle: 'Close the session',
                //   color: const Color(0xFFEF5350),
                //   onTap: () async {
                //     final prefs = await SharedPreferences.getInstance();
                //     await prefs.remove('companyId').then((value) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const LogoutPage(),
                //         ),
                //       );
                //     });
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

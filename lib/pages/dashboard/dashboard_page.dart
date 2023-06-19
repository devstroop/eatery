import 'package:eatery/components/menu_widget.dart';
import 'package:eatery/components/menu_widget_extended.dart';
import 'package:eatery/constants/global_variables.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/pages/backup_restore/backup_restore_page.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/pages/dashboard/components/dashboard_header.dart';
import 'package:eatery/pages/dashboard/components/notifications/low_battery_warning_notification.dart';
import 'package:eatery/pages/dashboard/components/notifications/upgrade_notification.dart';
import 'package:eatery/pages/dashboard/dining_table/dining_tables_page.dart';
import 'package:eatery/pages/dashboard/product/categories/product_categories_page.dart';
import 'package:eatery/pages/dashboard/product/inventory/inventory_page.dart';
import 'package:eatery/pages/dashboard/product/kitchen/kitchen_page.dart';
import 'package:eatery/pages/dashboard/pos/point_of_sale_page.dart';
import 'package:eatery/pages/dashboard/reports/reports_page.dart';
import 'package:eatery/pages/dashboard/settings/settings.page.dart';
import 'package:eatery/pages/dashboard/waiter/waiters_page.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_db/models/company/company.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uicons/uicons.dart';
import '../auth/logout_page.dart';
import 'import_export/import_export_page.dart';

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
      GlobalVariables.currency =
          EateryDB().currencyBox().get(GlobalVariables.company?.currencyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                DashboardHeader(
                  companyName: widget.company.name,
                  logoPath: widget.company.logo,
                ),
                UpgradeNotification(
                    company: widget.company, width: screenWidth * 0.85),
                LowBatteryWarningNotification(width: screenWidth * 0.85),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      MenuWidget(
                        iconData: UIcons.regularStraight.calculator,
                        title: 'POS',
                        subtitle: 'Tap here to start your sale',
                        color: ColorStyle.primary,
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
                        title: 'Categories',
                        subtitle: 'Manage your product categories here',
                        color: ColorStyle.tertiary,
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
                        title: 'Kitchen',
                        subtitle: 'Manage your dishes here',
                        color: const Color(0xFF2FC289),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KitchenPage(
                                company: widget.company,
                              ),
                            ),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: UIcons.regularStraight.package,
                        title: 'Inventory',
                        subtitle: 'Manage your items here',
                        color: const Color(0xFF6850EF),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InventoryPage(
                                company: widget.company,
                              ),
                            ),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: UIcons.regularStraight.terrace,
                        title: 'Tables',
                        subtitle: 'Manage your dining tables here',
                        color: const Color(0xFFEF9050),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiningTablesPage(
                                company: widget.company,
                              ),
                            ),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: UIcons.regularStraight.people_poll,
                        title: 'Waiters',
                        subtitle: 'Manage your waiters here',
                        color: const Color(0xFFC2592F),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WaitersPage(
                                company: widget.company,
                              ),
                            ),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: UIcons.regularStraight.list,
                        title: 'Reports',
                        subtitle: 'All sales are here',
                        color: const Color(0xFFF5B942),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportsPage(
                                company: widget.company,
                              ),
                            ),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: UIcons.regularStraight.settings,
                        title: 'Settings',
                        subtitle: 'Manage your settings here',
                        color: const Color(0xFF222222),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingPage(
                                company: widget.company,
                              ),
                            ),
                          ).then((_) async {
                            setState(() {});
                          });
                        },
                      ),
                      MenuWidget(
                        iconData: UIcons.regularStraight.exchange,
                        title: 'Import / Export',
                        subtitle: 'Import Products/Invoices here',
                        color: const Color(0xFFEF9050),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImportExportPage(
                                company: widget.company,
                              ),
                            ),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: UIcons.regularStraight.time_past,
                        title: 'Backup / Restore',
                        subtitle: 'Backup and Restore is here',
                        color: const Color(0xFF2FC289),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BackupRestorePage(
                                company: widget.company,
                              ),
                            ),
                          );
                        },
                      ),
                      MenuWidgetExtended(
                        iconData: UIcons.regularStraight.log_out,
                        title: 'Logout',
                        subtitle: 'Close the session',
                        color: const Color(0xFFEF5350),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('companyId').then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogoutPage(
                                  company: widget.company,
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

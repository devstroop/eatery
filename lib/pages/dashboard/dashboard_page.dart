import 'package:eatery/pages/auth/logout_page.dart';
import 'package:eatery/pages/dashboard/components/dashboard_header.dart';
import 'package:eatery/pages/dashboard/components/notifications/low_battery_warning_notification.dart';
import 'package:eatery/pages/dashboard/pos/point_of_sale_page.dart';
import 'package:eatery/pages/dashboard/product/categories/product_categories_page.dart';
import 'package:eatery/pages/dashboard/product/inventory/inventory_page.dart';
import 'package:eatery/pages/dashboard/product/kitchen/kitchen_page.dart';
import 'package:eatery/pages/dashboard/reports/reports_page.dart';
import 'package:eatery/pages/dashboard/settings/settings.page.dart';
import 'package:eatery/pages/dashboard/waiter/waiters_page.dart';
import 'package:eatery_db/models/company/company.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eatery/components/menu_widget.dart';
import 'package:eatery/components/menu_widget_extended.dart';
import 'package:eatery/pages/backup_restore/backup_restore_page.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/notifications/upgrade_notification.dart';
import 'dining_table/dining_tables_page.dart';
import 'import_export/import_export_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.company}) : super(key: key);
  final Company company;
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late int batteryLevel;

  @override
  void initState() {
    super.initState();
  }

  Color themeColor = ColorStyle.brandColor;

  @override
  Widget build(BuildContext context) {
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
                UpgradeNotification(company: widget.company),
                const LowBatteryWarningNotification(),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MenuWidget(
                        iconData: Icons.store,
                        title: 'POS',
                        subtitle: 'Tap here to start your sale',
                        color: ColorStyle.primary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PointOfSalePage()),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: Icons.category_rounded,
                        title: 'Categories',
                        subtitle: 'Manage your product categories here',
                        color: ColorStyle.tertiary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProductCategoriesPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MenuWidget(
                        iconData: FontAwesomeIcons.itchIo,
                        title: 'Kitchen',
                        subtitle: 'Manage your dishes here',
                        color: const Color(0xFF2FC289),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KitchenPage(
                                      company: widget.company,
                                    )),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: FontAwesomeIcons.warehouse,
                        title: 'Inventory',
                        subtitle: 'Manage your items here',
                        color: const Color(0xFF6850EF),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InventoryPage(
                                      company: widget.company,
                                    )),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MenuWidget(
                        iconData: Icons.table_chart,
                        title: 'Tables',
                        subtitle: 'Manage your dining tables here',
                        color: const Color(0xFFEF9050),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiningTablesPage(
                                      company: widget.company,
                                    )),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: Icons.emoji_people,
                        title: 'Waiters',
                        subtitle: 'Manage your waiters here',
                        color: const Color(0xFFC2592F),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WaitersPage(
                                      company: widget.company,
                                    )),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MenuWidget(
                        iconData: Icons.history,
                        title: 'Reports',
                        subtitle: 'All sales are here',
                        color: const Color(0xFFF5B942),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportsPage(
                                      company: widget.company,
                                    )),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: Icons.settings,
                        title: 'Settings',
                        subtitle: 'Manage your settings here',
                        color: const Color(0xFF222222),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingPage(
                                      company: widget.company,
                                    )),
                          ).then((_) async {
                            setState(() {});
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MenuWidget(
                        iconData: Icons.import_export,
                        title: 'Import / Export',
                        subtitle: 'Import Products/Invoices here',
                        color: const Color(0xFFEF9050),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImportExportPage(
                                      company: widget.company,
                                    )),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: Icons.settings_backup_restore,
                        title: 'Backup / Restore',
                        subtitle: 'Backup and Restore is here',
                        color: const Color(0xFF2FC289),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BackupRestorePage(
                                      company: widget.company,
                                    )),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MenuWidgetExtended(
                        iconData: Icons.logout,
                        title: 'Logout',
                        subtitle: 'Close the session',
                        color: const Color(0xFFEF5350),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('companyId');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogoutPage(
                                      company: widget.company,
                                    )),
                          );
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

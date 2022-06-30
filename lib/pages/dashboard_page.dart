import 'dart:io';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_pos/components/menu_widget.dart';
import 'package:restaurant_pos/components/menu_widget_extended.dart';
import 'package:restaurant_pos/components/notification_widget.dart';
import 'package:restaurant_pos/pages/backup_restore_page.dart';
import 'package:restaurant_pos/pages/import_export_page.dart';
import 'package:restaurant_pos/pages/product_categories_page.dart';
import 'package:restaurant_pos/pages/help_page.dart';
import 'package:restaurant_pos/pages/history_page.dart';
import 'package:restaurant_pos/pages/inventory_page.dart';
import 'package:restaurant_pos/pages/kitchen_page.dart';
import 'package:restaurant_pos/pages/logout_page.dart';
import 'package:restaurant_pos/pages/point_of_sale_page.dart';
import 'package:restaurant_pos/pages/settings_page.dart';
import 'package:restaurant_pos/pages/dining_tables_page.dart';
import 'package:restaurant_pos/pages/waiters_page.dart';
import 'package:restaurant_pos/style/color_style.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.account}) : super(key: key);
  final Map<String, dynamic> account;

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

  getBatteryLevel() async {
    if (Platform.isIOS) {
      return (await BatteryInfoPlugin().iosBatteryInfo)!.batteryLevel;
    } else if (Platform.isAndroid) {
      return (await BatteryInfoPlugin().androidBatteryInfo)!.batteryLevel;
    } else {
      return 100;
    }
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                widget.account['name'] ?? 'NA',
                                style: const TextStyle(
                                  color: Color(0xFF8B97A2),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: const [
                              Text(
                                'Dashboard',
                                style: TextStyle(
                                  color: Color(0xFF090F13),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 24.0, top: 16.0),
                      child: SizedBox(
                        height: 64,
                        width: 64,
                        child: widget.account['image'] != null
                            ? Image(
                                image: Image.file(
                                File(widget.account['image']),
                              ).image)
                            : Container(),
                      ),
                    )
                  ],
                ),
                FutureBuilder(
                  future: getBatteryLevel(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data <= widget.account['lowBatteryLevel']) {
                      return NotificationWidget(message: 'Battery level is ${snapshot.data}% in need of charging.', timestamp: true,);
                    } else {
                      return Container();
                    }
                  },
                ),
                // Modify here
                widget.account['purchaseCode'] == null ? Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: NotificationWidget(message: 'Activate Product', header: "Upgrade", icon: const Icon(Icons.workspace_premium, color: Colors.amber,),
                      onTap: (){

                      },
                    )
                ) : Container(),
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
                                builder: (context) => PointOfSalePage(
                                      account: widget.account,
                                    )),
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
                            MaterialPageRoute(builder: (context) => const ProductCategoriesPage()),
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
                                      account: widget.account,
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
                                      account: widget.account,
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
                            MaterialPageRoute(builder: (context) => const DiningTablesPage()),
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
                            MaterialPageRoute(builder: (context) => const WaitersPage()),
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
                        title: 'History',
                        subtitle: 'All sales are here',
                        color: const Color(0xFFF5B942),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryPage(
                                      account: widget.account,
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
                            MaterialPageRoute(builder: (context) => const SettingPage()),
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
                        iconData: Icons.import_export,
                        title: 'Import / Export',
                        subtitle: 'Import Products/Invoices here',
                        color: const Color(0xFFEF9050),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImportExportPage(
                                      account: widget.account,
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
                                      account: widget.account,
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
                      /*MenuWidget(
                        iconData: Icons.help_outline,
                        title: 'Help',
                        subtitle: 'Do you need an assistance?',
                        color: const Color(0xFF42A5F5),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HelpPage()),
                          );
                        },
                      ),*/
                      MenuWidgetExtended(
                        iconData: Icons.logout,
                        title: 'Logout',
                        subtitle: 'Close the session',
                        color: const Color(0xFFEF5350),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LogoutPage()),
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

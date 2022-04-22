import 'dart:io';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:battery_info/enums/charging_status.dart';
import 'package:battery_info/model/iso_battery_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/menu_widget.dart';
import 'package:restaurant_pos/components/notification_widget.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/database/linker.dart';
import 'package:restaurant_pos/pages/categories_page.dart';
import 'package:restaurant_pos/pages/create_account_3_page.dart';
import 'package:restaurant_pos/pages/help_page.dart';
import 'package:restaurant_pos/pages/history_page.dart';
import 'package:restaurant_pos/pages/inventory_page.dart';
import 'package:restaurant_pos/pages/kitchen_page.dart';
import 'package:restaurant_pos/pages/logout_page.dart';
import 'package:restaurant_pos/pages/point_of_sale_page.dart';
import 'package:restaurant_pos/pages/setting_page.dart';
import 'package:restaurant_pos/pages/tables_page.dart';
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
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.account['name'] ?? 'NA',
                      style: TextStyle(
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                          child: Text(
                            'Sale',
                            style: TextStyle(
                              color: ColorStyle.text200,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '${Linker.getTodaySales()['active']}/${Linker.getTodaySales()['total']}',
                          style: TextStyle(
                            color: ColorStyle.text100,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                          child: Text(
                            'Due',
                            style: TextStyle(
                              color: ColorStyle.text200,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '${Linker.getCurrencySymbol()}${Linker.getTodaySales()['due']}',
                          style: TextStyle(
                            color: ColorStyle.text100,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                          child: Text(
                            'Paid',
                            style: TextStyle(
                              color: ColorStyle.text200,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '${Linker.getCurrencySymbol()}${Linker.getTodaySales()['paid']}',
                          style: TextStyle(
                            color: ColorStyle.text100,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: getBatteryLevel(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  Widget widget;
                  if (snapshot.connectionState == ConnectionState.done && snapshot.data <= Linker.getBatteryWarningLevel()) {
                    return NotificationWidget(message: 'Battery level is ${snapshot.data}% in need of charging.');
                  } else {
                    return Container();
                  }
                },
              ),
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
                          MaterialPageRoute(builder: (context) => const PointOfSalePage()),
                        );
                      },
                    ),
                    MenuWidget(
                      iconData: Icons.category_rounded,
                      title: 'Categories',
                      subtitle: 'Manage your item categories here',
                      color: ColorStyle.tertiary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CategoriesPage()),
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
                          MaterialPageRoute(builder: (context) => const KitchenPage()),
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
                          MaterialPageRoute(builder: (context) => const InventoryPage()),
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
                          MaterialPageRoute(builder: (context) => const TablesPage()),
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
                          MaterialPageRoute(builder: (context) => const HistoryPage()),
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
                    ),
                    MenuWidget(
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
    );
  }
}

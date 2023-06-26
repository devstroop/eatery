import 'package:eatery/components/menu_widget.dart';
import 'package:eatery/constants/global_variables.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/pages/backupRestore/backupRestore.page.dart';
import 'package:eatery/pages/dashboard/components/dashboardHeader.dart';
import 'package:eatery/pages/dashboard/components/notifications/upgrade.notification.dart';
import 'package:eatery/pages/dashboard/diningTable/diningTables.page.dart';
import 'package:eatery/pages/dashboard/product/productCategory/productCategories.page.dart';
import 'package:eatery/pages/dashboard/product/inventoryItem/inventory.page.dart';
import 'package:eatery/pages/dashboard/product/kitchenDishes/kitchenDishes.page.dart';
import 'package:eatery/pages/dashboard/pos/pointOfSale.page.dart';
import 'package:eatery/pages/dashboard/reports/reports.page.dart';
import 'package:eatery/pages/dashboard/settings/settings.page.dart';
import 'package:eatery/pages/dashboard/waiter/waiters.page.dart';
import 'package:eatery/widgets/bottomSheets/imageLibrary.bottomSheet.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/appengine/v1.dart';
import '../../services/utility/library_image.dart';
import '../authentication/logout.page.dart';
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
    Future.delayed(Duration.zero, (){
      setState(() {
        GlobalVariables.company = widget.company;
        GlobalVariables.currency = EateryDB.instance.currencyBox
            .get(GlobalVariables.company?.currencyId);
      });
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
      spacing = 24;
      iconSize = 48;
      titleSize = 20;
      subtitleSize = 16;
    } else if (screenWidth >= 800) {
      crossAxisItemCount = 4;
      spacing = 20;
      iconSize = 44;
      titleSize = 18;
      subtitleSize = 14;
    } else if (screenWidth >= 600) {
      crossAxisItemCount = 3;
      spacing = 16;
      iconSize = 40;
      titleSize = 16;
      subtitleSize = 12;
    } else {
      crossAxisItemCount = 2;
      spacing = 12;
      iconSize = 36;
      titleSize = 14;
      subtitleSize = 10;
    }

    menuSize = (screenWidth - (spacing * (crossAxisItemCount + 1))) /
        crossAxisItemCount;
    if(GlobalVariables.company == null){
      return const Center(child: CircularProgressIndicator(),);
    }
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
              image: GlobalVariables.company?.logo != null
                  ? LibraryImage(GlobalVariables.company?.logo).image
                  : null,
              suffix: [
                IconButton(
                  icon: Icon(
                    UIcons.regularStraight.log_out,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Logout'),
                            content:
                                const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
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
                            ],
                          );
                        });
                  },
                )
              ],
            ),
            UpgradeNotification(
              company: GlobalVariables.company,
            ),
            // const LowBatteryWarningNotification(),
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







                SizedBox(
                  width: menuSize,
                  height: menuSize,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [

                      MenuWidget(
                        iconData: UIcons.regularStraight.table_tree,
                        iconSize: iconSize / 1.5,
                        title: 'Product Categories',
                        // subtitle: 'Manage product categories',
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        color: ColorStyle.tertiary,
                        width: (menuSize),
                        height: (menuSize - 8)/2,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductCategoriesPage(),
                            ),
                          );
                        },
                      ),
                      MenuWidget(
                        iconData: UIcons.regularStraight.restaurant,
                        iconSize: iconSize / 1.5,
                        title: 'Kitchen',
                        // subtitle: 'Manage kitchen dishes',
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        color: ColorStyle.secondary,
                        width: (menuSize - 8)/2,
                        height: (menuSize - 8)/2,
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
                        iconSize: iconSize / 1.5,
                        title: 'Inventory',
                        // subtitle: 'Manage product categories',
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        color: ColorStyle.alternate,
                        width: (menuSize - 8)/2,
                        height: (menuSize - 8)/2,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InventoryPage(),
                            ),
                          );
                        },
                      ),
                  ],),
                ),




                // MenuWidget(
                //   iconData: UIcons.regularStraight.table_tree,
                //   iconSize: iconSize,
                //   title: 'Categories',
                //   subtitle: 'Manage your product categories here',
                //   titleSize: titleSize,
                //   subtitleSize: subtitleSize,
                //   color: ColorStyle.tertiary,
                //   width: menuSize,
                //   height: menuSize,
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const ProductCategoriesPage(),
                //       ),
                //     );
                //   },
                // ),
                // MenuWidget(
                //   iconData: UIcons.regularStraight.restaurant,
                //   iconSize: iconSize,
                //   title: 'Kitchen',
                //   subtitle: 'Manage your dishes here',
                //   titleSize: titleSize,
                //   subtitleSize: subtitleSize,
                //   color: const Color(0xFF2FC289),
                //   width: menuSize,
                //   height: menuSize,
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const KitchenPage(),
                //       ),
                //     );
                //   },
                // ),
                // MenuWidget(
                //   iconData: UIcons.regularStraight.boxes,
                //   iconSize: iconSize,
                //   title: 'Inventory',
                //   subtitle: 'Manage your items here',
                //   titleSize: titleSize,
                //   subtitleSize: subtitleSize,
                //   color: const Color(0xFF6850EF),
                //   width: menuSize,
                //   height: menuSize,
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const InventoryPage(),
                //       ),
                //     );
                //   },
                // ),
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
                MenuWidget(
                  iconData: UIcons.regularStraight.gallery,
                  iconSize: iconSize,
                  title: 'Library',
                  subtitle: 'Images and resources are here',
                  titleSize: titleSize * 1.25,
                  subtitleSize: subtitleSize * 1.25,
                  width: menuSize * 2 + spacing,
                  height: menuSize,
                  color: const Color(0xFF2FC289),
                  onTap: () {

                    showModalBottomSheet(context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                        builder: (context) => ImageLibraryBottomSheet(context, (value){
                      // Display in full screen view

                      showDialog(context: context, builder: (context) {

                        final image = Image(image: (value ?? LibraryImage('')).image);
                        return Dialog(
                          // Add close button to dialog (top right)
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: image.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.80,
                            // Set height with aspect ratio to image size and screen width
                            // height: MediaQuery.of(context).size.width * 0.80 * (image.height ?? 1) / (image.width ?? 1),
                            // height: MediaQuery.of(context).size.height * 0.80,
                          ),
                        );
                      });
                    }));
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

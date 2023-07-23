import 'package:eatery/references.dart';


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
                  icon: const Icon(
                    Icons.power_settings_new,
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
                MenuCard(
                  iconData: Icons.point_of_sale,
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

                      MenuCard(
                        iconData: Icons.category,
                        iconSize: iconSize / 1.75,
                        title: 'Product Categories',
                        // subtitle: 'Manage product categories',
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        color: ColorStyle.tertiary,
                        width: menuSize,
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
                      MenuCard(
                        iconData: Icons.restaurant,
                        iconSize: iconSize / 1.75,
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
                      MenuCard(
                        iconData: Icons.inventory,
                        iconSize: iconSize / 1.75,
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
                              builder: (context) => const InventoryItemsPage(),
                            ),
                          );
                        },
                      ),
                  ],),
                ),



                SizedBox(
                  width: menuSize,
                  height: menuSize,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [

                      MenuCard(
                        iconSize: iconSize / 1.75,
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        width: (menuSize - 8)/2,
                        height: (menuSize - 8)/2,
                        iconData: Icons.people,
                        title: 'Customers',
                        color: const Color(0xFF2FC289),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomersPage(),
                            ),
                          );
                        },
                      ),
                      MenuCard(
                        iconSize: iconSize / 1.75,
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        width: (menuSize - 8)/2,
                        height: (menuSize - 8)/2,
                        title: 'Staffs',
                        iconData: Icons.group,
                        color: const Color(0xFFC2592F),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StaffsPage(),
                            ),
                          );
                        },
                      ),
                      MenuCard(
                        iconSize: iconSize / 1.75,
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        width: (menuSize),
                        height: (menuSize - 8)/2,
                        iconData: Icons.table_restaurant,
                        title: 'Dining Tables',
                        color: const Color(0xFFEF9050),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DiningTablesPage(),
                            ),
                          );
                        },
                      ),
                    ],),
                ),
                MenuCard(
                  iconData: Icons.history,
                  iconSize: iconSize,
                  title: 'History',
                  subtitle: 'All record and logs are here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  color: const Color(0xFFF5B942),
                  width: menuSize,
                  height: menuSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TransactionsPage(),
                      ),
                    );
                  },
                ),

                MenuCard(
                  iconData: Icons.photo_library,
                  iconSize: iconSize,
                  title: 'Library',
                  subtitle: 'Images and resources are here',
                  titleSize: titleSize ,
                  subtitleSize: subtitleSize,
                  width: menuSize,
                  height: menuSize,
                  color: const Color(0xFF2FC289),
                  onTap: _showLibrary,
                ),

                SizedBox(
                  width: menuSize,
                  height: menuSize,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [

                      MenuCard(
                        iconData: Icons.import_export,
                        iconSize: iconSize / 1.75,
                        title: 'Import Export',
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        width: (menuSize - 8)/2,
                        height: (menuSize - 8)/2,
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
                      MenuCard(
                        iconData: Icons.settings_backup_restore,
                        iconSize: iconSize / 1.75,
                        title: 'Backup Restore',
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        width: (menuSize - 8)/2,
                        height: (menuSize - 8)/2,
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



                      MenuCard(
                        iconData: Icons.settings,
                        iconSize: iconSize / 1.75,
                        title: 'Settings',
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        width: menuSize,
                        height: (menuSize - 8)/2,
                        color: const Color(0xFF222222),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingPage(),
                            ),
                          ).then((_) async {
                            setState(() {});
                          });
                        },
                      ), // Settings



                    ],),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLibrary() {
    showModalBottomSheet(context: this.context,
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
  }
}

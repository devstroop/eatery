import 'package:eatery/core/utils/responsive.dart';
import 'package:eatery/pages/dashboard/payment/payments.page.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/company_provider.dart';
import 'package:eatery/presentation/providers/cart_provider.dart';

import 'order/orders.page.dart';
import 'pos/cart.page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final company = ref.read(companyProvider);
    final cart = ref.read(cartProvider).cart;

    final double crossAxisItemCount = screenWidth >= 1200
        ? 5
        : screenWidth >= 800
        ? 4
        : screenWidth >= 600
        ? 3
        : 2;
    final spacing = Responsive.spacing(context);
    final iconSize =
        (screenWidth >= 1200
                ? 48
                : screenWidth >= 800
                ? 44
                : screenWidth >= 600
                ? 40
                : 36)
            .toDouble();
    final titleSize = Responsive.titleSize(context);
    final subtitleSize = Responsive.bodySize(context);

    final menuSize =
        (screenWidth - (spacing * (crossAxisItemCount + 1))) /
        crossAxisItemCount;
    if (company == null) {
      return const Center(child: CircularProgressIndicator());
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
              companyName: company.name,
              image: company.logo != null
                  ? LibraryImage(company.logo).image
                  : null,
              suffix: [
                // Cart with badge
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ),
                        ).then((value) => setState(() {}));
                      },
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: KColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cart.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.power_settings_new),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
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
                      },
                    );
                  },
                ),
              ],
            ),
            UpgradeNotification(company: company),
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
                  color: KColors.primary,
                  width: menuSize,
                  height: menuSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PointOfSalePage(),
                      ),
                    ).then((value) => setState(() {}));
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
                        color: KColors.tertiary,
                        width: menuSize,
                        height: (menuSize - 8) / 2,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ProductCategoriesPage(),
                            ),
                          ).then((value) => setState(() {}));
                        },
                      ),
                      MenuCard(
                        iconData: Icons.restaurant,
                        iconSize: iconSize / 1.75,
                        title: 'Kitchen',
                        // subtitle: 'Manage kitchen dishes',
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        color: KColors.secondary,
                        width: (menuSize - 8) / 2,
                        height: (menuSize - 8) / 2,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KitchenPage(),
                            ),
                          ).then((value) => setState(() {}));
                        },
                      ),
                      MenuCard(
                        iconData: Icons.inventory,
                        iconSize: iconSize / 1.75,
                        title: 'Inventory',
                        // subtitle: 'Manage product categories',
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        color: KColors.alternate,
                        width: (menuSize - 8) / 2,
                        height: (menuSize - 8) / 2,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InventoryItemsPage(),
                            ),
                          ).then((value) => setState(() {}));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: menuSize,
                  height: (menuSize - 8) / 2,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      MenuCard(
                        iconSize: iconSize / 1.75,
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        width: (menuSize - 8) / 2,
                        height: (menuSize - 8) / 2,
                        iconData: Icons.people,
                        title: 'Customers',
                        color: const Color(0xFF2FC289),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomersPage(),
                            ),
                          ).then((value) => setState(() {}));
                        },
                      ),
                      MenuCard(
                        iconSize: iconSize / 1.75,
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        width: (menuSize - 8) / 2,
                        height: (menuSize - 8) / 2,
                        title: 'Staffs',
                        iconData: Icons.group,
                        color: const Color(0xFFC2592F),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StaffsPage(),
                            ),
                          ).then((value) => setState(() {}));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: menuSize,
                  height: (menuSize - 8) / 2,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      MenuCard(
                        iconSize: iconSize / 1.75,
                        titleSize: titleSize * 0.7,
                        subtitleSize: subtitleSize * 0.7,
                        width: (menuSize),
                        height: (menuSize - 8) / 2,
                        iconData: Icons.table_restaurant,
                        title: 'Dining Tables',
                        color: KColors.tertiary3,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DiningTablesPage(),
                            ),
                          ).then((value) => setState(() {}));
                        },
                      ),
                    ],
                  ),
                ),
                MenuCard(
                  iconData: Icons.history,
                  iconSize: iconSize,
                  title: 'Orders',
                  subtitle: 'All orders are here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  color: KColors.tertiary2,
                  width: menuSize,
                  height: menuSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdersPage(),
                      ),
                    ).then((value) => setState(() {}));
                  },
                ),
                MenuCard(
                  iconData: Icons.payment,
                  iconSize: iconSize,
                  title: 'Payments',
                  subtitle: 'All payment receipts are here',
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  color: KColors.alternate2,
                  width: menuSize,
                  height: menuSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentsPage(),
                      ),
                    ).then((value) => setState(() {}));
                  },
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    MenuCard(
                      iconData: Icons.photo_library,
                      iconSize: iconSize / 1.75,
                      title: 'Library',
                      subtitle: 'Images and resources are here',
                      titleSize: titleSize * 0.7,
                      subtitleSize: subtitleSize * 0.7,
                      width: menuSize,
                      height: (menuSize - 8) / 2,
                      color: const Color(0xFF2FC289),
                      onTap: () => _showLibrary(context),
                    ),
                    MenuCard(
                      iconData: FontAwesomeIcons.database,
                      iconSize: iconSize / 1.75,
                      title: 'Data Mgmt.',
                      titleSize: titleSize * 0.7,
                      subtitleSize: subtitleSize * 0.7,
                      width: (menuSize - 8) / 2,
                      height: (menuSize - 8) / 2,
                      color: const Color(0xFFEF9050),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DataManagementPage(),
                          ),
                        ).then((value) => setState(() {}));
                      },
                    ),
                    MenuCard(
                      iconData: Icons.settings,
                      iconSize: iconSize / 1.75,
                      title: 'Settings',
                      titleSize: titleSize * 0.7,
                      subtitleSize: subtitleSize * 0.7,
                      width: (menuSize - 8) / 2,
                      height: (menuSize - 8) / 2,
                      color: const Color(0xFF222222),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingPage(),
                          ),
                        ).then((value) => setState(() {}));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLibrary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageLibraryPage(context, (value) {
          // Display in full screen view

          showDialog(
            context: context,
            builder: (context) {
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
            },
          ).then((value) => setState(() {}));
        }),
      ),
    );
  }
}

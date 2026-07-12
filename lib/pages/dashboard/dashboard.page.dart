import 'package:eatery/core/theme/app_spacing.dart';
import 'package:eatery/core/utils/responsive.dart';
import 'package:eatery/core/widgets/widgets.dart';
import 'package:eatery/pages/dashboard/payment/payments.page.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/company_provider.dart';
import 'package:eatery/presentation/providers/cart_provider.dart';

import 'order/orders.page.dart';
import 'pos/cart.page.dart';

// ── Dashboard navigation destinations ──────────────────────────
// These drive both the menu grid AND any future AppAdaptiveShell.
abstract final class DashboardRoutes {
  static const pos = 'pos';
  static const orders = 'orders';
  static const payments = 'payments';
  static const categories = 'categories';
  static const kitchen = 'kitchen';
  static const inventory = 'inventory';
  static const customers = 'customers';
  static const staffs = 'staffs';
  static const tables = 'tables';
  static const library = 'library';
  static const data = 'data';
  static const settings = 'settings';
}

/// Dashboard menu tiles grouped by category.
final _menuItems = <_MenuItem>[
  // ── Sales ──
  _MenuItem(
    icon: Icons.point_of_sale,
    label: 'Point of Sale',
    subtitle: 'Start a new sale',
    color: Color(0xFF30A8CF),
    route: DashboardRoutes.pos,
  ),
  _MenuItem(
    icon: Icons.history,
    label: 'Orders',
    subtitle: 'All orders here',
    color: Color(0xFFF5A142),
    route: DashboardRoutes.orders,
  ),
  _MenuItem(
    icon: Icons.payment,
    label: 'Payments',
    subtitle: 'Payment receipts',
    color: Color(0xFF2F5EC2),
    route: DashboardRoutes.payments,
  ),
  // ── Management ──
  _MenuItem(
    icon: Icons.category,
    label: 'Categories',
    subtitle: 'Product categories',
    color: Color(0xFFD98049),
    route: DashboardRoutes.categories,
  ),
  _MenuItem(
    icon: Icons.restaurant,
    label: 'Kitchen',
    subtitle: 'Kitchen dishes',
    color: Color(0xFF4AC3A1),
    route: DashboardRoutes.kitchen,
  ),
  _MenuItem(
    icon: Icons.inventory,
    label: 'Inventory',
    subtitle: 'Stock items',
    color: Color(0xFF705EE0),
    route: DashboardRoutes.inventory,
  ),
  _MenuItem(
    icon: Icons.people,
    label: 'Customers',
    subtitle: 'Manage customers',
    color: Color(0xFF2FC289),
    route: DashboardRoutes.customers,
  ),
  _MenuItem(
    icon: Icons.group,
    label: 'Staffs',
    subtitle: 'Manage staff',
    color: Color(0xFFC2592F),
    route: DashboardRoutes.staffs,
  ),
  _MenuItem(
    icon: Icons.table_restaurant,
    label: 'Dining Tables',
    subtitle: 'Manage tables',
    color: Color(0xFFEF6850),
    route: DashboardRoutes.tables,
  ),
  // ── Utilities ──
  _MenuItem(
    icon: Icons.photo_library,
    label: 'Library',
    subtitle: 'Images & resources',
    color: Color(0xFF2FC289),
    route: DashboardRoutes.library,
  ),
  _MenuItem(
    icon: FontAwesomeIcons.database,
    label: 'Data Mgmt.',
    subtitle: 'Import / Export',
    color: Color(0xFFEF9050),
    route: DashboardRoutes.data,
  ),
  _MenuItem(
    icon: Icons.settings,
    label: 'Settings',
    subtitle: 'App settings',
    color: Color(0xFF222222),
    route: DashboardRoutes.settings,
  ),
];

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final company = ref.read(companyProvider);
    final cart = ref.read(cartProvider).cart;
    final isDesktop = Responsive.isDesktop(context);
    final spacing = Responsive.spacing(context);

    if (company == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        key: scaffoldKey,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth - spacing * 2;
            final cardWidth =
                (isDesktop
                        ? (availableWidth - spacing * 3) / 4
                        : (availableWidth - spacing) / 2)
                    .clamp(140, 220)
                    .toDouble();
            final cardHeight = cardWidth * 1.1;

            return ListView(
              padding: EdgeInsets.symmetric(horizontal: spacing, vertical: 32),
              children: [
                _DashboardHeader(
                  companyName: company.name,
                  image: company.logo != null
                      ? LibraryImage(company.logo).image
                      : null,
                  cartCount: cart.length,
                  onCartTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  ).then((_) => setState(() {})),
                  onLogout: () => _showLogoutDialog(context),
                ),
                AppSpacing.gapLg,
                // ── Menu Grid ──
                Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: _menuItems
                      .map(
                        (item) => _DashboardTile(
                          item: item,
                          width: cardWidth,
                          height: cardHeight,
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onTap(BuildContext context, String route) {
    switch (route) {
      case 'pos':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PointOfSalePage()),
        );
        break;
      case 'orders':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrdersPage()),
        );
        break;
      case 'payments':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentsPage()),
        );
        break;
      case 'categories':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductCategoriesPage()),
        );
        break;
      case 'kitchen':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KitchenPage()),
        );
        break;
      case 'inventory':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InventoryItemsPage()),
        );
        break;
      case 'customers':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CustomersPage()),
        );
        break;
      case 'staffs':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StaffsPage()),
        );
        break;
      case 'tables':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DiningTablesPage()),
        );
        break;
      case 'library':
        _showLibrary(context);
        break;
      case 'data':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DataManagementPage()),
        );
        break;
      case 'settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingPage()),
        );
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    AppDialog.show(
      context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      confirmLabel: 'Yes',
      cancelLabel: 'No',
      onConfirm: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LogoutPage()),
        );
      },
    );
  }

  void _showLibrary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageLibraryPage(context, (value) {
          showDialog(
            context: context,
            builder: (ctx) {
              final image = Image(image: (value ?? LibraryImage('')).image);
              return Dialog(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: image.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              );
            },
          ).then((_) => setState(() {}));
        }),
      ),
    );
  }
}

// ── Data class ──────────────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final String route;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.route,
  });
}

// ── Header widget ───────────────────────────────────────────────
class _DashboardHeader extends StatelessWidget {
  final String companyName;
  final ImageProvider? image;
  final int cartCount;
  final VoidCallback onCartTap;
  final VoidCallback onLogout;

  const _DashboardHeader({
    required this.companyName,
    this.image,
    required this.cartCount,
    required this.onCartTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return Row(
      children: [
        if (image != null) ...[
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(fit: BoxFit.cover, image: image!),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                companyName,
                style: TextStyle(
                  color: const Color(0xFF8B97A2),
                  fontSize: isDesktop ? 16 : 14,
                ),
              ),
              Text(
                'Dashboard',
                style: TextStyle(
                  color: const Color(0xFF090F13),
                  fontSize: isDesktop ? 28 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Cart badge
        if (cartCount > 0)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: onCartTap,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartCount.toString(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        IconButton(
          icon: const Icon(Icons.power_settings_new),
          onPressed: onLogout,
        ),
      ],
    );
  }
}

// ── Menu tile widget ────────────────────────────────────────────
class _DashboardTile extends StatelessWidget {
  final _MenuItem item;
  final double width;
  final double height;

  const _DashboardTile({
    required this.item,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: () {
          // Find the parent DashboardPage state and call _onTap
          final page = context.findAncestorStateOfType<_DashboardPageState>();
          page?._onTap(context, item.route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x37000000),
                offset: Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: AppColors.white, size: 32),
              const Spacer(),
              Text(
                item.label,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: Responsive.bodySize(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.7),
                  fontSize: Responsive.bodySize(context) - 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/utils/responsive.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery_core/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';
import 'components/dashboard_charts.dart';

// ── Dashboard navigation destinations ──────────────────────────
abstract final class DashboardRoutes {
  static const pos = 'pos';
  static const orders = 'orders';
  static const payments = 'payments';
  static const categories = 'categories';
  static const kitchen = 'kitchen';
  static const inventory = 'inventory';
  static const customers = 'customers';
  static const employees = 'employees';
  static const tables = 'tables';
  static const library = 'library';
  static const data = 'data';
  static const settings = 'settings';
  static const reports = 'reports';
  static const reservations = 'reservations';
}

/// Dashboard menu tiles grouped by category.
final _salesItems = <_MenuItem>[
  _MenuItem(
    icon: Icons.point_of_sale,
    label: 'Point of Sale',
    subtitle: 'Start a new sale',
    color: const Color(0xFF30A8CF),
    route: DashboardRoutes.pos,
  ),
  _MenuItem(
    icon: Icons.history,
    label: 'Orders',
    subtitle: 'All orders here',
    color: const Color(0xFFF5A142),
    route: DashboardRoutes.orders,
  ),
  _MenuItem(
    icon: Icons.payment,
    label: 'Payments',
    subtitle: 'Payment receipts',
    color: const Color(0xFF2F5EC2),
    route: DashboardRoutes.payments,
  ),
  _MenuItem(
    icon: Icons.assessment,
    label: 'Reports',
    subtitle: 'Sales reports',
    color: const Color(0xFF43A047),
    route: DashboardRoutes.reports,
  ),
  _MenuItem(
    icon: Icons.event,
    label: 'Reservations',
    subtitle: 'Table bookings',
    color: const Color(0xFF9C27B0),
    route: DashboardRoutes.reservations,
  ),
];

final _productItems = <_MenuItem>[
  _MenuItem(
    icon: Icons.category,
    label: 'Categories',
    subtitle: 'Product categories',
    color: const Color(0xFFD98049),
    route: DashboardRoutes.categories,
  ),
  _MenuItem(
    icon: Icons.restaurant_menu,
    label: 'Kitchen',
    subtitle: 'Kitchen dishes',
    color: const Color(0xFF873CA8),
    route: DashboardRoutes.kitchen,
  ),
  _MenuItem(
    icon: Icons.inventory_2,
    label: 'Inventory',
    subtitle: 'Inventory items',
    color: const Color(0xFFC45C27),
    route: DashboardRoutes.inventory,
  ),
];

final _peopleItems = <_MenuItem>[
  _MenuItem(
    icon: Icons.people,
    label: 'Customers',
    subtitle: 'Manage customers',
    color: const Color(0xFF27AE60),
    route: DashboardRoutes.customers,
  ),
  _MenuItem(
    icon: Icons.badge,
    label: 'Employees',
    subtitle: 'Manage employees',
    color: const Color(0xFF2980B9),
    route: DashboardRoutes.employees,
  ),
  _MenuItem(
    icon: Icons.table_restaurant,
    label: 'Tables',
    subtitle: 'Dining tables',
    color: const Color(0xFF8E44AD),
    route: DashboardRoutes.tables,
  ),
];

final _systemItems = <_MenuItem>[
  _MenuItem(
    icon: Icons.image,
    label: 'Library',
    subtitle: 'Image library',
    color: const Color(0xFF16A085),
    route: DashboardRoutes.library,
  ),
  _MenuItem(
    icon: Icons.storage,
    label: 'Data',
    subtitle: 'Backup & restore',
    color: const Color(0xFFE74C3C),
    route: DashboardRoutes.data,
  ),
  _MenuItem(
    icon: Icons.settings,
    label: 'Settings',
    subtitle: 'App settings',
    color: const Color(0xFF7F8C8D),
    route: DashboardRoutes.settings,
  ),
];

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late int _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = 0;
  }

  @override
  Widget build(BuildContext context) {
    final company = ref.read(companyProvider);
    final cart = ref.read(cartProvider).cart;

    if (company == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return PopScope(
      canPop: false,
      child: AppAdaptiveShell(
        initialIndex: _currentTab,
        title: company.name,
        header: (context) => _DashboardHeader(
          companyName: company.name,
          image: company.logo != null
              ? LibraryImage(company.logo!).image
              : null,
          cartCount: cart.length,
          onCartTap: () => GoRouter.of(
            context,
          ).pushNamed('adminCart').then((_) => setState(() {})),
          onLogout: () => _showLogoutDialog(context),
        ),
        destinations: [
          AppNavDestination(
            icon: Icons.dashboard,
            label: 'Sales',
            page: ListView(
              padding: EdgeInsets.only(bottom: 32),
              children: [
                const DashboardCharts(),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Quick Actions',
                    style: AppTypography.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                _DashboardGrid(
                  items: _salesItems,
                  onItemTap: (route) => _onTap(context, route),
                ),
              ],
            ),
          ),
          AppNavDestination(
            icon: Icons.restaurant_menu,
            label: 'Products',
            page: _DashboardGrid(
              items: _productItems,
              onItemTap: (route) => _onTap(context, route),
            ),
          ),
          AppNavDestination(
            icon: Icons.people,
            label: 'People',
            page: _DashboardGrid(
              items: _peopleItems,
              onItemTap: (route) => _onTap(context, route),
            ),
          ),
          AppNavDestination(
            icon: Icons.settings,
            label: 'System',
            page: _DashboardGrid(
              items: _systemItems,
              onItemTap: (route) => _onTap(context, route),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, String route) {
    switch (route) {
      case 'pos':
        GoRouter.of(context).pushNamed('pos');
        break;
      case 'orders':
        GoRouter.of(context).pushNamed('orders');
        break;
      case 'payments':
        GoRouter.of(context).pushNamed('payments');
        break;
      case 'categories':
        GoRouter.of(context).pushNamed('productCategories');
        break;
      case 'kitchen':
        GoRouter.of(context).pushNamed('kitchenDishes');
        break;
      case 'inventory':
        GoRouter.of(context).pushNamed('inventoryItems');
        break;
      case 'customers':
        GoRouter.of(context).pushNamed('customers');
        break;
      case 'employees':
        GoRouter.of(context).pushNamed('employees');
        break;
      case 'tables':
        GoRouter.of(context).pushNamed('diningTables');
        break;
      case 'library':
        _showLibrary(context);
        break;
      case 'data':
        GoRouter.of(context).pushNamed('dataManagement');
        break;
      case 'settings':
        GoRouter.of(context).pushNamed('settings');
        break;
      case 'reports':
        GoRouter.of(context).pushNamed('reports');
        break;
      case 'reservations':
        GoRouter.of(context).pushNamed('reservations');
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
        GoRouter.of(context).goNamed('logout');
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

// ── Dashboard grid section ─────────────────────────────────────
class _DashboardGrid extends StatelessWidget {
  final List<_MenuItem> items;
  final void Function(String route) onItemTap;

  const _DashboardGrid({required this.items, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final spacing = Responsive.spacing(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - spacing * 2;
        final cols = isDesktop ? (items.length).clamp(1, 4) : 2;
        final cardWidth = ((availableWidth - (cols - 1) * spacing) / cols)
            .clamp(120, 220)
            .toDouble();

        return Padding(
          padding: EdgeInsets.all(spacing),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: items
                .map(
                  (item) => _DashboardTile(
                    item: item,
                    width: cardWidth,
                    height: cardWidth * 1.1,
                    onTap: () => onItemTap(item.route),
                  ),
                )
                .toList(),
          ),
        );
      },
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
          AppSpacing.gapMd,
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
  final VoidCallback onTap;

  const _DashboardTile({
    required this.item,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: onTap,
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

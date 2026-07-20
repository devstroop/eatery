import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery/dev/seed_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});
  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  Color getThemeColor() {
    return AppColors.black;
  }

  SizedBox options(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          AppMenuTile(
            leading: Icons.business,
            title: 'Company',
            subtitle: 'Manage Company Profile',
            trailing: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () {
              GoRouter.of(
                context,
              ).pushNamed('companySettings').then((_) => setState(() {}));
            },
          ),
          AppMenuTile(
            leading: Icons.attach_money,
            title: 'Currency and Region',
            subtitle: 'Manage Currency and Region Settings',
            trailing: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () => GoRouter.of(context).pushNamed('currencyRegion'),
          ),
          AppMenuTile(
            leading: Icons.percent,
            title: 'Tax',
            subtitle: 'Manage Tax Slabs',
            trailing: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () => GoRouter.of(context).pushNamed('taxSlabs'),
          ),
          AppMenuTile(
            leading: Icons.tune,
            title: 'Modifiers',
            subtitle: 'Product customization options',
            trailing: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () => GoRouter.of(
              context,
            ).pushNamed('modifierGroups').then((_) => setState(() {})),
          ),
          AppMenuTile(
            leading: Icons.business,
            title: 'Suppliers',
            subtitle: 'Manage vendors',
            trailing: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () => GoRouter.of(
              context,
            ).pushNamed('suppliers').then((_) => setState(() {})),
          ),
          AppMenuTile(
            leading: Icons.receipt_long,
            title: 'Purchase Orders',
            subtitle: 'Inventory procurement',
            trailing: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () => GoRouter.of(
              context,
            ).pushNamed('purchaseOrders').then((_) => setState(() {})),
          ),
          AppMenuTile(
            leading: Icons.local_offer,
            title: 'Discounts',
            subtitle: 'Promotions & discount rules',
            trailing: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () => GoRouter.of(
              context,
            ).pushNamed('discounts').then((_) => setState(() {})),
          ),
          AppMenuTile(
            leading: Icons.print,
            title: 'Printer',
            subtitle: 'Manage Printing Devices',
            trailing: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () => GoRouter.of(
              context,
            ).pushNamed('printerSettings').then((_) => setState(() {})),
          ),
          // Developer section — visible only in debug mode
          if (const bool.fromEnvironment('dart.vm.product') == false) ...[
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text(
                'Developer',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey500,
                ),
              ),
            ),
            AppMenuTile(
              leading: Icons.storage,
              title: 'Load Sample Data',
              subtitle: 'Populate DB with demo data',
              trailing: Icons.download,
              color: Colors.orange,
              onTap: () async {
                await SeedData.load(ref.read(eateryStoreProvider));
                if (this.context.mounted) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('Demo data loaded')),
                  );
                }
              },
            ),
            AppMenuTile(
              leading: Icons.bug_report,
              title: 'Database Inspector',
              subtitle: 'View and manage DB contents',
              trailing: Icons.chevron_right,
              color: Colors.orange,
              onTap: () => GoRouter.of(context).pushNamed('databaseInspector'),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Settings',
      color: getThemeColor(),
      child: Stack(
        children: [
          Positioned(
            top: 12.0,
            left: 0.0,
            right: 0.0,
            bottom: 72,
            child: options(context),
          ),
        ],
      ),
    );
  }
}

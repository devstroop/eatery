import 'package:eatery/dev/database_inspector.dart';
import 'package:eatery/dev/seed_loader.dart';
import 'package:eatery/pages/dashboard/settings/printer/printer.setting.page.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
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

  SizedBox options() {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          MenuTile(
            prefixIcon: Icons.business,
            title: 'Company',
            subtitle: 'Manage Company Profile',
            postfixIcon: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () {
              Navigator.push(
                this.context,
                MaterialPageRoute(
                  builder: (context) => const ShowCompanyPage(),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          MenuTile(
            prefixIcon: Icons.attach_money,
            title: 'Currency and Region',
            subtitle: 'Manage Currency and Region Settings',
            postfixIcon: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () => Navigator.push(
              this.context,
              MaterialPageRoute(
                builder: (context) => const ShowCurrencyRegionPage(),
              ),
            ),
          ),
          MenuTile(
            prefixIcon: Icons.percent,
            title: 'Tax',
            subtitle: 'Manage Tax Slabs',
            postfixIcon: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () => Navigator.push(
              this.context,
              MaterialPageRoute(
                builder: (context) => const TaxSlabsSettingsPage(),
              ),
            ),
          ),
          MenuTile(
            prefixIcon: Icons.print,
            title: 'Printer',
            subtitle: 'Manage Printing Devices',
            postfixIcon: Icons.chevron_right,
            color: getThemeColor(),
            onTap: () => Navigator.push(
              this.context,
              MaterialPageRoute(
                builder: (context) => const PrinterSettingsPage(),
              ),
            ).then((_) => setState(() {})),
          ),
          // Developer section — visible only in debug mode
          if (const bool.fromEnvironment('dart.vm.product') == false) ...[
            const Divider(height: 32),
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 4),
              child: Text(
                'Developer',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
            MenuTile(
              prefixIcon: Icons.storage,
              title: 'Load Sample Data',
              subtitle: 'Populate DB with demo data',
              postfixIcon: Icons.download,
              color: Colors.orange,
              onTap: () async {
                await loadSeedData(ref);
                if (this.context.mounted) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('Sample data loaded')),
                  );
                }
              },
            ),
            MenuTile(
              prefixIcon: Icons.bug_report,
              title: 'Database Inspector',
              subtitle: 'View and manage DB contents',
              postfixIcon: Icons.chevron_right,
              color: Colors.orange,
              onTap: () => Navigator.push(
                this.context,
                MaterialPageRoute(
                  builder: (context) => const DatabaseInspector(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Settings'),
      foregroundColor: Colors.white,
    );
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
            top: 12.0,
            left: 0.0,
            right: 0.0,
            bottom: 72,
            child: options(),
          ),
        ],
      ),
    );
  }
}

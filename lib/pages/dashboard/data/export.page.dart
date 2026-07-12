import 'package:eatery/core/widgets/app_page_shell.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
final _pageColor = AppColors.menuCategories;
class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  String selectedExportOption = 'Excel';
  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Export',
      color: _pageColor,
      child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.check_box_outline_blank_outlined),
              title: const Text('Products'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.check_box_outline_blank_outlined),
              title: const Text('Product Categories'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.check_box_outline_blank_outlined),
              title: const Text('Tax Slabs'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.check_box_outline_blank_outlined),
              title: const Text('Staffs'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.check_box_outline_blank_outlined),
              title: const Text('Dining Tables'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.check_box_outline_blank_outlined),
              title: const Text('Dining Table Categories'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.check_box_outline_blank_outlined),
              title: const Text('Customers'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.check_box_outline_blank_outlined),
              title: const Text('Orders'),
              onTap: () {},
            ),
          ],
        ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton(
                value: selectedExportOption,
                items: const [
                  DropdownMenuItem(
                    value: 'Excel',
                    child: Text('Excel'),
                  ),
                  DropdownMenuItem(
                    value: 'Json',
                    child: Text('Json'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedExportOption = value ?? 'Excel';
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _pageColor,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Export')),
            ],
          ),
      ),
    );
  }
}

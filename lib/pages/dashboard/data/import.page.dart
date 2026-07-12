import 'package:eatery/core/widgets/app_page_shell.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:http/http.dart' as http;

final _pageColor = AppColors.menuCategories;

class ImportPage extends StatelessWidget {
  const ImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Import',
      color: _pageColor,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /*Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () => _downloadDemoData(context),
                  title: Text(
                    'Download Demo Data',
                    style: TextStyle(
                        color: AppColors.green, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Get started with demo data',
                    style: TextStyle(color: AppColors.grey700),
                  ),
                  trailing: Icon(
                    Icons.file_download_outlined,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ),*/
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Import from Excel',
                    style: TextStyle(
                        color: AppColors.menuPayments, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Select the excel file to import',
                    style: TextStyle(color: AppColors.grey700),
                  ),
                  trailing: Icon(
                    Icons.attachment,
                    color: AppColors.menuPayments,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Import from JSON',
                    style: TextStyle(
                        color: AppColors.yellow, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Select the json file to import',
                    style: TextStyle(color: AppColors.grey700),
                  ),
                  trailing: Icon(
                    Icons.code,
                    color: AppColors.yellow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

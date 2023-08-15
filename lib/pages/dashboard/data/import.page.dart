import 'package:eatery/references.dart';
import 'package:http/http.dart' as http;

final _pageColor = KColors.tertiary;

class ImportPage extends StatelessWidget {
  const ImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Import'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /*Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                        color: KColors.green, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Get started with demo data',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: Icon(
                    Icons.file_download_outlined,
                    color: KColors.green,
                  ),
                ),
              ],
            ),
          ),*/
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                        color: KColors.alternate2, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Select the excel file to import',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: Icon(
                    Icons.attachment,
                    color: KColors.alternate2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                        color: KColors.yellow, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Select the json file to import',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: Icon(
                    Icons.code,
                    color: KColors.yellow,
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

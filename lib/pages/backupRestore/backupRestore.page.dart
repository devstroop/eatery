import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.tertiary;
class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({Key? key, this.company}) : super(key: key);
  final Company? company;
  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  final drive = GoogleDrive();
  bool inProgress = false;

  Future<void> doBackup() async {
    ProgressDialog pd = ProgressDialog(context: context);
    setState(() {
      inProgress = true;
    });
    pd.show(
      max: 100,
      msg: 'Backup in progress',
      progressBgColor: Colors.transparent,
      progressValueColor: _pageColor,
      completed: Completed(),
    );
    setState(() {
      inProgress = false;
    });
  }

  void doRestore() async {
    ProgressDialog pd = ProgressDialog(context: context);
    setState(() {
      inProgress = true;
    });
    pd.show(
      max: 100,
      msg: 'Restore in progress',
      progressBgColor: Colors.transparent,
      progressValueColor: _pageColor,
      completed: Completed(),
    );
    setState(() {
      inProgress = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: Colors.white,
      title: const Text('Backup / Restore'),
    );

    return Scaffold(
      appBar: appBar,
      body: ListView(
          children: [
            ListTile(
              onTap: doBackup,
              leading: const Icon(Icons.backup),
              title: const Text('Backup'),
              subtitle: const Text('Backup data to Google Drive'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: doRestore,
              leading: const Icon(Icons.restore),
              title: const Text('Restore'),
              subtitle: const Text('Restore data from Google Drive'),
              trailing: const Icon(Icons.chevron_right),
            ),
        
      ]),
    );
  }
}

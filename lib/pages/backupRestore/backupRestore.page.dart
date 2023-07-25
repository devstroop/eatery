import 'package:eatery/references.dart';
import 'package:archive/archive_io.dart';

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

  Future<void> doBackup(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      max: 100,
      msg: 'Backup in progress',
      progressBgColor: Colors.transparent,
      progressValueColor: _pageColor,
      completed: Completed(),
    );
    setState(() {
      inProgress = true;
    });

    // GlobalVariables.dataDirectory
    // GlobalVariables.imagesDirectory

    // copy data directory and images directory to temp directory and zip it to a file
    String tempBackupDirectory = join(GlobalVariables.tempDirectory!,
        '${DateTime.now().millisecondsSinceEpoch}');
    Directory(tempBackupDirectory).createSync(recursive: true);
    Directory(GlobalVariables.dataDirectory!).listSync().forEach((element) {
      if (element is File) {
        element.copySync(join(tempBackupDirectory, 'data', element.path.split('/').last));
      }
    });
    Directory(GlobalVariables.imagesDirectory!).listSync().forEach((element) {
      if (element is File) {
        element.copySync(join(tempBackupDirectory, 'images', element.path.split('/').last));
      }
    });
    // zip
    String zipFilePath = join(GlobalVariables.tempDirectory!,
        '${DateTime.now().millisecondsSinceEpoch}.zip');
    var encoder = ZipFileEncoder();
    encoder.create(zipFilePath);
    encoder.addDirectory(Directory(tempBackupDirectory));
    encoder.close();

    // move zip file to backup directory
    File(zipFilePath).copySync(join(GlobalVariables.backupDirectory!,
        '${DateTime.now().millisecondsSinceEpoch}.zip'));

    // delete temp directory
    Directory(tempBackupDirectory).deleteSync(recursive: true);

    // upload to google drive
    await drive.upload(File(zipFilePath));

    // delete zip file
    File(zipFilePath).deleteSync(recursive: true);

    // upload to google drive

    pd.close();
    setState(() {
      inProgress = false;
    });
  }

  void doRestore(BuildContext context) async {
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
      body: ListView(children: [
        ListTile(
          onTap: () => doBackup(context),
          leading: const Icon(Icons.backup),
          title: const Text('Backup'),
          subtitle: const Text('Backup data to Google Drive'),
          trailing: const Icon(Icons.chevron_right),
        ),
        ListTile(
          onTap: () => doRestore(context),
          leading: const Icon(Icons.restore),
          title: const Text('Restore'),
          subtitle: const Text('Restore data from Google Drive'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ]),
    );
  }
}

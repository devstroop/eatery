import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:eatery/presentation/providers/database_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Color _pageColor = AppColors.menuCategories;

class BackupRestorePage extends ConsumerStatefulWidget {
  const BackupRestorePage({Key? key, this.company}) : super(key: key);
  final Company? company;

  @override
  ConsumerState<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends ConsumerState<BackupRestorePage> {
  final drive = GoogleDrive();
  bool inProgress = false;

  /// Returns a safe temp directory path.
  Future<String> _tempDir() async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  /// Returns the backup directory (under app support dir).
  Future<String> _backupDir() async {
    final appDir = await getApplicationSupportDirectory();
    final dir = Directory(p.join(appDir.path, 'backups'));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir.path;
  }

  /// Returns the Hive data directory.
  String _dataDir() => ref.read(appDatabaseProvider).dataDir;

  Future<void> doBackup(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      max: 100,
      msg: 'Backup in progress',
      progressBgColor: Colors.transparent,
      progressValueColor: _pageColor,
      completed: Completed(),
    );
    setState(() => inProgress = true);

    try {
      final tempDir = await _tempDir();
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Copy data dir to temp
      final tempBackupDir = p.join(tempDir, timestamp);
      final dataDest = Directory(p.join(tempBackupDir, 'data'));
      dataDest.createSync(recursive: true);

      final dataDir = Directory(_dataDir());
      if (dataDir.existsSync()) {
        for (final entry in dataDir.listSync()) {
          if (entry is File) {
            entry.copySync(p.join(dataDest.path, p.basename(entry.path)));
          }
        }
      }

      // Zip
      final zipPath = p.join(tempDir, '$timestamp.zip');
      final encoder = ZipFileEncoder();
      encoder.create(zipPath);
      encoder.addDirectory(Directory(tempBackupDir));
      encoder.close();

      // Copy to persistent backup dir
      final backupDir = await _backupDir();
      final backupPath = p.join(backupDir, '$timestamp.zip');
      await File(zipPath).copy(backupPath);

      // Clean temp
      Directory(tempBackupDir).deleteSync(recursive: true);

      // Upload to Google Drive (best-effort — don't block on failure)
      try {
        await drive.upload(File(zipPath));
      } catch (e) {
        debugPrint('Google Drive upload failed (backup saved locally): $e');
      }

      // Only delete zip if it was successfully uploaded (or if Drive is unavailable)
      if (File(zipPath).existsSync()) {
        File(zipPath).deleteSync();
      }

      if (context.mounted) {
        showMessageDialog(context, 'Backup completed', MessageType.success);
      }
    } catch (e) {
      if (context.mounted) {
        showMessageDialog(context, 'Backup failed: $e', MessageType.error);
      }
    } finally {
      pd.close();
      setState(() => inProgress = false);
    }
  }

  /// Restores data by copying saved .hive files from the backup into the
  /// active Hive directory. User must restart the app afterward.
  Future<void> doRestore(BuildContext context) async {
    setState(() => inProgress = true);

    try {
      // 1. Pick a ZIP file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );
      if (result == null || result.files.single.path == null) {
        setState(() => inProgress = false);
        return;
      }

      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(
        max: 100,
        msg: 'Restore in progress',
        progressBgColor: Colors.transparent,
        progressValueColor: _pageColor,
        completed: Completed(),
      );

      // 2. Extract ZIP to temp
      final tempDir = await _tempDir();
      final extractDir = p.join(
        tempDir,
        'restore_${DateTime.now().millisecondsSinceEpoch}',
      );
      Directory(extractDir).createSync(recursive: true);

      final inputStream = InputFileStream(result.files.single.path!);
      final archive = ZipDecoder().decodeBuffer(inputStream);

      for (final entry in archive) {
        final filePath = p.join(extractDir, entry.name);
        if (entry.isFile) {
          final out = OutputFileStream(filePath);
          entry.writeContent(out);
          out.close();
        } else {
          Directory(filePath).createSync(recursive: true);
        }
      }
      inputStream.close();

      // 3. Verify backup has data directory
      final backupDataDir = Directory(p.join(extractDir, 'data'));
      if (!backupDataDir.existsSync()) {
        throw Exception('No "data" folder found in backup archive');
      }

      // 4. Copy .hive files to the live Hive data directory, overwriting
      final db = ref.read(appDatabaseProvider);
      final hiveDir = Directory(_dataDir());
      int copied = 0;
      for (final entry in backupDataDir.listSync()) {
        if (entry is File && entry.path.endsWith('.hive')) {
          final dest = p.join(hiveDir.path, p.basename(entry.path));
          await entry.copy(dest);
          copied++;
        }
      }

      if (copied == 0) {
        throw Exception('No Hive data files found in backup');
      }

      // 5. Clean up temp
      Directory(extractDir).deleteSync(recursive: true);

      pd.close();

      if (context.mounted) {
        showMessageDialog(
          context,
          'Restore completed. Restart app to apply changes.',
          MessageType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showMessageDialog(context, 'Restore failed: $e', MessageType.error);
      }
    } finally {
      setState(() => inProgress = false);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: AppColors.white,
      title: const Text('Backup / Restore'),
    );

    return Scaffold(
      backgroundColor: AppColors.grey200,
      appBar: appBar,
      body: ListView(
        children: [
          ListTile(
            onTap: () => doBackup(context),
            leading: const Icon(Icons.backup),
            title: const Text('Backup'),
            subtitle: const Text('Backup data to local storage + Google Drive'),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () => doRestore(context),
            leading: const Icon(Icons.restore),
            title: const Text('Restore'),
            subtitle: const Text('Restore data from a backup ZIP file'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

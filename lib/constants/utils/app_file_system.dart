import 'package:archive/archive.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

/// Canonical source for app data directory paths.
///
/// Replaces the old path fields in [Common]. All app directories are
/// created on first access under [baseDir].
class AppFileSystem {
  /// Root data directory — set once during app startup.
  static String _base = '';

  /// Initialize with the platform-specific app data root.
  /// Call this once from main.dart.
  static Future<void> init(String base) async {
    _base = base;
    for (final dir in [
      dataDir,
      imagesDir,
      backupDir,
      exportDir,
      tempDir,
      cacheDir,
      shareDir,
    ]) {
      final d = Directory(dir);
      if (!d.existsSync()) await d.create(recursive: true);
    }
  }

  /// Root directory (platform-specific app documents/support dir).
  static String get baseDir => _base;

  /// Hive database storage.
  static String get dataDir => '$_base/data';

  /// Uploaded / imported images.
  static String get imagesDir => '$_base/images';

  /// Backup ZIP files.
  static String get backupDir => '$_base/backups';

  /// Exported Excel/JSON files.
  static String get exportDir => '$_base/exports';

  /// Temporary working directory (cleared on restart).
  static String get tempDir => '$_base/temp';

  /// Image cache.
  static String get cacheDir => '$_base/cache';

  /// Shared files for system share sheet.
  static String get shareDir => '$_base/share';

  static String? pickedImage;

  static Widget buildUploadOptionsBottomSheet() => StatefulBuilder(
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Center(child: BottomViewGrip()),
            const Row(
              children: [
                SizedBox(width: 12),
                Text(
                  'Upload',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  icon: const Icon(Icons.upload),
                  iconSize: 48.0,
                  color: AppColors.black500,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  iconSize: 48.0,
                  color: AppColors.black500,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.link),
                  iconSize: 48.0,
                  color: AppColors.black500,
                  onPressed: () {},
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  icon: const Icon(Icons.hub),
                  iconSize: 48.0,
                  color: AppColors.black500,
                  onPressed: () {},
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8.0),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child: SecondaryButton(
                        color: AppColors.black500,
                        borderColor: AppColors.white600,
                        text: 'Camera',
                        height: 50.0,
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? photo = await picker.pickImage(
                            source: ImageSource.camera,
                          );

                          if (photo != null) {
                            if (!(Directory(
                              '${(await Directory(AppFileSystem.baseDir)).path}/images',
                            )).existsSync()) {
                              await Directory(
                                '${(await Directory(AppFileSystem.baseDir)).path}/images',
                              ).create(recursive: true);
                            }
                            String path =
                                '${'${(await Directory(AppFileSystem.baseDir)).path}/images'}/${getRandomString(32)}.${photo.name.split('.').last}';
                            photo.saveTo(path);
                            pickedImage = path;
                            Navigator.pop(context);
                            return;
                          }
                          pickedImage = null;
                          Navigator.pop(context);
                          return;
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    AppButton.primary(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? photo = await picker.pickImage(
                          source: ImageSource.gallery,
                        );

                        if (photo != null) {
                          if (!(Directory(
                            '${(await Directory(AppFileSystem.baseDir)).path}/images',
                          )).existsSync()) {
                            await Directory(
                              '${(await Directory(AppFileSystem.baseDir)).path}/images',
                            ).create(recursive: true);
                          }
                          String path =
                              '${'${(await Directory(AppFileSystem.baseDir)).path}/images'}/${getRandomString(32)}.${photo.name.split('.').last}';
                          photo.saveTo(path);
                          pickedImage = path;
                          Navigator.pop(context);
                          return;
                        }
                        pickedImage = null;
                        Navigator.pop(context);
                        return;
                      },
                      label: 'Gallery',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    },
  );

  static Future<String?> pickImage(BuildContext context) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      context: context,
      builder: (context) => buildUploadOptionsBottomSheet(),
    );
    return pickedImage;
  }

  static Future<void> doZip({
    required String dataDirPath,
    required String zipFilePath,
  }) async {
    final dataDir = Directory(dataDirPath);
    try {
      final archive = Archive();
      for (final file in dataDir.listSync(recursive: true)) {
        if (file is File) {
          archive.addFile(
            ArchiveFile(file.path, file.lengthSync(), file.readAsBytesSync()),
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> doUnZip({
    required String dataDirPath,
    required String zipFilePath,
  }) async {
    final zipFile = File(zipFilePath);
    final destinationDir = Directory(dataDirPath);
    try {
      // ZipFile.extractToDirectory(
      //     zipFile: zipFile, destinationDir: destinationDir);
      // Instead of flutter_archive, use archive package

      final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          final f = File('${destinationDir.path}/$filename');
          f.createSync(recursive: true);
          f.writeAsBytesSync(data);
        } else {
          final dir = Directory('${destinationDir.path}/$filename');
          dir.createSync(recursive: true);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> saveBackupFile({
    required Map<String, dynamic> backupData,
    required String backupFilePath,
  }) async {
    final jsonStr = jsonEncode(backupData);
    final file = File(backupFilePath);
    await file.writeAsString(jsonStr);
  }

  static Future<Map<String, dynamic>> readBackupFile({
    required String backupFilePath,
  }) async {
    final file = File(backupFilePath);
    final jsonStr = await file.readAsString();
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  }
}

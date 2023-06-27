import 'package:eatery/references.dart';

class AppFileSystem {
  static Future<Directory> appDataRoot() async {
    return Directory(await baseDirectoryPath());
  }

  static Future<String> getDataDir() async {
    if (!(Directory('${(await appDataRoot()).path}/data')).existsSync()) {
      await Directory('${(await appDataRoot()).path}/data')
          .create(recursive: true);
    }

    return '${(await appDataRoot()).path}/data';
  }

  static Future<String> getBackupDir() async {
    if (!(Directory('${(await appDataRoot()).path}/backup')).existsSync()) {
      await Directory('${(await appDataRoot()).path}/backup')
          .create(recursive: true);
    }

    return '${(await appDataRoot()).path}/backup';
  }

  static Future<String> getExportDir() async {
    if (!(Directory('${(await appDataRoot()).path}/export')).existsSync()) {
      await Directory('${(await appDataRoot()).path}/export')
          .create(recursive: true);
    }
    return '${(await appDataRoot()).path}/export';
  }

  static Future<String> getShareDir() async {
    if (!(Directory('${(await appDataRoot()).path}/share')).existsSync()) {
      await Directory('${(await appDataRoot()).path}/share')
          .create(recursive: true);
    }
    return '${(await appDataRoot()).path}/share';
  }

  static Future<String> getResourcesDir() async {
    if (!(Directory('${(await appDataRoot()).path}/images')).existsSync()) {
      await Directory('${(await appDataRoot()).path}/images')
          .create(recursive: true);
    }

    return '${(await appDataRoot()).path}/images';
  }

  static String? pickedImage;

  static Widget buildUploadOptionsBottomSheet() =>
      StatefulBuilder(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Center(
                child: BottomViewGrip(),
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'Upload',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    icon: const Icon(Icons.upload),
                    iconSize: 48.0,
                    color: ColorStyle.text300,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    iconSize: 48.0,
                    color: ColorStyle.text300,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    iconSize: 48.0,
                    color: ColorStyle.text300,
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
                    color: ColorStyle.text300,
                    onPressed: () {},
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 1,
                        child: SecondaryButton(
                          color: ColorStyle.text300,
                          borderColor: ColorStyle.text400,
                          text: 'Camera',
                          height: 50.0,
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? photo = await picker.pickImage(
                                source: ImageSource.camera);

                            if (photo != null) {
                              if (!(Directory(
                                      '${(await appDataRoot()).path}/images'))
                                  .existsSync()) {
                                await Directory(
                                        '${(await appDataRoot()).path}/images')
                                    .create(recursive: true);
                              }
                              String path =
                                  '${'${(await appDataRoot()).path}/images'}/${getRandomString(32)}.${photo.name.split('.').last}';
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
                      const SizedBox(
                        width: 8.0,
                      ),
                      PrimaryButton(
                        color: ColorStyle.brandColor,
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? photo = await picker.pickImage(
                              source: ImageSource.gallery);

                          if (photo != null) {
                            if (!(Directory(
                                    '${(await appDataRoot()).path}/images'))
                                .existsSync()) {
                              await Directory(
                                      '${(await appDataRoot()).path}/images')
                                  .create(recursive: true);
                            }
                            String path =
                                '${'${(await appDataRoot()).path}/images'}/${getRandomString(32)}.${photo.name.split('.').last}';
                            photo.saveTo(path);
                            pickedImage = path;
                            Navigator.pop(context);
                            return;
                          }
                          pickedImage = null;
                          Navigator.pop(context);
                          return;
                        },
                        child: const Text('Gallery'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      });

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
        builder: (context) => buildUploadOptionsBottomSheet());
    return pickedImage;
  }

  static Future<void> doZip(
      {required String dataDirPath, required String zipFilePath}) async {
    final dataDir = Directory(dataDirPath);
    try {
      final zipFile = File(zipFilePath);
      ZipFile.createFromDirectory(
          sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> doUnZip(
      {required String dataDirPath, required String zipFilePath}) async {
    final zipFile = File(zipFilePath);
    final destinationDir = Directory(dataDirPath);
    try {
      ZipFile.extractToDirectory(
          zipFile: zipFile, destinationDir: destinationDir);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> saveBackupFile(
      {required Map<String, dynamic> backupData,
      required String backupFilePath}) async {
    final jsonStr = jsonEncode(backupData);
    final file = File(backupFilePath);
    await file.writeAsString(jsonStr);
  }

  static Future<Map<String, dynamic>> readBackupFile(
      {required String backupFilePath}) async {
    final file = File(backupFilePath);
    final jsonStr = await file.readAsString();
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter_archive/flutter_archive.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:eatery/services/utility/generate.dart';

class AppFileSystem {
  static Future<Directory> appDataRoot() async{
    return Directory((await getExternalStorageDirectory())!.parent.path);
  }

  static Future<String> getBackupDir() async {

    if (!(Directory((await appDataRoot()).path + '/backup')).existsSync()) {
      await Directory((await appDataRoot()).path + '/backup').create(recursive: true);
    }

    return '${(await appDataRoot()).path}/backup';
  }
  static Future<String> getExportDir() async {

    if (!(Directory((await appDataRoot()).path + '/export')).existsSync()) {
      await Directory((await appDataRoot()).path + '/export').create(recursive: true);
    }
    return '${(await appDataRoot()).path}/export';

  }
  static Future<String> getShareDir() async {

    if (!(Directory((await appDataRoot()).path + '/share')).existsSync()) {
      await Directory((await appDataRoot()).path + '/share').create(recursive: true);
    }
    return '${(await appDataRoot()).path}/share';

  }

  static Future<String> getResourcesDir() async {

    if (!(Directory((await appDataRoot()).path + '/images')).existsSync()) {
      await Directory((await appDataRoot()).path + '/images').create(recursive: true);
    }

    return '${(await appDataRoot()).path}/images';
  }

  static Future<String?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {

      if (!(Directory((await appDataRoot()).path + '/images')).existsSync()) {
        await Directory((await appDataRoot()).path + '/images').create(recursive: true);
      }
      String path = '${(await appDataRoot()).path + '/images'}/${getRandomString(32)}.${photo.name.split('.').last}';
      photo.saveTo(path);
      return path;
    }
    return null;
  }

  static Future<void> doZip({required String dataDirPath, required String zipFilePath}) async {
    final dataDir = Directory(dataDirPath);
    try {
      final zipFile = File(zipFilePath);
      ZipFile.createFromDirectory(sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
    } catch (e) {
      rethrow;
    }
  }
  static Future<void> doUnZip({required String dataDirPath, required String zipFilePath}) async {
    final zipFile = File(zipFilePath);
    final destinationDir = Directory(dataDirPath);
    try {
      ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: destinationDir);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> saveBackupFile({required Map<String, dynamic> backupData, required String backupFilePath}) async {
    final jsonStr = jsonEncode(backupData);
    final file = File(backupFilePath);
    await file.writeAsString(jsonStr);
  }
  static Future<Map<String, dynamic>> readBackupFile({required String backupFilePath}) async {
    final file = File(backupFilePath);
    final jsonStr = await file.readAsString();
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  }
}

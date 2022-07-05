import 'dart:convert';
import 'dart:io';
import 'package:flutter_archive/flutter_archive.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_pos/services/utility/generate.dart';

class AppFileSystem {
  static Future<String> getBackupDir() async {
    Directory resourcesDir = (await getExternalStorageDirectory()) != null
        ? (await getExternalStorageDirectory())!.parent
        : (await getApplicationDocumentsDirectory()).parent;

    if (!(Directory(resourcesDir.path + '/backup')).existsSync()) {
      await Directory(resourcesDir.path + '/backup').create(recursive: true);
    }

    return '${resourcesDir.path}/backup';
  }

  static Future<String> getResourcesDir() async {
    Directory resourcesDir = (await getExternalStorageDirectory()) != null
        ? (await getExternalStorageDirectory())!.parent
        : (await getApplicationDocumentsDirectory()).parent;

    if (!(Directory(resourcesDir.path + '/images')).existsSync()) {
      await Directory(resourcesDir.path + '/images').create(recursive: true);
    }

    return '${resourcesDir.path}/images';
  }

  static Future<String?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      Directory resourcesDir = (await getExternalStorageDirectory()) != null
          ? (await getExternalStorageDirectory())!.parent
          : (await getApplicationDocumentsDirectory()).parent;

      if (!(Directory(resourcesDir.path + '/images')).existsSync()) {
        await Directory(resourcesDir.path + '/images').create(recursive: true);
      }
      String path = '${resourcesDir.path + '/images'}/${getRandomString(32)}.${photo.name.split('.').last}';
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

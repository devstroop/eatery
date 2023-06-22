import 'dart:io';
import 'package:eatery/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class ImageLibrary {
  final String filename;

  ImageLibrary(this.filename);

  String get subDirectory => '/images';

  File get file => File(absolutePath);

  DateTime get lastModified => file.lastModifiedSync();

  Future<DateTime> get lastModifiedAsync => file.lastModified();

  bool get exists => file.existsSync();

  Future<bool> get existsAsync => file.exists();

  String get absolutePath => '${GlobalVariables.baseDirectory}$subDirectory/$filename';

  String get basename => path.basename(filename);

  String get extension => path.extension(filename);

  String get mimeType => lookupMimeType(extension) ?? 'application/octet-stream';

  int get size => file.lengthSync();

  Future<int> get sizeAsync => file.length();

  File copyTo(String destinationPath) {
    final destinationFile = File(destinationPath);
    return file.copySync(destinationFile.path);
  }

  Future<File> copyToAsync(String destinationPath) async {
    final destinationFile = File(destinationPath);
    return await file.copy(destinationFile.path);
  }

  File renameTo(String newFilename) {
    final newFilePath = '${path.dirname(absolutePath)}/$newFilename';
    final newFile = File(newFilePath);
    return file.renameSync(newFile.path);
  }

  Future<File> renameToAsync(String newFilename) async {
    final newFilePath = '${path.dirname(absolutePath)}/$newFilename';
    final newFile = File(newFilePath);
    return await file.rename(newFile.path);
  }

  void delete() {
    file.deleteSync();
  }

  Future<void> deleteAsync() async {
    await file.delete();
  }

  ImageProvider get image => (file.existsSync() ? Image.file(file) : Image.asset('assets/images/default.jpg')).image;

  static ImageLibrary importFromPath(String imagePath) {
    final sourceFile = File(imagePath);
    if (sourceFile.existsSync()) {
      try {
        final destinationFile =
        sourceFile.copySync('${GlobalVariables.baseDirectory}/images/${path.basename(imagePath)}');
        return ImageLibrary(destinationFile.path.replaceAll('\\', '/').replaceFirst(GlobalVariables.baseDirectory!, ''));
      } catch (e) {
        rethrow;
      }
    }
    throw Exception('Source file does not exist');
  }

  static Future<ImageLibrary> importFromURL(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final fileName = path.basename(url);
        final filePath = '${GlobalVariables.baseDirectory}/images/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        return ImageLibrary(file.path.replaceAll('\\', '/').replaceFirst(GlobalVariables.baseDirectory!, ''));
      } else {
        throw Exception('Failed to download image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to download image: $e');
    }
  }
}

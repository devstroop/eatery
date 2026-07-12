import 'dart:io';
import 'package:eatery/constants/utils/app_file_system.dart';
import 'package:eatery/references.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class LibraryImage {
  late String? filename;
  late String defaultImage;

  LibraryImage(this.filename, {this.defaultImage = 'assets/images/default.jpg'});

  String get _subDirectory => '/images';

  File get file => File(absolutePath);

  DateTime get lastModified => file.lastModifiedSync();

  Future<DateTime> get lastModifiedAsync => file.lastModified();

  bool exists() => filename != null && file.existsSync();

  Future<bool> existsAsync() async {
    return filename != null && await file.exists();
  }

  String get absolutePath => '${AppFileSystem.baseDir}$_subDirectory/$filename';

  String? get basename => exists() ? path.basename(filename!) : null;

  String? get extension => exists() ? path.extension(filename!) : null;

  String? get mimeType => exists()
      ? lookupMimeType(extension!) ?? 'application/octet-stream'
      : null;

  int? get size => exists() ? file.lengthSync() : null;

  Future<int?> get sizeAsync => exists() ? file.length() : Future.value(null);

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
  ImageProvider<Object> get image {
    return (file.existsSync()
        ? Image.file(file)
        : Image.asset(defaultImage))
        .image;
  }
}

class LibraryImageProvider {
  static LibraryImage importFromPath(String imagePath) {
    final sourceFile = File(imagePath);
    if (sourceFile.existsSync()) {
      try {
        final destinationFile = sourceFile
            .copySync('${AppFileSystem.imagesDir}/${path.basename(imagePath)}');
        return LibraryImage(destinationFile.path
            .replaceAll('\\', '/')
            .replaceFirst(AppFileSystem.imagesDir, ''));
      } catch (e) {
        rethrow;
      }
    }
    throw Exception('Source file does not exist');
  }

  static Future<LibraryImage> importFromURL(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        if (response.headers['content-type']!.contains('image')) {
          final bytes = response.bodyBytes;
          var fileName = path.basename(url);
          if(fileName.isEmpty) {
            throw Exception('Invalid URL');
          }
          if(!fileName.endsWith('.jpg') && !fileName.endsWith('.jpeg') && !fileName.endsWith('.png')) {
            // find extension from bytes
            var extension = lookupMimeType(fileName);
            extension = extension?.split('/').last ?? 'jpg';
            fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
          }
          final filePath = '${AppFileSystem.imagesDir}/$fileName';
          var file = File(filePath);
          return await file
              .writeAsBytes(bytes)
              .then((value) => LibraryImage(file.path
                  .replaceAll('\\', '/')
                  .replaceFirst('${AppFileSystem.imagesDir}/', '')))
              .onError((error, stackTrace) =>
                  throw Exception('Failed to write image to file: $error'));
        } else {
          throw Exception('Response is not image');
        }
      } else {
        throw Exception(
            'Failed to download image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to download image: $e');
    }
  }

  static List<LibraryImage> getAll({Function(LibraryImage)? listen}) {
    final directory = Directory('${AppFileSystem.baseDir}/images');
    if (directory.existsSync()) {
      return directory.listSync().map((e) {
        if (listen != null) {
          listen(LibraryImage(e.path
              .replaceAll('\\', '/')
              .replaceFirst('${AppFileSystem.baseDir}/images/', '')));
        }
        return LibraryImage(e.path
            .replaceAll('\\', '/')
            .replaceFirst('${AppFileSystem.baseDir}/images/', ''));
      }).toList();
    }
    return [];
  }

  static Future<List<LibraryImage>> getAllAsync(
      {Function(LibraryImage)? listen}) async {
    debugPrint(AppFileSystem.baseDir);
    final directory = Directory('${AppFileSystem.baseDir}/images');
    bool exists = await directory.exists();
    if (exists) {
      return directory.list().map((e) {
        if (listen != null) {
          LibraryImage libraryImage = LibraryImage(e.path
              .replaceAll('\\', '/')
              .replaceFirst('${AppFileSystem.baseDir}/images/', ''));
          listen(libraryImage);
        }

        return LibraryImage(e.path
            .replaceAll('\\', '/')
            .replaceFirst('${AppFileSystem.baseDir}/images/', ''));
      }).toList();
    }
    return [];
  }
}

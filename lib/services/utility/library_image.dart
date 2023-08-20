import 'dart:io';
import 'package:eatery/references.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import '../../constants/common.dart';

class LibraryImage {
  late String? filename;

  LibraryImage(this.filename);

  String get _subDirectory => '/images';

  File get file => File(absolutePath);

  DateTime get lastModified => file.lastModifiedSync();

  Future<DateTime> get lastModifiedAsync => file.lastModified();

  bool exists() => filename != null && file.existsSync();

  Future<bool> existsAsync() async {
    return filename != null && await file.exists();
  }

  String get absolutePath => '${Common.baseDirectory}$_subDirectory/$filename';

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

  ImageProvider get image {
    if((filename?.startsWith('http://') ?? false) || (filename?.startsWith('https://') ?? false)) {
      try{
        return FastCachedImageProvider(filename!);
      } catch(e) {
        return Image.asset('assets/images/default.jpg').image;
      }
    }
    return (file.existsSync()
            ? Image.file(file)
            : Image.asset('assets/images/default.jpg'))
        .image;
  }
}

class LibraryImageProvider {
  static LibraryImage importFromPath(String imagePath) {
    final sourceFile = File(imagePath);
    if (sourceFile.existsSync()) {
      try {
        final destinationFile = sourceFile
            .copySync('${Common.imagesDirectory}/${path.basename(imagePath)}');
        return LibraryImage(destinationFile.path
            .replaceAll('\\', '/')
            .replaceFirst(Common.imagesDirectory!, ''));
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
          final fileName = path.basename(url);
          final filePath = '${Common.imagesDirectory}/$fileName';
          var file = File(filePath);
          return await file
              .writeAsBytes(bytes)
              .then((value) => LibraryImage(file.path
                  .replaceAll('\\', '/')
                  .replaceFirst('${Common.imagesDirectory!}/', '')))
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
    final directory = Directory('${Common.baseDirectory}/images');
    if (directory.existsSync()) {
      return directory.listSync().map((e) {
        if (listen != null) {
          listen(LibraryImage(e.path
              .replaceAll('\\', '/')
              .replaceFirst('${Common.baseDirectory}/images/', '')));
        }
        return LibraryImage(e.path
            .replaceAll('\\', '/')
            .replaceFirst('${Common.baseDirectory}/images/', ''));
      }).toList();
    }
    return [];
  }

  static Future<List<LibraryImage>> getAllAsync(
      {Function(LibraryImage)? listen}) async {
    debugPrint(Common.baseDirectory);
    final directory = Directory('${Common.baseDirectory}/images');
    bool exists = await directory.exists();
    if (exists) {
      return directory.list().map((e) {
        if (listen != null) {
          LibraryImage libraryImage = LibraryImage(e.path
              .replaceAll('\\', '/')
              .replaceFirst('${Common.baseDirectory}/images/', ''));
          listen(libraryImage);
        }

        return LibraryImage(e.path
            .replaceAll('\\', '/')
            .replaceFirst('${Common.baseDirectory}/images/', ''));
      }).toList();
    }
    return [];
  }
}

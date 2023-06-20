import 'dart:io';
import 'package:eatery/constants/global_variables.dart';
import 'package:path/path.dart' as path;

class FileUtilityServices {
  static Future<File?> copyFile({
    required String sourcePath,
    required String targetPath,
    bool overwrite = false,
    bool renameIfExists = true,
  }) async {
    final sourceFile = _getFile(sourcePath);
    if (!_fileExists(sourceFile)) {
      throw Exception('Source file does not exist');
    }

    String sourceFileName = _getFileName(sourceFile);
    File? targetFile = _getFile(targetPath);

    if (!overwrite) {
      int index = 1;
      while (_fileExists(targetFile!)) {
        if (renameIfExists) {
          final newName = _getRenamedFileName(sourceFileName, index);
          final newTargetPath = _getFilePath(targetPath, newName);
          targetFile = _getFile(newTargetPath);
          index++;
        } else {
          throw Exception('File already exists');
        }
      }
    }

    return await sourceFile.copy(targetFile.path);
  }

  static Future<File?> moveFile({
    required String sourcePath,
    required String targetPath,
    bool overwrite = false,
    bool renameIfExists = true,
  }) async {
    final sourceFile = _getFile(sourcePath);
    if (!_fileExists(sourceFile)) {
      throw Exception('Source file does not exist');
    }

    String sourceFileName = _getFileName(sourceFile);
    File? targetFile = _getFile(targetPath);

    if (!overwrite) {
      int index = 1;
      while (_fileExists(targetFile!)) {
        if (renameIfExists) {
          final newName = _getRenamedFileName(sourceFileName, index);
          final newTargetPath = _getFilePath(targetPath, newName);
          targetFile = _getFile(newTargetPath);
          index++;
        } else {
          throw Exception('File already exists');
        }
      }
    }

    return await sourceFile.rename(targetFile.path);
  }

  static Future<FileSystemEntity?> deleteFile({
    required String filePath,
  }) async {
    final file = _getFile(filePath);
    if (!_fileExists(file)) {
      throw Exception('File does not exist');
    }
    return await file.delete();
  }

  static Future<FileSystemEntity?> deleteDirectory({
    required String directoryPath,
  }) async {
    final directory = _getDirectory(directoryPath);
    if (!_directoryExists(directory)) {
      throw Exception('Directory does not exist');
    }
    return await directory.delete(recursive: true);
  }

  static Future<FileSystemEntity?> createDirectory({
    required String directoryPath,
  }) async {
    final directory = _getDirectory(directoryPath);
    if (_directoryExists(directory)) {
      throw Exception('Directory already exists');
    }
    return await directory.create(recursive: true);
  }

  static Future<FileSystemEntity?> renameDirectory({
    required String directoryPath,
    required String newName,
  }) async {
    final directory = _getDirectory(directoryPath);
    if (!_directoryExists(directory)) {
      throw Exception('Source directory does not exist');
    }
    final newDirectoryPath = _getDirectoryPath(directoryPath, newName);
    return await directory.rename(newDirectoryPath);
  }

  static Future<FileSystemEntity?> renameFile({
    required String filePath,
    required String newName,
  }) async {
    final file = _getFile(filePath);
    if (!_fileExists(file)) {
      throw Exception('Source file does not exist');
    }
    final newFilePath = _getFilePath(filePath, newName);
    return await file.rename(newFilePath);
  }

  static Future<FileSystemEntity?> copyDirectory({
    required String sourcePath,
    required String targetPath,
    bool overwrite = false,
    bool renameIfExists = true,
  }) async {
    final sourceDirectory = _getDirectory(sourcePath);
    if (!_directoryExists(sourceDirectory)) {
      throw Exception('Source directory does not exist');
    }

    String sourceDirectoryName = _getDirectoryName(sourceDirectory);
    Directory? targetDirectory = _getDirectory(targetPath);

    if (!overwrite) {
      int index = 1;
      while (_directoryExists(targetDirectory!)) {
        if (renameIfExists) {
          final newDirectoryName =
              _getRenamedDirectoryName(sourceDirectoryName, index);
          final newTargetPath = _getDirectoryPath(targetPath, newDirectoryName);
          targetDirectory = _getDirectory(newTargetPath);
          index++;
        } else {
          throw Exception('Directory already exists');
        }
      }
    }

    await _copyDirectory(sourceDirectory, targetDirectory!.path);
    return targetDirectory;
  }

  static Future<void> _copyDirectory(
      Directory source, String targetPath) async {
    final target = Directory(targetPath);
    await target.create();

    final List<FileSystemEntity> files = source.listSync();

    for (var file in files) {
      if (file is File) {
        final newFile = File(path.join(target.path, path.basename(file.path)));
        await file.copy(newFile.path);
      } else if (file is Directory) {
        final newDirectory =
            Directory(path.join(target.path, path.basename(file.path)));
        await _copyDirectory(file, newDirectory.path);
      }
    }
  }

  static File _getFile(String filePath) {
    if (path.isAbsolute(filePath)) {
      return File(filePath);
    } else {
      return File(path.join(GlobalVariables.rootDirectory!.path, filePath));
    }
  }

  static Directory _getDirectory(String directoryPath) {
    if (path.isAbsolute(directoryPath)) {
      return Directory(directoryPath);
    } else {
      return Directory(
          path.join(GlobalVariables.rootDirectory!.path, directoryPath));
    }
  }

  static bool _fileExists(File file) {
    return file.existsSync();
  }

  static bool _directoryExists(Directory directory) {
    return directory.existsSync();
  }

  static String _getFileName(File file) {
    return path.basename(file.path);
  }

  static String _getDirectoryName(Directory directory) {
    return path.basename(directory.path);
  }

  static String _getRenamedFileName(String fileName, int index) {
    final nameWithoutExtension = path.basenameWithoutExtension(fileName);
    final extension = path.extension(fileName);
    final baseNameParts = nameWithoutExtension.split('-');

    if (baseNameParts.isNotEmpty && baseNameParts.last == '${index - 1}') {
      baseNameParts.removeLast();
    }

    return '${baseNameParts.join('-')}-$index$extension';
  }

  static String _getFilePath(String directoryPath, String fileName) {
    return path.join(directoryPath, fileName);
  }

  static String _getDirectoryPath(String parentPath, String directoryName) {
    return path.join(parentPath, directoryName);
  }

  static String _getRenamedDirectoryName(String directoryName, int index) {
    final nameWithoutExtension = path.basenameWithoutExtension(directoryName);
    final extension = path.extension(directoryName);
    final baseNameParts = nameWithoutExtension.split('-');

    if (baseNameParts.isNotEmpty && baseNameParts.last == '${index - 1}') {
      baseNameParts.removeLast();
    }

    return '${baseNameParts.join('-')}-$index$extension';
  }
}

extension FileExtension on File {
  File get absolute {
    if (path.isAbsolute(this.path)) {
      return this;
    } else {
      return File(path.join(GlobalVariables.rootDirectory!.path, this.path));
    }
  }
}

extension DirectoryExtension on Directory {
  Directory get absolute {
    if (path.isAbsolute(this.path)) {
      return this;
    } else {
      return Directory(
          path.join(GlobalVariables.rootDirectory!.path, this.path));
    }
  }
}

import 'package:path/path.dart' as path;

import 'package:eatery/references.dart';

class GlobalVariables {
  static bool expressMode = false;
  static List<Product> cart = [];
  static Company? company;
  static KCurrency? currency;

  // Relative paths
  static String? dataDirectory =
      _baseDirectory != null ? path.join(_baseDirectory!, 'data') : null;
  static String? imagesDirectory =
      _baseDirectory != null ? path.join(_baseDirectory!, 'images') : null;
  static String? backupDirectory =
      _baseDirectory != null ? path.join(_baseDirectory!, 'backups') : null;
  static String? importExportDirectory = _baseDirectory != null
      ? path.join(_baseDirectory!, 'exports')
      : null;
  static String? tempDirectory =
      _baseDirectory != null ? path.join(_baseDirectory!, 'temp') : null;

  // Absolute paths
  static String? _baseDirectory;

  static String? get baseDirectory => _baseDirectory;

  static set baseDirectory(String? value) {
    _baseDirectory = value;
    if (value != null) {
      _createDirectoryIfNotExists(path.join(value, dataDirectory));
      _createDirectoryIfNotExists(path.join(value, imagesDirectory));
      _createDirectoryIfNotExists(path.join(value, backupDirectory));
      _createDirectoryIfNotExists(path.join(value, importExportDirectory));
      _createDirectoryIfNotExists(path.join(value, tempDirectory));
    }
  }

  static void _createDirectoryIfNotExists(String directoryPath) async {
    final directory = Directory(directoryPath);
    final exists = await directory.exists();
    if (!exists) {
      await directory.create(recursive: true);
    }
  }
}

import 'dart:io';

import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';

class GlobalVariables {
  static bool expressMode = false;
  static List<Product> cart = [];
  static Company? company;
  static kCurrency? currency;

  // Relative paths
  static String? dataDirectory = '/data';
  static String? imagesDirectory = '/images';
  static String? backupDirectory = '/backup';
  // Absolute paths
  static String? dataDirectoryAbs =
      '${GlobalVariables.baseDirectory}$dataDirectory';
  static String? resourcesDirectoryAbs =
      '${GlobalVariables.baseDirectory}$imagesDirectory';
  static String? backupDirectoryAbs =
      '${GlobalVariables.baseDirectory}$backupDirectory';

  static String? _baseDirectory;
  static String? get baseDirectory => _baseDirectory;
  static set baseDirectory(String? value) {
    _baseDirectory = value;
    Future.delayed(Duration.zero, () {
      Directory dataDirectory = Directory(
          '${GlobalVariables.baseDirectory}${GlobalVariables.dataDirectory}');
      dataDirectory.exists().then((value) {
        debugPrint('dataDirectory: $value');
        if (!value) {
          dataDirectory.createSync(recursive: true);
        }
      });
      Directory resourcesDirectory = Directory(
          '${GlobalVariables.baseDirectory}${GlobalVariables.imagesDirectory}');
      resourcesDirectory.exists().then((value) {
        debugPrint('imagesDirectory: $value');
        if (!value) {
          resourcesDirectory.createSync(recursive: true);
        }
      });
      Directory backupDirectory = Directory(
          '${GlobalVariables.baseDirectory}${GlobalVariables.backupDirectory}');
      backupDirectory.exists().then((value) {
        debugPrint('backupDirectory: $value');
        if (!value) {
          backupDirectory.createSync(recursive: true);
        }
      });
    });
  }
}

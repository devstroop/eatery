import 'dart:io';

import 'package:eatery_db/eatery_db.dart';

class GlobalVariables {
  static List<Product> cart = [];
  static Company? company;
  static kCurrency? currency;
  static Directory? rootDirectory;
  static Directory? dataDirectory;
  static Directory? resourcesDirectory;
  static Directory? backupDirectory;
}

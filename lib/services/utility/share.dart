import 'package:flutter_share/flutter_share.dart';

Future<bool?> shareFile(String filePath, String title, String text) async {
  return await FlutterShare.shareFile(
    title: title,
    text: text,
    filePath: filePath,
  );
}
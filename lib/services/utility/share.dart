import 'package:flutter_share/flutter_share.dart';

Future<void> shareFile(String filePath, String title, String text) async {
  await FlutterShare.shareFile(
    title: title,
    text: text,
    filePath: filePath,
  );
}
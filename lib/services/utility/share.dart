import 'package:share_plus/share_plus.dart';

Future<void> shareFile(String filePath, String title, String text) async {
  await Share.shareXFiles([XFile(filePath)], subject: title, text: text);
}

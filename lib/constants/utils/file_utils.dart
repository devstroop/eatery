import 'package:eatery/references.dart';

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}

Future<String> baseDirectoryPath() async {
  String deviceRoot = Directory("/storage/emulated/0").path;
  String appName = 'Eatery';
  String appRoot = join(deviceRoot, appName);
  var appRootDir = Directory(appRoot);
  if (!(await appRootDir.exists())) appRootDir.create(recursive: true);
  return appRoot;
}

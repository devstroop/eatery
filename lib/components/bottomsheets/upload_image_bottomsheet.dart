import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/widgets/app_dialog.dart';

class UploadImageBottomSheet extends StatefulWidget {
  final BuildContext context;
  final Function(String? image) action;

  const UploadImageBottomSheet(this.context, this.action, {Key? key})
    : super(key: key);

  @override
  State<UploadImageBottomSheet> createState() => _UploadImageBottomSheetState();
}

class _UploadImageBottomSheetState extends State<UploadImageBottomSheet> {
  String? urlImage;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      fetchLinkFromClipboard();
    });
  }

  void fetchLinkFromClipboard() async {
    String clipboard = await FlutterClipboard.paste();
    if (clipboard.startsWith("http://") || clipboard.startsWith("https://")) {
      setState(() {
        urlImage = clipboard;
      });
    } else {
      setState(() {
        urlImage = null;
      });
    }
  }

  Future pickFromUrl() async {
    try {
      String? localPath;
      final response = await http.get(Uri.parse(urlImage!));
      // Get the image name
      final imageName = path.basename(urlImage!);
      if (!(Directory(
        '${(await Directory(AppFileSystem.baseDir)).path}/images',
      )).existsSync()) {
        await Directory(
          '${(await Directory(AppFileSystem.baseDir)).path}/images',
        ).create(recursive: true);
      }
      localPath =
          '${'${(await Directory(AppFileSystem.baseDir)).path}/images'}/${getRandomString(32)}.${imageName.split('.').last}';
      final imageFile = File(localPath);
      imageFile.writeAsBytes(response.bodyBytes).then((value) {
        widget.action(localPath);
        Navigator.pop(widget.context);
      });
    } catch (e) {
      Navigator.pop(widget.context);
      AppDialog.showMessage(widget.context, message: e.toString(), type: MessageType.error);
    }
  }

  Future pickFromGallery() async {
    String? path;
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      final imagesDir = '${AppFileSystem.baseDir}/images';
      if (!Directory(imagesDir).existsSync()) {
        await Directory(imagesDir).create(recursive: true);
      }
      path = '$imagesDir/${getRandomString(32)}.${photo.name.split('.').last}';
      await photo.saveTo(path!);
    }
    widget.action(path);
    Future.delayed(Duration.zero, () {
      Navigator.pop(widget.context);
    });
  }

  Future pickFromCamera() async {
    String? path;
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      final imagesDir = '${AppFileSystem.baseDir}/images';
      if (!Directory(imagesDir).existsSync()) {
        await Directory(imagesDir).create(recursive: true);
      }
      path = '$imagesDir/${getRandomString(32)}.${photo.name.split('.').last}';
      await photo.saveTo(path!);
    }
    widget.action(path);
    Future.delayed(Duration.zero, () {
      Navigator.pop(widget.context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Center(child: BottomViewGrip()),
              SpacingStyle.defaultVerticalSpacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (urlImage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(Icons.upload),
                        iconSize: 72.0,
                        color: AppColors.cyan,
                        onPressed: pickFromUrl,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.photo_library),
                      iconSize: urlImage != null ? 36.0 : 60,
                      color: AppColors.black500,
                      onPressed: pickFromGallery,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.camera),
                      iconSize: urlImage != null ? 36.0 : 60,
                      color: AppColors.black500,
                      onPressed: pickFromCamera,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

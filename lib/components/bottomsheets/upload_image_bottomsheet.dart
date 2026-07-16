import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/widgets/app_dialog.dart';

class UploadImageBottomSheet extends StatefulWidget {
  final Function(String? image) action;

  const UploadImageBottomSheet(this.action, {super.key});

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
        '${(Directory(AppFileSystem.baseDir)).path}/images',
      )).existsSync()) {
        await Directory(
          '${(Directory(AppFileSystem.baseDir)).path}/images',
        ).create(recursive: true);
      }
      localPath =
          '${'${(Directory(AppFileSystem.baseDir)).path}/images'}/${getRandomString(32)}.${imageName.split('.').last}';
      final imageFile = File(localPath);
      final BuildContext ctx = this.context;
      imageFile.writeAsBytes(response.bodyBytes).then((value) {
        widget.action(localPath);
        if (mounted) Navigator.pop(ctx);
      });
    } catch (e) {
      final BuildContext ctx = this.context;
      if (mounted) Navigator.pop(ctx);
      if (mounted) {
        AppDialog.showMessage(
          ctx,
          message: e.toString(),
          type: MessageType.error,
        );
      }
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
      await photo.saveTo(path);
    }
    widget.action(path);
    final BuildContext ctx = this.context;
    Future.delayed(Duration.zero, () {
      if (mounted) Navigator.pop(ctx);
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
      await photo.saveTo(path);
    }
    widget.action(path);
    final BuildContext ctx = this.context;
    Future.delayed(Duration.zero, () {
      if (mounted) Navigator.pop(ctx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return Padding(
          padding: AppSpacing.cardPadding,
          child: ListView(
            shrinkWrap: true,
            children: [
              const Center(child: AppBottomSheetGrip()),
              AppSpacing.gapMd,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (urlImage != null)
                    Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: IconButton(
                        icon: const Icon(Icons.upload),
                        iconSize: 72.0,
                        color: AppColors.primary,
                        onPressed: pickFromUrl,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: IconButton(
                      icon: const Icon(Icons.photo_library),
                      iconSize: urlImage != null ? 36.0 : 60,
                      color: AppColors.grey600,
                      onPressed: pickFromGallery,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: IconButton(
                      icon: const Icon(Icons.camera),
                      iconSize: urlImage != null ? 36.0 : 60,
                      color: AppColors.grey600,
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

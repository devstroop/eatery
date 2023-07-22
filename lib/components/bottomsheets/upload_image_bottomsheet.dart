import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:eatery/references.dart';

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
    
    Future.delayed(Duration.zero, (){
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
      if (!(Directory('${(await AppFileSystem.appDataRoot()).path}/images'))
          .existsSync()) {
        await Directory('${(await AppFileSystem.appDataRoot()).path}/images')
            .create(recursive: true);
      }
      localPath = '${'${(await AppFileSystem.appDataRoot()).path}/images'}/${getRandomString(32)}.${imageName.split('.').last}';
      final imageFile = File(localPath);
      imageFile.writeAsBytes(response.bodyBytes).then((value) {
        widget.action(localPath);
        Navigator.pop(widget.context);
      });
    } catch (e) {
      Navigator.pop(widget.context);
      showSnackBar(this.context, e.toString());
    }
  }

  Future pickFromGallery() async {
    String? path;
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      if (!(Directory('${(await AppFileSystem.appDataRoot()).path}/images'))
          .existsSync()) {
        await Directory('${(await AppFileSystem.appDataRoot()).path}/images')
            .create(recursive: true);
      }
      path =
          '${'${(await AppFileSystem.appDataRoot()).path}/images'}/${getRandomString(32)}.${photo.name.split('.').last}';
      photo.saveTo(path);
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
      if (!(Directory('${(await AppFileSystem.appDataRoot()).path}/images'))
          .existsSync()) {
        await Directory('${(await AppFileSystem.appDataRoot()).path}/images')
            .create(recursive: true);
      }
      AppFileSystem.appDataRoot().then((appDataRoot) async {
        path = '${'${appDataRoot.path}/images'}/${getRandomString(32)}.${photo.name.split('.').last}';
        photo.saveTo(path!);
      });
    }
    widget.action(path);
    Future.delayed(Duration.zero, () {
      Navigator.pop(widget.context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Center(
              child: BottomViewGrip(),
            ),
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
                        color: ColorStyle.information,
                        onPressed: pickFromUrl,
                      )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.photo_library),
                      iconSize: urlImage != null ? 36.0 : 60,
                      color: ColorStyle.text300,
                      onPressed: pickFromGallery,
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.camera),
                      iconSize: urlImage != null ? 36.0 : 60,
                      color: ColorStyle.text300,
                      onPressed: pickFromCamera,
                    )),
              ],
            ),
          ],
        ),
      );
    });
  }
}

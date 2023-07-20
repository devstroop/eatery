import 'package:eatery/references.dart';

class ImageLibraryPage extends StatefulWidget {
  final BuildContext context;
  final Function(LibraryImage? libraryImage) action;

  const ImageLibraryPage(this.context, this.action, {Key? key})
      : super(key: key);

  @override
  State<ImageLibraryPage> createState() =>
      _ImageLibraryPageState();
}

class _ImageLibraryPageState extends State<ImageLibraryPage> {
  List<LibraryImage> _images = [];

  @override
  void initState() {
    super.initState();
    fetchLibrary();
  }

  void fetchLibrary() {
    _images.clear();
    bool flag = false;
    LibraryImageProvider.getAllAsync(listen: (LibraryImage libraryImage) {
      setState(() {
        _images.add(libraryImage);
        flag = true;
      });
    }).then((List<LibraryImage> libraryImages) {
      if (flag) {
        setState(() {
          libraryImages
              .sort((a, b) => a.lastModified.compareTo(b.lastModified));
        });
      } else {
        setState(() {
          _images = [];
        });
      }
    });
  }

  Future pickImageFromFile() async {
    FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    ).then((value) async {
      if (value != null && value.files.isNotEmpty) {
        try {
          LibraryImage image =
              LibraryImageProvider.importFromPath(value.files.first.path!);
          fetchLibrary();
        } catch (e) {
          showSnackBar(this.context, e.toString());
        }
      }
    });
  }

  Future pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      try {
        LibraryImage image =
        LibraryImageProvider.importFromPath(xFile.path);
        fetchLibrary();
      } catch (e) {
        showSnackBar(this.context, e.toString());
      }
    }
  }

  Future pickFromCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      try {
        LibraryImage image =
        LibraryImageProvider.importFromPath(xFile.path);
        fetchLibrary();
      } catch (e) {
        showSnackBar(this.context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth ~/ 100;
    return StatefulBuilder(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          // shrinkWrap: true,
          children: [
            const Center(
              child: BottomSheetGrip(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(UIcons.regularStraight.arrow_left),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 6,),
                    const PageTitle(
                      title: "Library",
                      subtitle: "Previously imported images",
                    ),
                  ],
                ),
                Row(
                  children: [
                    FutureBuilder<ClipboardData?>(
                      future: Clipboard.getData('text/plain'),
                      builder: (context, snapshot) {
                        Uri? uri = Uri.tryParse(snapshot.data?.text ?? '');
                        debugPrint(uri.toString());
                        if (uri?.isAbsolute ?? false) {
                          return IconButton(
                            icon: Icon(UIcons.regularStraight.link),
                            iconSize: 24,
                            color: const Color(0xFF888888),
                            onPressed: (){
                              showConfirmationDialog(
                                context, "Import from link?", "This will download the image from the link and import it to the library.", (){
                                  LibraryImageProvider.importFromURL((uri ??'').toString()).then((value) {
                                    fetchLibrary();
                                  });
                                },(){
                              }
                              );
                            },
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    if (Platform.isAndroid)
                      IconButton(
                        icon: Icon(UIcons.regularStraight.camera),
                        iconSize: 24,
                        color: const Color(0xFF888888),
                        onPressed: pickFromCamera,
                      ),
                    if (Platform.isAndroid)
                      IconButton(
                        icon: Icon(UIcons.regularStraight.gallery),
                        iconSize: 24,
                        color: const Color(0xFF888888),
                        onPressed: pickFromGallery,
                      ),
                    if (Platform.isIOS)
                      IconButton(
                        icon: Icon(UIcons.regularStraight.download),
                        iconSize: 24,
                        color: const Color(0xFF888888),
                        onPressed: pickImageFromFile,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 6.0,
            ),
            const Divider(
              thickness: 0.5,
              color: Color(0xFFB2B2B2),
            ),
            if (_images.isEmpty)
              Opacity(
                opacity: 0.25,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Image.asset('assets/images/empty-folder.png'),
                    ),
                    const Text(
                      'Empty Library',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            if (_images.isNotEmpty)
              GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                shrinkWrap: true,
                children: [
                  for (var each in _images)
                    ImageContainer(
                      onTap: () {
                        widget.action(each);
                      },
                      onLongPress: () {
                        showConfirmationDialog(context, 'Are you sure?',
                            'Do you want to remove this image from library.',
                            () {
                          each.delete();
                          showSnackBar(context, 'Image removed from library.');
                          fetchLibrary();
                        }, () {
                          // Do nothing
                        });
                      },
                      image: each.image,
                    ),
                ],
              )
          ],
        ),
      );
    });
  }
}

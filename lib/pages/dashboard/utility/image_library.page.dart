import 'package:eatery_core/widgets/app_dialog.dart';
import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageLibraryPage extends ConsumerStatefulWidget {
  final BuildContext context;
  final Function(LibraryImage? libraryImage) action;

  const ImageLibraryPage(this.context, this.action, {super.key});

  @override
  ConsumerState<ImageLibraryPage> createState() => _ImageLibraryPageState();
}

class _ImageLibraryPageState extends ConsumerState<ImageLibraryPage> {
  List<LibraryImage> _images = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {});
    fetchLibrary();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void fetchLibrary() {
    _images.clear();
    bool flag = false;
    LibraryImageProvider.getAllAsync(
      listen: (LibraryImage libraryImage) {
        setState(() {
          _images.add(libraryImage);
          flag = true;
        });
      },
    ).then((List<LibraryImage> libraryImages) {
      if (flag) {
        setState(() {
          libraryImages.sort(
            (a, b) => a.lastModified.compareTo(b.lastModified),
          );
        });
      } else {
        setState(() {
          _images = [];
        });
      }
    });
  }

  Future pickImageFromFile() async {
    FilePicker.platform
        .pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
        )
        .then((value) async {
          if (value != null && value.files.isNotEmpty) {
            try {
              LibraryImage image = LibraryImageProvider.importFromPath(
                value.files.first.path!,
              );
              widget.action(image);
              fetchLibrary();
            } catch (e) {
              AppDialog.showMessage(
                this.context,
                message: e.toString(),
                type: MessageType.error,
              );
            }
          }
        });
  }

  Future pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        try {
          LibraryImage image = LibraryImageProvider.importFromPath(value.path);
          widget.action(image);
          fetchLibrary();
        } catch (e) {
          AppDialog.showMessage(
            this.context,
            message: e.toString(),
            type: MessageType.error,
          );
        }
      }
    });
  }

  Future pickFromCamera() async {
    final ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        try {
          LibraryImage image = LibraryImageProvider.importFromPath(value.path);
          widget.action(image);
          fetchLibrary();
        } catch (e) {
          AppDialog.showMessage(
            this.context,
            message: e.toString(),
            type: MessageType.error,
          );
        }
      }
    });
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth ~/ 100;
    return AppPageShell(
      title: 'Library',
      color: Colors.transparent,
      actions: [
        /*FutureBuilder<ClipboardData?>(
                      future: Clipboard.getData('text/plain'),
                      builder: (context, snapshot) {
                        Uri? uri = Uri.tryParse(snapshot.data?.text ?? '');
                        debugPrint(uri.toString());
                        if (uri?.isAbsolute ?? false) {
                          return IconButton(
                            icon: Icon(Icons.link),
                            iconSize: 24,
                            color: const Color(0xFF888888),
                            onPressed: () {
                              AppDialog.showConfirmation(
                                context,
                                title: "Import from link?",
                                content: "This will download the image from the link and import it to the library.",
                                onConfirm: () {
                                  LibraryImageProvider.importFromURL(
                                          (uri ?? '').toString())
                                      .then((value) {
                                    fetchLibrary();
                                  });
                                },
                              );
                            },
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),*/
        IconButton(
          icon: const Icon(Icons.download),
          iconSize: 18,
          color: const Color(0xFF888888),
          onPressed: () {
            onLinkAttachPressed(
              context,
              callback: (link) async {
                try {
                  await LibraryImageProvider.importFromURL(link);
                  fetchLibrary();
                } catch (e) {
                  AppDialog.showMessage(
                    context,
                    message: e.toString(),
                    type: MessageType.error,
                  );
                }
              },
            );
          },
        ),
        if (Platform.isAndroid)
          IconButton(
            icon: const Icon(Icons.camera_alt),
            iconSize: 18,
            color: const Color(0xFF888888),
            onPressed: pickFromCamera,
          ),
        if (Platform.isAndroid)
          IconButton(
            icon: const Icon(Icons.photo_library),
            iconSize: 18,
            color: const Color(0xFF888888),
            onPressed: pickFromGallery,
          ),
        if (Platform.isIOS)
          IconButton(
            icon: const Icon(Icons.download),
            iconSize: 18,
            color: const Color(0xFF888888),
            onPressed: pickImageFromFile,
          ),
      ],
      child: _images.isEmpty
          ? Opacity(
              opacity: 0.25,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Image.asset('assets/images/empty-folder.png'),
                    ),
                    Text(
                      'LIBRARY IS EMPTY',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'NO IMAGES FOUND IN LIBRARY',
                      style: AppTypography.bodyLarge,
                    ),
                  ],
                ),
              ),
            )
          : GridView.count(
              padding: const EdgeInsets.all(12.0),
              scrollDirection: Axis.vertical,
              controller: scrollController,
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              shrinkWrap: true,
              children: [
                ..._images.map(
                  (each) => ImageContainer(
                    label: each.filename,
                    onTap: () {
                      widget.action(each);
                    },
                    onLongPress: () {
                      AppDialog.show(
                        context,
                        title: 'Are you sure?',
                        content:
                            'Do you want to remove this image from library.',
                        onConfirm: () {
                          each.delete();
                          AppDialog.showMessage(
                            context,
                            message: 'Image removed from library.',
                            type: MessageType.success,
                            onConfirm: () => fetchLibrary(),
                          );
                        },
                        onCancel: () {
                          // Do nothing
                        },
                      );
                    },
                    image: each.image,
                  ),
                ),
              ],
            ),
    );
  }

  void onLinkAttachPressed(
    BuildContext context, {
    String? link,
    Function(String)? callback,
  }) {
    // Show dialog to enter link and fetch data from link in dialog
    TextEditingController controllerLink = TextEditingController();
    controllerLink.text = link ?? '';
    FocusNode focusNodeLink = FocusNode();
    focusNodeLink.requestFocus();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              focusNode: focusNodeLink,
              controller: controllerLink,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'Enter URL',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (callback != null) {
                      callback(controllerLink.text);
                    }
                  },
                  child: const Text('Download'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

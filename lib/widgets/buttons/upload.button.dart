import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

class UploadButton extends StatefulWidget {
  const UploadButton({
    Key? key,
    this.libraryImage,
    this.onChanged,
    this.primaryColor = const Color(0xFF30A8CF),
    this.secondaryColor = const Color(0xFF2F2F2F),
    this.title,
    this.label,
  }) : super(key: key);
  final LibraryImage? libraryImage;
  final Function(LibraryImage? libraryImage)? onChanged;
  final Color primaryColor;
  final Color secondaryColor;
  final String? title;
  final String? label;

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  LibraryImage? libraryImage;

  @override
  void initState() {
    super.initState();
  }

  void onUploadPressed(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          ImageLibraryPage(context, (LibraryImage? libraryImage) {
            this.libraryImage = libraryImage;
            if (widget.onChanged != null) {
              widget.onChanged!(libraryImage);
              Navigator.pop(context);
            }
            setState(() {});
          }),
      fullscreenDialog: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: const Color(0xFFFFFFFF),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 72,
                  width: 72,
                  child: Stack(
                    children: [
                      if (widget.libraryImage == null)
                        Center(
                          child: Icon(
                            Icons.photo_library,
                            size: 54,
                            color: widget.primaryColor.withOpacity(0.50),
                          ),
                        ),
                      if (widget.libraryImage != null)
                        Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F8),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  widget.libraryImage?.image ??
                                  const AssetImage('assets/images.default.jpg'),
                            ),
                          ),
                        ),
                      if (widget.libraryImage != null)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              libraryImage = null;
                              if (widget.onChanged != null) {
                                widget.onChanged!(null);
                              }
                              setState(() {});
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.error,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.label != null)
                      Text(
                        widget.label!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: widget.secondaryColor,
                        ),
                      ),
                    InkWell(
                      onTap: () => onUploadPressed(context),
                      child: Text(
                        widget.title ?? "+ Attach Media",
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => onUploadPressed(context),
                  icon: Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 24,
                    color: widget.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

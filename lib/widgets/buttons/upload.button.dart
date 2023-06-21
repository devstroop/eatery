import 'dart:io';
import 'package:eatery/services/utility/file.utility.service.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

import '../bottomSheets/imageLibrary.bottomSheet.dart';

class UploadButton extends StatefulWidget {
  const UploadButton(
      {Key? key,
      this.filePath,
      this.onChanged,
      this.primaryColor = const Color(0xFF30A8CF),
      this.secondaryColor = const Color(0xFF2F2F2F),
      this.title,
      this.label})
      : super(key: key);
  final String? filePath;
  final Function(String? path)? onChanged;
  final Color primaryColor;
  final Color secondaryColor;
  final String? title;
  final String? label;

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  String? filePath;
  @override
  void initState() {
    super.initState();
  }

  void onUploadPressed() => showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      builder: (context) => ImageLibraryBottomSheet(context, (path) {
            filePath = path;
            if (widget.onChanged != null) {
              widget.onChanged!(path);
            }
            setState(() {});
          }));

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: const Color(0xFFF0F0F0),
            border: Border.all(color: const Color(0xFFF0F0F0), width: 1)),
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
                      if (widget.filePath == null)
                        Center(
                            child: Icon(
                          UIcons.regularStraight.mode_landscape,
                          size: 54,
                          color: widget.primaryColor.withOpacity(0.50),
                        )),
                      if (widget.filePath != null)
                        Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F8),
                            borderRadius: BorderRadius.circular(4),
                            image: widget.filePath != null
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.file(File(
                                            FileUtilityService.getAbsolutePath(
                                                widget.filePath!)))
                                        .image,
                                  )
                                : null,
                          ),
                        ),
                      if (widget.filePath != null)
                        Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                filePath = null;
                                if (widget.onChanged != null) {
                                  widget.onChanged!(null);
                                }
                                setState(() {});
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xFFB63A3A),
                                ),
                                child: Icon(
                                  UIcons.regularStraight.minus_small,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                    ],
                  ),
                ),
                SizedBox(width: 6,),
                Container(
                  height: 96,
                  decoration: const BoxDecoration(),
                  child: Column(
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
                              color: widget.secondaryColor),
                        ),
                      InkWell(
                        onTap: onUploadPressed,
                        child: Text(
                          widget.title ?? "+ Attach Media",
                          style: TextStyle(
                              fontSize: 14,
                              color: widget.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: onUploadPressed,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                  child: SizedBox(
                    width: 54,
                    height: 84,
                    child: Icon(
                      UIcons.regularStraight.clip,
                      size: 24,
                      color: widget.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

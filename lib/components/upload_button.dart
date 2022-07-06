import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restaurant_pos/style/color_style.dart';

class UploadButton extends StatelessWidget {
  const UploadButton(
      {required this.title, required this.subTitle, this.pickedImagePath, this.primaryColor, this.secondaryColor, this.onCloseTap});

  final String title;
  final String subTitle;
  final String? pickedImagePath;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Function()? onCloseTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 84,
                height: 84,
                child: SvgPicture.asset(
                  'assets/images/10363.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subTitle,
                        style: TextStyle(fontSize: 12, color: secondaryColor),
                      ),
                      Text(
                        title,
                        style: TextStyle(fontSize: 14, color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pickedImagePath != null && File(pickedImagePath!).existsSync() ?
          Container(
                  height: 84,
                  width: 84,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.file(
                        File(pickedImagePath!),
                      ).image,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: onCloseTap,
                            child: Container(
                              height: 16,
                              width: 16,
                              child: const Icon(Icons.close, size: 12, color: Colors.white,),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorStyle.error,
                              ),
                            ),
                          ))
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

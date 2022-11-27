import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';

class PosCategoryWidget extends StatelessWidget {
  PosCategoryWidget({Key? key, this.active, required this.label, this.image, this.onTap})
      : super(key: key);
  late bool? active;
  final String label;
  final Widget? image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    active = active ?? false;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 6),
      child: InkWell(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: active! ? ColorStyle.text200 : ColorStyle.backgroundColorAlter,
              boxShadow: [
                BoxShadow(
                  color: active! ? ColorStyle.text200 : ColorStyle.backgroundColorAlter,
                )
              ],
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: active! ? ColorStyle.text200 : ColorStyle.backgroundColorAlter,
                width: 1,
              ),
            ),
            alignment: const AlignmentDirectional(0, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image != null
                      ? Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 6, 6),
                          child: image,
                        )
                      : const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                        ),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: active! ? ColorStyle.backgroundColorAlter : ColorStyle.text200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

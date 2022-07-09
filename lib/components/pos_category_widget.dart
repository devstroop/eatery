import 'package:flutter/material.dart';
import 'package:eatery/style/color_style.dart';

class PosCategoryWidget extends StatelessWidget {
  const PosCategoryWidget({Key? key, required this.active, required this.label, required this.image, this.onTap})
      : super(key: key);
  final bool active;
  final String label;
  final Widget? image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
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
              color: active ? ColorStyle.text200 : ColorStyle.background200,
              boxShadow: [
                BoxShadow(
                  color: active ? ColorStyle.text200 : ColorStyle.background200,
                )
              ],
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: active ? ColorStyle.text200 : ColorStyle.background300,
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
                      color: active ? ColorStyle.background200 : ColorStyle.text200,
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

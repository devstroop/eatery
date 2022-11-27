import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:eatery/constants/style/color_style.dart';
class LowQtyLabelWidget extends StatefulWidget {
  const LowQtyLabelWidget({
    Key? key,
    required this.qty,
  }) : super(key: key);

  final double qty;

  @override
  _LowQtyLabelWidgetState createState() => _LowQtyLabelWidgetState();
}

class _LowQtyLabelWidgetState extends State<LowQtyLabelWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFC8905C),
            boxShadow: [
              BoxShadow(
                color: ColorStyle.text100,
              )
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(4),
              topLeft: Radius.circular(0),
              topRight: Radius.circular(4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                  child: Text(
                    'Only',
                    style: TextStyle(
                      color: ColorStyle.backgroundColorAlter,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                  child: Text(
                    '${widget.qty%1 != 0 ? widget.qty: widget.qty.round()}',
                    style: TextStyle(
                      color: ColorStyle.backgroundColorAlter,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                  child: Text(
                    'left',
                    style: TextStyle(
                      color: ColorStyle.backgroundColorAlter,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 9,
          height: 4,
          decoration: const BoxDecoration(),
          child: SvgPicture.asset(
            'assets/images/Vector_135.svg',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

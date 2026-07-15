import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

class LowQtyLabelWidget extends StatefulWidget {
  const LowQtyLabelWidget({Key? key, required this.qty}) : super(key: key);

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
            boxShadow: [BoxShadow(color: AppColors.black900)],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(4),
              topLeft: Radius.circular(0),
              topRight: Radius.circular(4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                  child: Text(
                    '${widget.qty % 1 != 0 ? widget.qty : widget.qty.round()}',
                    style: TextStyle(color: AppColors.white, fontSize: 10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                  child: Text(
                    'in stock',
                    style: TextStyle(color: AppColors.white, fontSize: 10),
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

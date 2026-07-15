import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

class BottomViewGrip extends StatelessWidget {
  const BottomViewGrip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 16.0),
      width: 60,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(2),
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
        ),
        color: AppColors.white600,
      ),
    );
  }
}

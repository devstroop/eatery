import 'package:eatery/references.dart';

class PosCategoryWidget extends StatelessWidget {
  const PosCategoryWidget({
    Key? key,
    this.active = false,
    required this.label,
    this.image,
    this.onTap,
  }) : super(key: key);

  final bool active;
  final String label;
  final Widget? image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 12),
      child: InkWell(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              color:
                  active ? ColorStyle.text200 : ColorStyle.backgroundColorAlter,
              boxShadow: [
                BoxShadow(
                  color: active
                      ? ColorStyle.text200
                      : ColorStyle.backgroundColorAlter,
                ),
              ],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active
                    ? ColorStyle.text200
                    : ColorStyle.backgroundColorAlter,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (image != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 6),
                      child: image,
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(right: 3),
                    ),
                  const SizedBox(width: 2,),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: active
                          ? ColorStyle.backgroundColorAlter
                          : ColorStyle.text200,
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

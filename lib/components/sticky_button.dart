import 'package:eatery/references.dart';

class StickyButton extends StatelessWidget {
  const StickyButton({
    Key? key,
    required this.name,
    this.iconData,
    this.onTap,
    this.topLeftRound,
    this.topRightRound,
    this.bottomLeftRound,
    this.bottomRightRound,
  }) : super(key: key);
  final dynamic name; // String
  final dynamic iconData;
  final double? topLeftRound;
  final double? topRightRound;
  final double? bottomLeftRound;
  final double? bottomRightRound;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(9, 0, 9, 0),
            decoration: BoxDecoration(
              color: ColorStyle.backgroundColorAlter,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2F000000),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                  spreadRadius: 1,
                )
              ],
              borderRadius: BorderRadius.circular(6),
            ),
            width: ((MediaQuery.of(context).size.width <
                            MediaQuery.of(context).size.height
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.height) -
                    48) /
                2,
            height: ((MediaQuery.of(context).size.width <
                            MediaQuery.of(context).size.height
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.height) -
                    48) /
                2 *
                (1 / 3),
            child: Row(
              children: [
                Flexible(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: ColorStyle.backgroundColorAlter,
                            borderRadius: BorderRadius.only(
                              topLeft: topLeftRound != null
                                  ? Radius.circular(topLeftRound!)
                                  : const Radius.circular(6),
                              bottomLeft: bottomLeftRound != null
                                  ? Radius.circular(bottomLeftRound!)
                                  : const Radius.circular(6),
                            ),
                            /*image: File(image ?? '').existsSync()
                                ? DecorationImage(image: FileImage(File(image!)), fit: BoxFit.scaleDown)
                                : const DecorationImage(
                                image: AssetImage('assets/images/default.jpg'), fit: BoxFit.cover),*/
                          ),
                          child: Icon(iconData),
                        ),
                      ],
                    )),
                Flexible(
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: ColorStyle.backgroundColorAlter,
                            borderRadius: BorderRadius.only(
                                topRight: topRightRound != null
                                    ? Radius.circular(topRightRound!)
                                    : const Radius.circular(6),
                                bottomRight: bottomRightRound != null
                                    ? Radius.circular(bottomRightRound!)
                                    : const Radius.circular(6)),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.all(12.0),
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: ColorStyle.text200),
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

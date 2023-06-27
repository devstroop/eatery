import 'package:eatery/references.dart';

class PosWaiterCard extends StatelessWidget {
  const PosWaiterCard({Key? key, required this.id, required this.name, this.image, this.onTap, this.active}) : super(key: key);
  final dynamic id; // int
  final dynamic name; // String
  final dynamic image;
  final bool? active;
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
            width: ((MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.height) -
                48) /
                2,
            height: ((MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.height) -
                48) /
                2 *
                (1 / 3),
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: ColorStyle.backgroundColorAlter,
                              borderRadius:
                              const BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
                              image: File(image ?? '').existsSync()
                                  ? DecorationImage(image: FileImage(File(image!)), fit: BoxFit.cover)
                                  : const DecorationImage(
                                  image: AssetImage('assets/images/default.jpg'), fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                      flex: 3,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: active ?? false ? ColorStyle.text200 : ColorStyle.backgroundColorAlter,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.all(12.0),
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,
                                  color: active ?? false ? ColorStyle.backgroundColorAlter : ColorStyle.text200
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

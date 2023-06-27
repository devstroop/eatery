import 'package:eatery/references.dart';

class ProductCategoryCard extends StatelessWidget {
  const ProductCategoryCard(
      {Key? key, required this.id, required this.name, this.image, this.onTap})
      : super(key: key);
  final int? id; // int
  final String name; // String
  final String? image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: ColorStyle.backgroundColorAlter),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null && File(image!).existsSync())
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.file(File(image!))),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              name,
              style: TextStyle(color: ColorStyle.text200),
            )
          ],
        ),
      ),
    );
  }

/*@override
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
                  blurRadius: 4,
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
              child: Container(
                decoration: BoxDecoration(
                  color: ColorStyle.backgroundColorAlter,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Stack(
                          children: [
                            File(image ?? '').existsSync()
                                ? Container(
                                    margin: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: FileImage(File(image!)), fit: BoxFit.cover),
                                    ),
                                  )
                                : Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
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
                                color: ColorStyle.backgroundColorAlter,
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
                                style:
                                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/
}

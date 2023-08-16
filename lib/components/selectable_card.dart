import 'package:eatery/references.dart';

class SelectableCard extends StatelessWidget {
  const SelectableCard(
      {Key? key,
      required this.header,
      required this.title,
      this.highlights,
      required this.footer,
      required this.selected,
      this.highlightColor,
      this.child,
      this.onTap})
      : super(key: key);

  final String header;
  final String title;
  final List<String>? highlights;
  final String footer;
  final bool selected;
  final Color? highlightColor;
  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? (highlightColor ?? KColors.secondary2) : KColors.white600,
            width: selected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    header,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: KColors.black500),
                  ),
                  selected
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: Stack(children: <Widget>[
                            Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: (highlightColor ?? KColors.secondary2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.elliptical(24, 24)),
                                    ))),
                            Positioned(
                                top: 7,
                                left: 7,
                                child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: KColors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.elliptical(10, 10)),
                                    ))),
                          ]))
                      : Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(209, 215, 215, 1),
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.elliptical(24, 24)),
                          ))
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: KColors.black900,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              if (highlights != null)
                Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: [
                    for (var highlight in highlights!)
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: (highlightColor ?? KColors.secondary2)
                              .withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.elliptical(4, 4)),
                        ),
                        child: Text(
                          highlight,
                          style: TextStyle(
                              color: highlightColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                  ],
                ),
              const SizedBox(
                height: 8.0,
              ),
              child != null && selected ? child! : Container(),
              child != null && selected
                  ? const SizedBox(
                      height: 8.0,
                    )
                  : Container(),
              Text(
                footer,
                style: TextStyle(color: KColors.black500),
              )
            ],
          ),
        ),
      ),
    );
  }
}

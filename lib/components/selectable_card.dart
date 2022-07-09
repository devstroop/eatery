import 'package:flutter/material.dart';
import 'package:eatery/style/color_style.dart';

class SelectableCard extends StatelessWidget {
  const SelectableCard(
      {required this.header,
      required this.title,
        required this.highlights,
      required this.footer,
      required this.active,
      required this.highlightColor,
      this.child});

  final String header;
  final String title;
  final List<String> highlights;
  final String footer;
  final bool active;
  final Color highlightColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: active ? ColorStyle.logoColor : ColorStyle.text400,
          width: active ? 2 : 1,
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
                  style: TextStyle(fontWeight: FontWeight.w500, color: ColorStyle.text300),
                ),
                active
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
                                    color: ColorStyle.logoColor,
                                    borderRadius: const BorderRadius.all(Radius.elliptical(24, 24)),
                                  ))),
                          Positioned(
                              top: 7,
                              left: 7,
                              child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: ColorStyle.background100,
                                    borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
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
                          borderRadius: const BorderRadius.all(Radius.elliptical(24, 24)),
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
                color: ColorStyle.text100,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),

            Row(
              children: [
                for(var highlight in highlights)
                  Container(
                    margin: const EdgeInsets.only(right: 6.0),
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(color: highlightColor.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.elliptical(4, 4)),),
                    child: Text(
                      highlight,
                      style: TextStyle(color: highlightColor, fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            child != null && active ? child! : Container(),
            child != null && active ? const SizedBox(
              height: 8.0,
            ) : Container(),
            Text(
              footer,
              style: TextStyle(
                color: ColorStyle.text300
              ),
            )
          ],
        ),
      ),
    );
  }
}

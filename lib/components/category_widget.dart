import 'package:flutter/material.dart';
import 'dart:math' as math;
class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 163,
        height: 52,
        decoration: const BoxDecoration(
          color : Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Stack(
            children: <Widget>[
              Positioned(
                  top: 0,
                  left: 0,
                  child: SizedBox(
                      width: 163,
                      height: 52,

                      child: Stack(
                          children: <Widget>[
                            Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                    width: 163,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      borderRadius : const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                        bottomLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(4),
                                      ),
                                      color : const Color.fromRGBO(194, 69, 69, 0.05000000074505806),
                                      border : Border.all(
                                        color: const Color.fromRGBO(194, 69, 69, 1),
                                        width: 1,
                                      ),
                                    )
                                )
                            ),Positioned(
                                top: 16,
                                left: 16,
                                child: Transform.rotate(
                                  angle: -1.2265774044928344e-17 * (math.pi / 180),
                                  child: const Text('Table 5', textAlign: TextAlign.center, style: TextStyle(
                                      color: Color.fromRGBO(194, 69, 69, 1),
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1.25
                                  ),),
                                )
                            ),Positioned(
                                top: 16,
                                left: 117,
                                child: Transform.rotate(
                                  angle: -1.2265774044928344e-17 * (math.pi / 180),
                                  child: const Text('\$234', textAlign: TextAlign.center, style: TextStyle(
                                      color: Color.fromRGBO(205, 102, 102, 1),
                                      fontFamily: 'Roboto',
                                      fontSize: 13,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5384615384615385
                                  ),),
                                )
                            ),
                          ]
                      )
                  )
              ),
            ]
        )
    );
  }
}

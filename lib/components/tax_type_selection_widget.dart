import 'package:flutter/material.dart';

class TaxTypeSelectionWidget extends StatelessWidget {
  const TaxTypeSelectionWidget({Key? key, required this.taxType}) : super(key: key);
  final String? taxType;
  @override
  Widget build(BuildContext context) {
    if(taxType == 'inclusive'){
      return SizedBox(
          width: 194,
          height: 48,
          child: Stack(
              children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 194,
                        height: 48,
                        decoration: const BoxDecoration(
                          borderRadius : BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          color : Color.fromRGBO(240, 240, 240, 1),
                        )
                    )
                ),Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                        width: 96,
                        height: 38,
                        decoration: const BoxDecoration(
                          borderRadius : BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                          boxShadow : [BoxShadow(
                              color: Color.fromRGBO(20, 86, 242, 0.11999999731779099),
                              offset: Offset(0,1),
                              blurRadius: 3
                          )],
                          color : Color.fromRGBO(48, 167, 206, 1),
                        )
                    )
                ),const Positioned(
                    top: 16,
                    left: 25,
                    child: Text('Inclusive', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.1428571428571428
                    ),)
                ),const Positioned(
                    top: 16,
                    left: 113,
                    child: Text('Exclusive', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(87, 95, 96, 1),
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.1428571428571428
                    ),)
                ),
              ]
          )
      );
    }else if(taxType == 'exclusive'){
      return SizedBox(
          width: 194,
          height: 48,
          child: Stack(
              children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 194,
                        height: 48,
                        decoration: const BoxDecoration(
                          borderRadius : BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          color : Color.fromRGBO(240, 240, 240, 1),
                        )
                    )
                ),Positioned(
                    top: 5,
                    left: 101,
                    child: Container(
                        width: 88,
                        height: 38,
                        decoration: const BoxDecoration(
                          borderRadius : BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                          boxShadow : [BoxShadow(
                              color: Color.fromRGBO(20, 86, 242, 0.11999999731779099),
                              offset: Offset(0,1),
                              blurRadius: 3
                          )],
                          color : Color.fromRGBO(48, 167, 206, 1),
                        )
                    )
                ),const Positioned(
                    top: 16,
                    left: 25,
                    child: Text('Inclusive', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(87, 96, 96, 1),
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.1428571428571428
                    ),)
                ),const Positioned(
                    top: 16,
                    left: 117,
                    child: Text('Exclusive', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.1428571428571428
                    ),)
                ),
              ]
          )
      );
    }else{
      return SizedBox(
          width: 194,
          height: 48,
          child: Stack(
              children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 194,
                        height: 48,
                        decoration: const BoxDecoration(
                          borderRadius : BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          color : Color.fromRGBO(240, 240, 240, 1),
                        )
                    )
                ),const Positioned(
                    top: 16,
                    left: 25,
                    child: Text('Inclusive', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(87, 96, 96, 1),
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.1428571428571428
                    ),)
                ),const Positioned(
                    top: 16,
                    left: 111,
                    child: Text('Exclusive', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(87, 95, 96, 1),
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.1428571428571428
                    ),)
                ),
              ]
          )
      );
    }
  }
}

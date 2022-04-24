import 'package:flutter/material.dart';

class FoodTypeSelectionWidget extends StatelessWidget {
  const FoodTypeSelectionWidget({Key? key, required this.foodType}) : super(key: key);
  final String? foodType;
  @override
  Widget build(BuildContext context) {
    if(foodType == 'veg'){
      return Container(
          width: 149,
          height: 48,
          child: Stack(
              children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 149,
                        height: 48,
                        decoration: BoxDecoration(
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
                        width: 65,
                        height: 38,
                        decoration: BoxDecoration(
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
                          color : Color.fromRGBO(28, 201, 98, 1),
                        )
                    )
                ),Positioned(
                    top: 16,
                    left: 25,
                    child: Text('Veg', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.1428571428571428
                    ),)
                ),Positioned(
                    top: 16,
                    left: 82,
                    child: Text('Non Veg', textAlign: TextAlign.left, style: TextStyle(
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
    }else if(foodType == 'nonVeg'){
      return Container(
          width: 149,
          height: 48,
          child: Stack(
              children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 149,
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
                    left: 70,
                    child: Container(
                        width: 72,
                        height: 38,
                        decoration: BoxDecoration(
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
                          color : Color.fromRGBO(206, 48, 48, 1),
                        )
                    )
                ),Positioned(
                    top: 16,
                    left: 25,
                    child: Text('Veg', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(87, 96, 96, 1),
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.1428571428571428
                    ),)
                ),Positioned(
                    top: 16,
                    left: 82,
                    child: Text('Non Veg', textAlign: TextAlign.left, style: TextStyle(
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
      return Container(
          width: 149,
          height: 48,
          child: Stack(
              children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 149,
                        height: 48,
                        decoration: BoxDecoration(
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
                    top: 16,
                    left: 25,
                    child: Text('Veg', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(87, 96, 96, 1),
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.1428571428571428
                    ),)
                ),Positioned(
                    top: 16,
                    left: 82,
                    child: Text('Non Veg', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(87, 96, 96, 1),
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

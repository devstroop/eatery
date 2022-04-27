import 'package:flutter/material.dart';

class FoodTypeBadge extends StatelessWidget {
  const FoodTypeBadge({Key? key, required this.foodType, this.backgroundColor}) : super(key: key);
  final String? foodType;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if(foodType != null){
      if (foodType == 'veg') {
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: const Color(0xFF43A047),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF43A047),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: const AlignmentDirectional(0, 0),
            ),
          ),
        );
      } else if (foodType == 'nonVeg') {
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: const Color(0xFFE53935),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: const AlignmentDirectional(0, 0),
            ),
          ),
        );
      } else if (foodType == 'semiveg') {
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: const Color(0xFFE5C835),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE5C835),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: const AlignmentDirectional(0, 0),
            ),
          ),
        );
      }
    }
    return Container();
  }
}

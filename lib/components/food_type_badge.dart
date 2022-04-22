import 'package:flutter/material.dart';

class FoodTypeBadge extends StatelessWidget {
  const FoodTypeBadge({Key? key, required this.foodType}) : super(key: key);
  final String? foodType;

  @override
  Widget build(BuildContext context) {
    if(foodType != null){
      if (foodType == 'veg') {
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
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
      } else if (foodType == 'nonveg') {
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
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

import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum DiningTableStatus { available, occupied, reserved, inactive }

extension DiningTableStatusExtension on DiningTableStatus {
  int get id {
    switch (this) {
      case DiningTableStatus.available:
        return 0;
      case DiningTableStatus.occupied:
        return 1;
      case DiningTableStatus.reserved:
        return 2;
      case DiningTableStatus.inactive:
        return 3;
    }
  }

  String get name {
    switch (this) {
      case DiningTableStatus.available:
        return 'Available';
      case DiningTableStatus.occupied:
        return 'Occupied';
      case DiningTableStatus.reserved:
        return 'Reserved';
      case DiningTableStatus.inactive:
        return 'Inactive';
    }
  }

  String get shortName {
    switch (this) {
      case DiningTableStatus.available:
        return 'A';
      case DiningTableStatus.occupied:
        return 'O';
      case DiningTableStatus.reserved:
        return 'R';
      case DiningTableStatus.inactive:
        return 'I';
    }
  }

  Color get color {
    switch (this) {
      case DiningTableStatus.available:
        return Colors.green;
      case DiningTableStatus.occupied:
        return AppColors.error;
      case DiningTableStatus.reserved:
        return Colors.orange;
      case DiningTableStatus.inactive:
        return Colors.grey;
    }
  }
}

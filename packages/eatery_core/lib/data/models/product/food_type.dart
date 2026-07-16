import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum FoodType {
  @JsonValue(0)
  veg,
  @JsonValue(1)
  nonVeg,
}

extension FoodTypeExtension on FoodType {
  int get id {
    switch (this) {
      case FoodType.veg:
        return 0;
      case FoodType.nonVeg:
        return 1;
    }
  }

  String get name {
    switch (this) {
      case FoodType.veg:
        return 'Veg';
      case FoodType.nonVeg:
        return 'Non-veg';
    }
  }

  String get description {
    switch (this) {
      case FoodType.veg:
        return 'Veg food includes all plant based diets like fruits, vegetables, etc.';
      case FoodType.nonVeg:
        return 'Non-veg food contains meat and sometimes, eggs.';
    }
  }

  Color get color {
    switch (this) {
      case FoodType.veg:
        return const Color(0xFF43A047);
      case FoodType.nonVeg:
        return const Color(0xFFE53935);
    }
  }
}

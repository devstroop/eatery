import 'package:flutter/material.dart';
import 'package:restaurant_pos/style/color_style.dart';

enum OrderType{
  dineIn,
  delivery,
  takeAway
}
extension PosModeExtension on OrderType {
  IconData? get icon {
    switch (this) {
      case OrderType.dineIn:
        return Icons.dinner_dining;
      case OrderType.delivery:
        return Icons.delivery_dining;
      case OrderType.takeAway:
        return Icons.takeout_dining;
      default:
        return null;
    }
  }
  String? get text {
    switch (this) {
      case OrderType.dineIn:
        return 'Dine in';
      case OrderType.delivery:
        return 'Delivery';
      case OrderType.takeAway:
        return 'Takeaway';
      default:
        return null;
    }
  }
  Color? get color {
    switch (this) {
      case OrderType.dineIn:
        return ColorStyle.tertiary;
      case OrderType.delivery:
        return ColorStyle.secondary;
      case OrderType.takeAway:
        return ColorStyle.alternate;
      default:
        return null;
    }
  }
  Color? get foreColor {
    switch (this) {
      case OrderType.dineIn:
        return ColorStyle.background100;
      case OrderType.delivery:
        return ColorStyle.background100;
      case OrderType.takeAway:
        return ColorStyle.background100;
      default:
        return null;
    }
  }
}
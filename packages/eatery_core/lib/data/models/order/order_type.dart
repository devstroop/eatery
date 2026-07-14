import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum OrderType {
  @JsonValue(0)
  dine,
  @JsonValue(1)
  delivery,
  @JsonValue(2)
  takeout,
}

extension OrderTypeExtension on OrderType {
  int? get id {
    switch (this) {
      case OrderType.dine:
        return 0;
      case OrderType.delivery:
        return 1;
      case OrderType.takeout:
        return 2;
    }
  }

  String? get name {
    switch (this) {
      case OrderType.dine:
        return "Dine";
      case OrderType.delivery:
        return "Delivery";
      case OrderType.takeout:
        return "Takeout";
    }
  }

  String? get description {
    switch (this) {
      case OrderType.dine:
        return 'Dine';
      case OrderType.delivery:
        return 'Delivery';
      case OrderType.takeout:
        return 'Takeout';
    }
  }

  int? get color {
    switch (this) {
      case OrderType.dine:
        return 0xFFE0855E;
      case OrderType.delivery:
        return 0xFF705EE0;
      case OrderType.takeout:
        return 0xFF4AC3A1;
    }
  }
}

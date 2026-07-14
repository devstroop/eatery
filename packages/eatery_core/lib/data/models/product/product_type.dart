import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ProductType {
  @JsonValue(0)
  kitchenDish,
  @JsonValue(1)
  inventoryItem,
}

extension ProductTypeExtension on ProductType {
  int get id {
    switch (this) {
      case ProductType.kitchenDish:
        return 0;
      case ProductType.inventoryItem:
        return 1;
    }
  }

  String get name {
    switch (this) {
      case ProductType.kitchenDish:
        return 'Kitchen Dish';
      case ProductType.inventoryItem:
        return 'Inventory Item';
    }
  }
}

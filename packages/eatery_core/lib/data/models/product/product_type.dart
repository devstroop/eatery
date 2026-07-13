enum ProductType { kitchenDish, inventoryItem }

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

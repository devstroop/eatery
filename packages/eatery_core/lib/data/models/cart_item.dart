import 'package:eatery_core/data/models/eatery_db.dart';

/// A cart line item with quantity tracking.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get lineTotal => product.salePrice ?? product.mrpPrice * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);
}

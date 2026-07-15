import 'package:eatery_core/data/models/product/food_type.dart';
import 'package:eatery_core/data/models/product/product_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    int? id,
    required String name,
    int? categoryId,
    String? description,
    String? image,
    required double mrpPrice,
    double? salePrice,
    int? taxSlabId,
    FoodType? foodType,
    required ProductType type,
    required bool isActive,
    int? stationId,
    String? stationName,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  static Product fromMap(Map<String, dynamic> map) => Product.fromJson(map);

  static Product fromIterable(Iterable<dynamic> iterable) {
    return Product(
      name: iterable.elementAt(1) as String,
      categoryId: iterable.elementAt(2) as int?,
      description: iterable.elementAt(3) as String?,
      image: iterable.elementAt(4) as String?,
      mrpPrice: iterable.elementAt(5) as double,
      salePrice: iterable.elementAt(6) as double?,
      taxSlabId: iterable.elementAt(7) as int?,
      foodType: FoodType.values.singleWhere(
        (element) => element.id == iterable.elementAt(8) as int,
      ),
      type: ProductType.values.singleWhere(
        (element) => element.index == iterable.elementAt(9) as int,
      ),
      isActive: iterable.elementAt(10) as bool,
      stationId: iterable.elementAt(11) as int?,
      stationName: iterable.elementAt(12) as String?,
    );
  }
}

extension ProductX on Product {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  List<dynamic> toIterable() {
    return [
      id,
      name,
      categoryId,
      description,
      image,
      mrpPrice,
      salePrice,
      taxSlabId,
      foodType?.id,
      type.index,
      isActive,
      stationId,
      stationName,
    ];
  }
}

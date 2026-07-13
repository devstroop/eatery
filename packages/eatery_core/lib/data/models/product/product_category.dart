import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_category.freezed.dart';
part 'product_category.g.dart';

@freezed
abstract class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    int? id,
    required String name,
    String? description,
    String? image,
  }) = _ProductCategory;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);

  static ProductCategory fromMap(Map<String, dynamic> map) =>
      ProductCategory.fromJson(map);

  static ProductCategory fromIterable(Iterable<dynamic> row) {
    return ProductCategory.fromMap({
      'id': row.elementAt(0),
      'name': row.elementAt(1),
      'description': row.elementAt(2),
      'image': row.elementAt(3),
    });
  }
}

extension ProductCategoryX on ProductCategory {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  List<dynamic> toIterable() {
    return [name, description, image];
  }
}

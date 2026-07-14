import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_modifier.freezed.dart';
part 'product_modifier.g.dart';

@freezed
abstract class ProductModifier with _$ProductModifier {
  const factory ProductModifier({
    required int productId,
    required int modifierGroupId,
  }) = _ProductModifier;

  factory ProductModifier.fromJson(Map<String, dynamic> json) =>
      _$ProductModifierFromJson(json);

  static ProductModifier fromMap(Map<String, dynamic> map) =>
      ProductModifier.fromJson(map);
}

extension ProductModifierX on ProductModifier {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

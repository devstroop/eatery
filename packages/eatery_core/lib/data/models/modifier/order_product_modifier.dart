import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_product_modifier.freezed.dart';
part 'order_product_modifier.g.dart';

@freezed
abstract class OrderProductModifier with _$OrderProductModifier {
  const factory OrderProductModifier({
    int? id,
    required int orderProductId,
    required int modifierGroupId,
    required int modifierId,
    required String modifierName,
    @Default(0.0) double priceAdjust,
    @Default(1) int quantity,
  }) = _OrderProductModifier;

  factory OrderProductModifier.fromJson(Map<String, dynamic> json) =>
      _$OrderProductModifierFromJson(json);

  static OrderProductModifier fromMap(Map<String, dynamic> map) =>
      OrderProductModifier.fromJson(map);
}

extension OrderProductModifierX on OrderProductModifier {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

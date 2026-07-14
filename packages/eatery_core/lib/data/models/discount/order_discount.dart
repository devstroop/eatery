import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eatery_core/data/models/converters.dart';

part 'order_discount.freezed.dart';
part 'order_discount.g.dart';

@freezed
abstract class OrderDiscount with _$OrderDiscount {
  const factory OrderDiscount({
    int? id,
    required int orderId,
    int? discountId,
    required String name,
    required int type,
    required double value,
    required double amount,
    int? appliedBy,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required DateTime createdAt,
  }) = _OrderDiscount;
  factory OrderDiscount.fromJson(Map<String, dynamic> json) => _$OrderDiscountFromJson(json);
  static OrderDiscount fromMap(Map<String, dynamic> map) => OrderDiscount.fromJson(map);
}
extension OrderDiscountX on OrderDiscount {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

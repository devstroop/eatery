import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eatery_core/data/models/converters.dart';

part 'discount.freezed.dart';
part 'discount.g.dart';

@freezed
abstract class Discount with _$Discount {
  const factory Discount({
    int? id,
    required String name,
    required int type,
    required double value,
    double? minOrder,
    int? maxUses,
    @Default(true) bool isActive,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? startsAt,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? endsAt,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? updatedAt,
  }) = _Discount;
  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);
  static Discount fromMap(Map<String, dynamic> map) => Discount.fromJson(map);
}

extension DiscountX on Discount {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

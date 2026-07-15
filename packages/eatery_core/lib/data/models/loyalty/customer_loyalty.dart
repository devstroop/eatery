import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eatery_core/data/models/converters.dart';
part 'customer_loyalty.freezed.dart';
part 'customer_loyalty.g.dart';

@freezed
abstract class CustomerLoyalty with _$CustomerLoyalty {
  const factory CustomerLoyalty({
    int? id,
    required int customerId,
    @Default(0.0) double points,
    @Default(0) int totalVisits,
    @Default(0.0) double totalSpent,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? lastVisitAt,
    @Default(0) int tier,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? updatedAt,
  }) = _CustomerLoyalty;
  factory CustomerLoyalty.fromJson(Map<String, dynamic> json) =>
      _$CustomerLoyaltyFromJson(json);
  static CustomerLoyalty fromMap(Map<String, dynamic> map) =>
      CustomerLoyalty.fromJson(map);
}

extension CustomerLoyaltyX on CustomerLoyalty {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

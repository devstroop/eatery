import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eatery_core/data/models/converters.dart';

part 'stock_adjustment.freezed.dart';
part 'stock_adjustment.g.dart';

@freezed
abstract class StockAdjustment with _$StockAdjustment {
  const factory StockAdjustment({
    int? id,
    required int productId,
    required double quantity,
    required String reason,
    int? referenceId,
    String? notes,
    int? createdBy,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime createdAt,
  }) = _StockAdjustment;

  factory StockAdjustment.fromJson(Map<String, dynamic> json) =>
      _$StockAdjustmentFromJson(json);
  static StockAdjustment fromMap(Map<String, dynamic> map) =>
      StockAdjustment.fromJson(map);
}

extension StockAdjustmentX on StockAdjustment {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

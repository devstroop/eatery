import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eatery_core/data/models/converters.dart';

part 'purchase_order.freezed.dart';
part 'purchase_order.g.dart';

@freezed
abstract class PurchaseOrder with _$PurchaseOrder {
  const factory PurchaseOrder({
    int? id,
    int? supplierId,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required DateTime orderDate,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? expectedDate,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? deliveredDate,
    @Default(0) int status,
    @Default(0.0) double totalAmount,
    String? notes,
    int? createdBy,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required DateTime createdAt,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt,
  }) = _PurchaseOrder;

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => _$PurchaseOrderFromJson(json);
  static PurchaseOrder fromMap(Map<String, dynamic> map) => PurchaseOrder.fromJson(map);
}

extension PurchaseOrderX on PurchaseOrder {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

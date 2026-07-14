import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_order_item.freezed.dart';
part 'purchase_order_item.g.dart';

@freezed
abstract class PurchaseOrderItem with _$PurchaseOrderItem {
  const factory PurchaseOrderItem({
    int? id,
    required int purchaseOrderId,
    required int productId,
    required double quantity,
    required double unitPrice,
    required double totalPrice,
    @Default(0.0) double receivedQty,
  }) = _PurchaseOrderItem;

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) => _$PurchaseOrderItemFromJson(json);
  static PurchaseOrderItem fromMap(Map<String, dynamic> map) => PurchaseOrderItem.fromJson(map);
}

extension PurchaseOrderItemX on PurchaseOrderItem {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

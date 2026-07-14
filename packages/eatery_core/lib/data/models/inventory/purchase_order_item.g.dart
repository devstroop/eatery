// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseOrderItem _$PurchaseOrderItemFromJson(Map<String, dynamic> json) =>
    _PurchaseOrderItem(
      id: (json['id'] as num?)?.toInt(),
      purchaseOrderId: (json['purchaseOrderId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      receivedQty: (json['receivedQty'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PurchaseOrderItemToJson(_PurchaseOrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purchaseOrderId': instance.purchaseOrderId,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'totalPrice': instance.totalPrice,
      'receivedQty': instance.receivedQty,
    };

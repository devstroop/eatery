// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_product_modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderProductModifier _$OrderProductModifierFromJson(
  Map<String, dynamic> json,
) => _OrderProductModifier(
  id: (json['id'] as num?)?.toInt(),
  orderProductId: (json['orderProductId'] as num).toInt(),
  modifierGroupId: (json['modifierGroupId'] as num).toInt(),
  modifierId: (json['modifierId'] as num).toInt(),
  modifierName: json['modifierName'] as String,
  priceAdjust: (json['priceAdjust'] as num?)?.toDouble() ?? 0.0,
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$OrderProductModifierToJson(
  _OrderProductModifier instance,
) => <String, dynamic>{
  'id': instance.id,
  'orderProductId': instance.orderProductId,
  'modifierGroupId': instance.modifierGroupId,
  'modifierId': instance.modifierId,
  'modifierName': instance.modifierName,
  'priceAdjust': instance.priceAdjust,
  'quantity': instance.quantity,
};

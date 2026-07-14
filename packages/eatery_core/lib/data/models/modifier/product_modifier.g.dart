// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModifier _$ProductModifierFromJson(Map<String, dynamic> json) =>
    _ProductModifier(
      productId: (json['productId'] as num).toInt(),
      modifierGroupId: (json['modifierGroupId'] as num).toInt(),
    );

Map<String, dynamic> _$ProductModifierToJson(_ProductModifier instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'modifierGroupId': instance.modifierGroupId,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderDiscount _$OrderDiscountFromJson(Map<String, dynamic> json) =>
    _OrderDiscount(
      id: (json['id'] as num?)?.toInt(),
      orderId: (json['orderId'] as num).toInt(),
      discountId: (json['discountId'] as num?)?.toInt(),
      name: json['name'] as String,
      type: (json['type'] as num).toInt(),
      value: (json['value'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      appliedBy: (json['appliedBy'] as num?)?.toInt(),
      createdAt: epochFromJson((json['createdAt'] as num).toInt()),
    );

Map<String, dynamic> _$OrderDiscountToJson(_OrderDiscount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'discountId': instance.discountId,
      'name': instance.name,
      'type': instance.type,
      'value': instance.value,
      'amount': instance.amount,
      'appliedBy': instance.appliedBy,
      'createdAt': epochToJson(instance.createdAt),
    };

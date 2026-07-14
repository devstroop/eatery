// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: (json['id'] as num?)?.toInt(),
  customerPhone: json['customerPhone'] as String?,
  createdAt: epochFromJson((json['createdAt'] as num).toInt()),
  updatedAt: epochFromJsonNullable((json['updatedAt'] as num?)?.toInt()),
  totalQuantity: (json['totalQuantity'] as num).toInt(),
  subTotal: (json['subTotal'] as num).toDouble(),
  discountTotal: (json['discountTotal'] as num).toDouble(),
  taxTotal: (json['taxTotal'] as num).toDouble(),
  finalTotal: (json['finalTotal'] as num).toDouble(),
  roundOff: (json['roundOff'] as num).toDouble(),
  grandTotal: (json['grandTotal'] as num).toDouble(),
  paidTotal: (json['paidTotal'] as num?)?.toDouble(),
  type: $enumDecode(_$OrderTypeEnumMap, json['type']),
  status: json['status'] == null
      ? OrderStatus.pending
      : _statusFromJson(json['status']),
  voidReason: json['voidReason'] as String?,
  voidedBy: json['voidedBy'] as String?,
  voidedAt: epochFromJsonNullable((json['voidedAt'] as num?)?.toInt()),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'customerPhone': instance.customerPhone,
  'createdAt': epochToJson(instance.createdAt),
  'updatedAt': epochToJsonNullable(instance.updatedAt),
  'totalQuantity': instance.totalQuantity,
  'subTotal': instance.subTotal,
  'discountTotal': instance.discountTotal,
  'taxTotal': instance.taxTotal,
  'finalTotal': instance.finalTotal,
  'roundOff': instance.roundOff,
  'grandTotal': instance.grandTotal,
  'paidTotal': instance.paidTotal,
  'type': _$OrderTypeEnumMap[instance.type]!,
  'status': _statusToJson(instance.status),
  'voidReason': instance.voidReason,
  'voidedBy': instance.voidedBy,
  'voidedAt': epochToJsonNullable(instance.voidedAt),
};

const _$OrderTypeEnumMap = {
  OrderType.dine: 0,
  OrderType.delivery: 1,
  OrderType.takeout: 2,
};

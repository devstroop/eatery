// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Discount _$DiscountFromJson(Map<String, dynamic> json) => _Discount(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  type: (json['type'] as num).toInt(),
  value: (json['value'] as num).toDouble(),
  minOrder: (json['minOrder'] as num?)?.toDouble(),
  maxUses: (json['maxUses'] as num?)?.toInt(),
  isActive: json['isActive'] as bool? ?? true,
  startsAt: epochFromJsonNullable((json['startsAt'] as num?)?.toInt()),
  endsAt: epochFromJsonNullable((json['endsAt'] as num?)?.toInt()),
  createdAt: epochFromJson((json['createdAt'] as num).toInt()),
  updatedAt: epochFromJsonNullable((json['updatedAt'] as num?)?.toInt()),
);

Map<String, dynamic> _$DiscountToJson(_Discount instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'value': instance.value,
  'minOrder': instance.minOrder,
  'maxUses': instance.maxUses,
  'isActive': instance.isActive,
  'startsAt': epochToJsonNullable(instance.startsAt),
  'endsAt': epochToJsonNullable(instance.endsAt),
  'createdAt': epochToJson(instance.createdAt),
  'updatedAt': epochToJsonNullable(instance.updatedAt),
};

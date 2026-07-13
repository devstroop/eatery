// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_slab.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaxSlab _$TaxSlabFromJson(Map<String, dynamic> json) => _TaxSlab(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  rate: (json['rate'] as num).toDouble(),
  type:
      $enumDecodeNullable(_$TaxTypeEnumMap, json['type']) ?? TaxType.inclusive,
);

Map<String, dynamic> _$TaxSlabToJson(_TaxSlab instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'rate': instance.rate,
  'type': _$TaxTypeEnumMap[instance.type]!,
};

const _$TaxTypeEnumMap = {TaxType.inclusive: 0, TaxType.exclusive: 1};

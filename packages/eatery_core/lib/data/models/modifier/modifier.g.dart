// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Modifier _$ModifierFromJson(Map<String, dynamic> json) => _Modifier(
  id: (json['id'] as num?)?.toInt(),
  modifierGroupId: (json['modifierGroupId'] as num).toInt(),
  name: json['name'] as String,
  priceAdjust: (json['priceAdjust'] as num?)?.toDouble() ?? 0.0,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  isDefault: json['isDefault'] as bool? ?? false,
  createdAt: epochFromJson((json['createdAt'] as num).toInt()),
  updatedAt: epochFromJsonNullable((json['updatedAt'] as num?)?.toInt()),
);

Map<String, dynamic> _$ModifierToJson(_Modifier instance) => <String, dynamic>{
  'id': instance.id,
  'modifierGroupId': instance.modifierGroupId,
  'name': instance.name,
  'priceAdjust': instance.priceAdjust,
  'sortOrder': instance.sortOrder,
  'isDefault': instance.isDefault,
  'createdAt': epochToJson(instance.createdAt),
  'updatedAt': epochToJsonNullable(instance.updatedAt),
};

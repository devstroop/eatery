// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kds_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KdsStation _$KdsStationFromJson(Map<String, dynamic> json) => _KdsStation(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$KdsStationToJson(_KdsStation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
    };

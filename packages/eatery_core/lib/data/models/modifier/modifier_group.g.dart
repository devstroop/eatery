// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ModifierGroup _$ModifierGroupFromJson(Map<String, dynamic> json) =>
    _ModifierGroup(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      minSelect: (json['minSelect'] as num?)?.toInt() ?? 0,
      maxSelect: (json['maxSelect'] as num?)?.toInt() ?? 1,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isRequired: json['isRequired'] as bool? ?? false,
      createdAt: epochFromJson((json['createdAt'] as num).toInt()),
      updatedAt: epochFromJsonNullable((json['updatedAt'] as num?)?.toInt()),
    );

Map<String, dynamic> _$ModifierGroupToJson(_ModifierGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'minSelect': instance.minSelect,
      'maxSelect': instance.maxSelect,
      'sortOrder': instance.sortOrder,
      'isRequired': instance.isRequired,
      'createdAt': epochToJson(instance.createdAt),
      'updatedAt': epochToJsonNullable(instance.updatedAt),
    };

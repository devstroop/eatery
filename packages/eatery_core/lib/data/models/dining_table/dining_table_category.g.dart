// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dining_table_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiningTableCategory _$DiningTableCategoryFromJson(Map<String, dynamic> json) =>
    _DiningTableCategory(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$DiningTableCategoryToJson(
  _DiningTableCategory instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'isActive': instance.isActive,
};

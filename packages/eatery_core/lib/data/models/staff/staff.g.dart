// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Staff _$StaffFromJson(Map<String, dynamic> json) => _Staff(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  photo: json['photo'] as String?,
  phone: json['phone'] as String?,
  type:
      $enumDecodeNullable(_$StaffTypeEnumMap, json['type']) ?? StaffType.waiter,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$StaffToJson(_Staff instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'photo': instance.photo,
  'phone': instance.phone,
  'type': _$StaffTypeEnumMap[instance.type]!,
  'isActive': instance.isActive,
};

const _$StaffTypeEnumMap = {
  StaffType.waiter: 0,
  StaffType.chef: 1,
  StaffType.driver: 2,
  StaffType.other: 3,
};

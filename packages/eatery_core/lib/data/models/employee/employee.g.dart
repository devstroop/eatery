// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Employee _$EmployeeFromJson(Map<String, dynamic> json) => _Employee(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  email: json['email'] as String?,
  photo: json['photo'] as String?,
  phone: json['phone'] as String?,
  pin: json['pin'] as String?,
  pinUpdatedAt: (json['pinUpdatedAt'] as num?)?.toInt(),
  lastLoginAt: (json['lastLoginAt'] as num?)?.toInt(),
  type:
      $enumDecodeNullable(_$EmployeeRoleEnumMap, json['type']) ??
      EmployeeRole.waiter,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$EmployeeToJson(_Employee instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'photo': instance.photo,
  'phone': instance.phone,
  'pin': instance.pin,
  'pinUpdatedAt': instance.pinUpdatedAt,
  'lastLoginAt': instance.lastLoginAt,
  'type': _$EmployeeRoleEnumMap[instance.type]!,
  'isActive': instance.isActive,
};

const _$EmployeeRoleEnumMap = {
  EmployeeRole.waiter: 0,
  EmployeeRole.chef: 1,
  EmployeeRole.driver: 2,
  EmployeeRole.other: 3,
  EmployeeRole.admin: 4,
  EmployeeRole.manager: 5,
};

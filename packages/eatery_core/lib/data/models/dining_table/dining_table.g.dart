// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dining_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiningTable _$DiningTableFromJson(Map<String, dynamic> json) => _DiningTable(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  orderId: (json['orderId'] as num?)?.toInt(),
  categoryId: (json['categoryId'] as num?)?.toInt(),
  capacity: (json['capacity'] as num?)?.toInt() ?? 0,
  status:
      $enumDecodeNullable(_$DiningTableStatusEnumMap, json['status']) ??
      DiningTableStatus.available,
  customerPhone: json['customerPhone'] as String?,
);

Map<String, dynamic> _$DiningTableToJson(_DiningTable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'orderId': instance.orderId,
      'categoryId': instance.categoryId,
      'capacity': instance.capacity,
      'status': _$DiningTableStatusEnumMap[instance.status]!,
      'customerPhone': instance.customerPhone,
    };

const _$DiningTableStatusEnumMap = {
  DiningTableStatus.available: 0,
  DiningTableStatus.occupied: 1,
  DiningTableStatus.reserved: 2,
  DiningTableStatus.inactive: 3,
};

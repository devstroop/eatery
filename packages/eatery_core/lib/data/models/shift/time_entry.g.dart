// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeEntry _$TimeEntryFromJson(Map<String, dynamic> json) => _TimeEntry(
  id: (json['id'] as num?)?.toInt(),
  employeeId: (json['employeeId'] as num).toInt(),
  shiftId: (json['shiftId'] as num?)?.toInt(),
  clockIn: epochFromJson((json['clockIn'] as num).toInt()),
  clockOut: epochFromJsonNullable((json['clockOut'] as num?)?.toInt()),
  breakStart: epochFromJsonNullable((json['breakStart'] as num?)?.toInt()),
  breakEnd: epochFromJsonNullable((json['breakEnd'] as num?)?.toInt()),
  note: json['note'] as String?,
  createdAt: epochFromJson((json['createdAt'] as num).toInt()),
);

Map<String, dynamic> _$TimeEntryToJson(_TimeEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'shiftId': instance.shiftId,
      'clockIn': epochToJson(instance.clockIn),
      'clockOut': epochToJsonNullable(instance.clockOut),
      'breakStart': epochToJsonNullable(instance.breakStart),
      'breakEnd': epochToJsonNullable(instance.breakEnd),
      'note': instance.note,
      'createdAt': epochToJson(instance.createdAt),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_hours.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HolidayHours _$HolidayHoursFromJson(Map<String, dynamic> json) =>
    _HolidayHours(
      id: (json['id'] as num?)?.toInt(),
      date: json['date'] as String,
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$HolidayHoursToJson(_HolidayHours instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
      'description': instance.description,
    };

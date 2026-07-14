// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_hours.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BusinessHours _$BusinessHoursFromJson(Map<String, dynamic> json) =>
    _BusinessHours(
      id: (json['id'] as num?)?.toInt(),
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
      isClosed: json['isClosed'] as bool? ?? false,
    );

Map<String, dynamic> _$BusinessHoursToJson(_BusinessHours instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dayOfWeek': instance.dayOfWeek,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
      'isClosed': instance.isClosed,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reservation _$ReservationFromJson(Map<String, dynamic> json) => _Reservation(
  id: (json['id'] as num?)?.toInt(),
  customerName: json['customerName'] as String,
  customerPhone: json['customerPhone'] as String?,
  diningTableId: (json['diningTableId'] as num?)?.toInt(),
  partySize: (json['partySize'] as num).toInt(),
  dateTime: epochFromJson((json['dateTime'] as num).toInt()),
  duration: (json['duration'] as num?)?.toInt() ?? 60,
  status: (json['status'] as num?)?.toInt() ?? 0,
  note: json['note'] as String?,
  createdBy: (json['createdBy'] as num?)?.toInt(),
  createdAt: epochFromJson((json['createdAt'] as num).toInt()),
  updatedAt: epochFromJsonNullable((json['updatedAt'] as num?)?.toInt()),
);

Map<String, dynamic> _$ReservationToJson(_Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'diningTableId': instance.diningTableId,
      'partySize': instance.partySize,
      'dateTime': epochToJson(instance.dateTime),
      'duration': instance.duration,
      'status': instance.status,
      'note': instance.note,
      'createdBy': instance.createdBy,
      'createdAt': epochToJson(instance.createdAt),
      'updatedAt': epochToJsonNullable(instance.updatedAt),
    };

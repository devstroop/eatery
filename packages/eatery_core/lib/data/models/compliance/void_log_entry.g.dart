// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'void_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VoidLogEntry _$VoidLogEntryFromJson(Map<String, dynamic> json) =>
    _VoidLogEntry(
      id: (json['id'] as num?)?.toInt(),
      orderId: (json['orderId'] as num).toInt(),
      voidedAt: epochFromJson((json['voidedAt'] as num).toInt()),
      voidedBy: json['voidedBy'] as String,
      reasonCode: json['reasonCode'] as String,
      reasonDescription: json['reasonDescription'] as String?,
      amount: (json['amount'] as num).toDouble(),
      orderReference: json['orderReference'] as String?,
    );

Map<String, dynamic> _$VoidLogEntryToJson(_VoidLogEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'voidedAt': epochToJson(instance.voidedAt),
      'voidedBy': instance.voidedBy,
      'reasonCode': instance.reasonCode,
      'reasonDescription': instance.reasonDescription,
      'amount': instance.amount,
      'orderReference': instance.orderReference,
    };

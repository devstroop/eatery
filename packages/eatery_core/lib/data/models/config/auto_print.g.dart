// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_print.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AutoPrint _$AutoPrintFromJson(Map<String, dynamic> json) => _AutoPrint(
  id: (json['id'] as num?)?.toInt(),
  invoicePrintEnabled: json['invoicePrintEnabled'] as bool?,
  kotPrintEnabled: json['kotPrintEnabled'] as bool?,
  invoicePrinterId: (json['invoicePrinterId'] as num?)?.toInt(),
  kotPrinterId: (json['kotPrinterId'] as num?)?.toInt(),
);

Map<String, dynamic> _$AutoPrintToJson(_AutoPrint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoicePrintEnabled': instance.invoicePrintEnabled,
      'kotPrintEnabled': instance.kotPrintEnabled,
      'invoicePrinterId': instance.invoicePrinterId,
      'kotPrinterId': instance.kotPrinterId,
    };

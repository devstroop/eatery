// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: (json['id'] as num?)?.toInt(),
  orderId: (json['orderId'] as num?)?.toInt(),
  date: epochFromJson((json['date'] as num).toInt()),
  amount: (json['amount'] as num).toDouble(),
  mode: $enumDecode(_$PaymentModeEnumMap, json['mode']),
  reference: json['reference'] as String?,
  attachment: json['attachment'] as String?,
  processorTransactionId: json['processorTransactionId'] as String?,
  processorName: json['processorName'] as String?,
  processorStatus: json['processorStatus'] as String?,
  cardLastFour: json['cardLastFour'] as String?,
  terminalId: json['terminalId'] as String?,
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'orderId': instance.orderId,
  'date': epochToJson(instance.date),
  'amount': instance.amount,
  'mode': _$PaymentModeEnumMap[instance.mode]!,
  'reference': instance.reference,
  'attachment': instance.attachment,
  'processorTransactionId': instance.processorTransactionId,
  'processorName': instance.processorName,
  'processorStatus': instance.processorStatus,
  'cardLastFour': instance.cardLastFour,
  'terminalId': instance.terminalId,
};

const _$PaymentModeEnumMap = {
  PaymentMode.cash: 0,
  PaymentMode.card: 1,
  PaymentMode.upi: 2,
  PaymentMode.wallet: 3,
  PaymentMode.other: 4,
};

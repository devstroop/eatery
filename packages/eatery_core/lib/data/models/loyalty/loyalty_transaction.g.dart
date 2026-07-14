// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoyaltyTransaction _$LoyaltyTransactionFromJson(Map<String, dynamic> json) =>
    _LoyaltyTransaction(
      id: (json['id'] as num?)?.toInt(),
      customerId: (json['customerId'] as num).toInt(),
      points: (json['points'] as num).toDouble(),
      type: (json['type'] as num).toInt(),
      referenceId: (json['referenceId'] as num?)?.toInt(),
      description: json['description'] as String?,
      createdAt: epochFromJson((json['createdAt'] as num).toInt()),
    );

Map<String, dynamic> _$LoyaltyTransactionToJson(_LoyaltyTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'points': instance.points,
      'type': instance.type,
      'referenceId': instance.referenceId,
      'description': instance.description,
      'createdAt': epochToJson(instance.createdAt),
    };

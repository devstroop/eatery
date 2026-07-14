// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Subscription _$SubscriptionFromJson(Map<String, dynamic> json) =>
    _Subscription(
      id: (json['id'] as num?)?.toInt(),
      purchaseCode: json['purchaseCode'] as String?,
      validFrom: epochFromJsonNullable((json['validFrom'] as num?)?.toInt()),
      validTill: epochFromJsonNullable((json['validTill'] as num?)?.toInt()),
      subscriptionType:
          $enumDecodeNullable(
            _$SubscriptionTypeEnumMap,
            json['subscriptionType'],
          ) ??
          SubscriptionType.individual,
    );

Map<String, dynamic> _$SubscriptionToJson(_Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purchaseCode': instance.purchaseCode,
      'validFrom': epochToJsonNullable(instance.validFrom),
      'validTill': epochToJsonNullable(instance.validTill),
      'subscriptionType': _$SubscriptionTypeEnumMap[instance.subscriptionType],
    };

const _$SubscriptionTypeEnumMap = {
  SubscriptionType.individual: 0,
  SubscriptionType.business: 1,
};

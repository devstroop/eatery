// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_loyalty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerLoyalty _$CustomerLoyaltyFromJson(Map<String, dynamic> json) =>
    _CustomerLoyalty(
      id: (json['id'] as num?)?.toInt(),
      customerId: (json['customerId'] as num).toInt(),
      points: (json['points'] as num?)?.toDouble() ?? 0.0,
      totalVisits: (json['totalVisits'] as num?)?.toInt() ?? 0,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      lastVisitAt: epochFromJsonNullable(
        (json['lastVisitAt'] as num?)?.toInt(),
      ),
      tier: (json['tier'] as num?)?.toInt() ?? 0,
      createdAt: epochFromJson((json['createdAt'] as num).toInt()),
      updatedAt: epochFromJsonNullable((json['updatedAt'] as num?)?.toInt()),
    );

Map<String, dynamic> _$CustomerLoyaltyToJson(_CustomerLoyalty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'points': instance.points,
      'totalVisits': instance.totalVisits,
      'totalSpent': instance.totalSpent,
      'lastVisitAt': epochToJsonNullable(instance.lastVisitAt),
      'tier': instance.tier,
      'createdAt': epochToJson(instance.createdAt),
      'updatedAt': epochToJsonNullable(instance.updatedAt),
    };

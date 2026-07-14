// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderStatusHistory _$OrderStatusHistoryFromJson(Map<String, dynamic> json) =>
    _OrderStatusHistory(
      id: (json['id'] as num?)?.toInt(),
      orderId: (json['orderId'] as num).toInt(),
      fromStatus: (json['fromStatus'] as num).toInt(),
      toStatus: (json['toStatus'] as num).toInt(),
      changedByStaffId: (json['changedByStaffId'] as num?)?.toInt(),
      changedAt: epochFromJson((json['changedAt'] as num).toInt()),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$OrderStatusHistoryToJson(_OrderStatusHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'fromStatus': instance.fromStatus,
      'toStatus': instance.toStatus,
      'changedByStaffId': instance.changedByStaffId,
      'changedAt': epochToJson(instance.changedAt),
      'reason': instance.reason,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_adjustment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockAdjustment _$StockAdjustmentFromJson(Map<String, dynamic> json) =>
    _StockAdjustment(
      id: (json['id'] as num?)?.toInt(),
      productId: (json['productId'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
      reason: json['reason'] as String,
      referenceId: (json['referenceId'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      createdBy: (json['createdBy'] as num?)?.toInt(),
      createdAt: epochFromJson((json['createdAt'] as num).toInt()),
    );

Map<String, dynamic> _$StockAdjustmentToJson(_StockAdjustment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'reason': instance.reason,
      'referenceId': instance.referenceId,
      'notes': instance.notes,
      'createdBy': instance.createdBy,
      'createdAt': epochToJson(instance.createdAt),
    };

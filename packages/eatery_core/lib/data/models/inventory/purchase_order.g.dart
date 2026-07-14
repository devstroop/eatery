// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseOrder _$PurchaseOrderFromJson(Map<String, dynamic> json) =>
    _PurchaseOrder(
      id: (json['id'] as num?)?.toInt(),
      supplierId: (json['supplierId'] as num?)?.toInt(),
      orderDate: epochFromJson((json['orderDate'] as num).toInt()),
      expectedDate: epochFromJsonNullable(
        (json['expectedDate'] as num?)?.toInt(),
      ),
      deliveredDate: epochFromJsonNullable(
        (json['deliveredDate'] as num?)?.toInt(),
      ),
      status: (json['status'] as num?)?.toInt() ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      createdBy: (json['createdBy'] as num?)?.toInt(),
      createdAt: epochFromJson((json['createdAt'] as num).toInt()),
      updatedAt: epochFromJsonNullable((json['updatedAt'] as num?)?.toInt()),
    );

Map<String, dynamic> _$PurchaseOrderToJson(_PurchaseOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplierId': instance.supplierId,
      'orderDate': epochToJson(instance.orderDate),
      'expectedDate': epochToJsonNullable(instance.expectedDate),
      'deliveredDate': epochToJsonNullable(instance.deliveredDate),
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'notes': instance.notes,
      'createdBy': instance.createdBy,
      'createdAt': epochToJson(instance.createdAt),
      'updatedAt': epochToJsonNullable(instance.updatedAt),
    };

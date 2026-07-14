// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderProduct _$OrderProductFromJson(Map<String, dynamic> json) =>
    _OrderProduct(
      id: (json['id'] as num?)?.toInt(),
      orderId: (json['orderId'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      subTotal: (json['subTotal'] as num).toDouble(),
      discountRate: (json['discountRate'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      taxRate: (json['taxRate'] as num?)?.toDouble(),
      taxAmount: (json['taxAmount'] as num?)?.toDouble(),
      total: (json['total'] as num).toDouble(),
      stationId: (json['stationId'] as num?)?.toInt(),
      stationName: json['stationName'] as String?,
    );

Map<String, dynamic> _$OrderProductToJson(_OrderProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'price': instance.price,
      'subTotal': instance.subTotal,
      'discountRate': instance.discountRate,
      'discountAmount': instance.discountAmount,
      'taxRate': instance.taxRate,
      'taxAmount': instance.taxAmount,
      'total': instance.total,
      'stationId': instance.stationId,
      'stationName': instance.stationName,
    };

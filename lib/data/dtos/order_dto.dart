import 'base_dto.dart';
import 'product_dto.dart';
import 'payment_dto.dart';

class OrderDto extends BaseDto<OrderDto> {
  @override
  int get schemaVersion => 1;

  final String? id;
  final String? deviceId;
  final String? customerPhone;
  final String? customerName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int totalQuantity;
  final double subTotal;
  final double discountTotal;
  final double taxTotal;
  final double finalTotal;
  final double roundOff;
  final double grandTotal;
  final double? paidTotal;
  final String orderType;
  final String? diningTableName;
  final String? diningTableId;
  final String status;
  final String? voidReason;
  final String? voidedBy;
  final DateTime? voidedAt;
  final List<OrderProductDto> products;
  final List<PaymentDto> payments;

  OrderDto({
    this.id,
    this.deviceId,
    this.customerPhone,
    this.customerName,
    required this.createdAt,
    this.updatedAt,
    required this.totalQuantity,
    required this.subTotal,
    required this.discountTotal,
    required this.taxTotal,
    required this.finalTotal,
    required this.roundOff,
    required this.grandTotal,
    this.paidTotal,
    required this.orderType,
    this.diningTableName,
    this.diningTableId,
    this.status = 'pending',
    this.voidReason,
    this.voidedBy,
    this.voidedAt,
    this.products = const [],
    this.payments = const [],
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) {
    return OrderDto(
      id: json['id'] as String?,
      deviceId: json['deviceId'] as String?,
      customerPhone: json['customerPhone'] as String?,
      customerName: json['customerName'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
      totalQuantity: json['totalQuantity'] as int,
      subTotal: (json['subTotal'] as num).toDouble(),
      discountTotal: (json['discountTotal'] as num).toDouble(),
      taxTotal: (json['taxTotal'] as num).toDouble(),
      finalTotal: (json['finalTotal'] as num).toDouble(),
      roundOff: (json['roundOff'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      paidTotal: json['paidTotal'] != null
          ? (json['paidTotal'] as num).toDouble()
          : null,
      orderType: json['orderType'] as String,
      diningTableName: json['diningTableName'] as String?,
      diningTableId: json['diningTableId'] as String?,
      status: json['status'] as String? ?? 'active',
      voidReason: json['voidReason'] as String?,
      voidedBy: json['voidedBy'] as String?,
      voidedAt: json['voidedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['voidedAt'] as int)
          : null,
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => OrderProductDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      payments:
          (json['payments'] as List<dynamic>?)
              ?.map((e) => PaymentDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'id': id,
      'deviceId': deviceId,
      'customerPhone': customerPhone,
      'customerName': customerName,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'totalQuantity': totalQuantity,
      'subTotal': subTotal,
      'discountTotal': discountTotal,
      'taxTotal': taxTotal,
      'finalTotal': finalTotal,
      'roundOff': roundOff,
      'grandTotal': grandTotal,
      'paidTotal': paidTotal,
      'orderType': orderType,
      'diningTableName': diningTableName,
      'diningTableId': diningTableId,
      'status': status,
      'voidReason': voidReason,
      'voidedBy': voidedBy,
      'voidedAt': voidedAt?.millisecondsSinceEpoch,
      'products': products.map((e) => e.toJson()).toList(),
      'payments': payments.map((e) => e.toJson()).toList(),
    };
  }

  @override
  bool validate() {
    return grandTotal >= 0 && totalQuantity >= 0;
  }
}

class OrderProductDto extends BaseDto<OrderProductDto> {
  @override
  int get schemaVersion => 1;

  final String? id;
  final int? productId;
  final String productName;
  final int quantity;
  final double price;
  final double subTotal;
  final double? discountRate;
  final double? discountAmount;
  final double? taxRate;
  final double? taxAmount;
  final double total;
  final String? stationId;
  final String? stationName;

  OrderProductDto({
    this.id,
    this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subTotal,
    this.discountRate,
    this.discountAmount,
    this.taxRate,
    this.taxAmount,
    required this.total,
    this.stationId,
    this.stationName,
  });

  factory OrderProductDto.fromJson(Map<String, dynamic> json) {
    return OrderProductDto(
      id: json['id'] as String?,
      productId: json['productId'] as int?,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      subTotal: (json['subTotal'] as num).toDouble(),
      discountRate: json['discountRate'] != null
          ? (json['discountRate'] as num).toDouble()
          : null,
      discountAmount: json['discountAmount'] != null
          ? (json['discountAmount'] as num).toDouble()
          : null,
      taxRate: json['taxRate'] != null
          ? (json['taxRate'] as num).toDouble()
          : null,
      taxAmount: json['taxAmount'] != null
          ? (json['taxAmount'] as num).toDouble()
          : null,
      total: (json['total'] as num).toDouble(),
      stationId: json['stationId'] as String?,
      stationName: json['stationName'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'subTotal': subTotal,
      'discountRate': discountRate,
      'discountAmount': discountAmount,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'total': total,
      'stationId': stationId,
      'stationName': stationName,
    };
  }
}

import 'package:eatery/data/database/eatery_db_shim.dart';
import 'package:eatery/data/database/native/store_config.dart';

class OrderProduct {
  int? id;
  int? orderId;
  int? productId;
  String productName;
  int quantity;
  double price;
  double subTotal;
  double? discountRate;
  double? discountAmount;
  double? taxRate;
  double? taxAmount;
  double total;
  int? stationId;
  String? stationName;

  OrderProduct({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subTotal,
    this.taxRate,
    this.taxAmount,
    this.discountRate,
    this.discountAmount,
    required this.total,
    this.stationId,
    this.stationName,
  }) : id = kUseSqliteOrderStore
           ? null
           : EateryDB.instance.orderProductBox?.nextId();

  OrderProduct.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      orderId = map['orderId'],
      productId = map['productId'],
      productName = map['productName'],
      quantity = map['quantity'],
      price = map['price'],
      subTotal = map['subTotal'],
      taxRate = map['taxRate'],
      taxAmount = map['taxAmount'],
      discountRate = map['discountRate'],
      discountAmount = map['discountAmount'],
      total = map['total'],
      stationId = map['stationId'],
      stationName = map['stationName'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'subTotal': subTotal,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'discountRate': discountRate,
      'discountAmount': discountAmount,
      'total': total,
      'stationId': stationId,
      'stationName': stationName,
    };
  }
}

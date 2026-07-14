import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_product.freezed.dart';
part 'order_product.g.dart';

@freezed
abstract class OrderProduct with _$OrderProduct {
  const factory OrderProduct({
    int? id,
    required int? orderId,
    required int? productId,
    required String productName,
    required int quantity,
    required double price,
    required double subTotal,
    double? discountRate,
    double? discountAmount,
    double? taxRate,
    double? taxAmount,
    required double total,
    int? stationId,
    String? stationName,
    String? note,
    @Default(0) int status,
  }) = _OrderProduct;

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);

  static OrderProduct fromMap(Map<String, dynamic> map) =>
      OrderProduct.fromJson(map);
}

extension OrderProductX on OrderProduct {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  static OrderProduct fromIterable(Iterable<dynamic> row) {
    return OrderProduct.fromMap({
      'id': row.elementAt(0),
      'orderId': row.elementAt(1),
      'productId': row.elementAt(2),
      'productName': row.elementAt(3),
      'quantity': row.elementAt(4),
      'price': row.elementAt(5),
      'subTotal': row.elementAt(6),
      'discountRate': row.elementAt(7),
      'discountAmount': row.elementAt(8),
      'taxRate': row.elementAt(9),
      'taxAmount': row.elementAt(10),
      'total': row.elementAt(11),
      'stationId': row.elementAt(12),
      'stationName': row.elementAt(13),
      'note': row.elementAt(14),
      'status': row.elementAt(15),
    });
  }

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['orderId'],
      map['productId'],
      map['productName'],
      map['quantity'],
      map['price'],
      map['subTotal'],
      map['discountRate'],
      map['discountAmount'],
      map['taxRate'],
      map['taxAmount'],
      map['total'],
      map['stationId'],
      map['stationName'],
      map['note'],
      map['status'],
    ];
  }
}

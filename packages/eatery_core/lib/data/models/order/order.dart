import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/models/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    int? id,
    String? customerPhone,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? updatedAt,
    required int totalQuantity,
    required double subTotal,
    required double discountTotal,
    required double taxTotal,
    required double finalTotal,
    required double roundOff,
    required double grandTotal,
    double? paidTotal,
    required OrderType type,
    @Default('active') String status,
    String? voidReason,
    String? voidedBy,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? voidedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  static Order fromMap(Map<String, dynamic> map) => Order.fromJson(map);
}

extension OrderX on Order {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  static Order fromIterable(Iterable<dynamic> row) {
    return Order.fromMap({
      'id': row.elementAt(0),
      'customerPhone': row.elementAt(1),
      'createdAt': row.elementAt(2),
      'updatedAt': row.elementAt(3),
      'totalQuantity': row.elementAt(4),
      'subTotal': row.elementAt(5),
      'discountTotal': row.elementAt(6),
      'taxTotal': row.elementAt(7),
      'finalTotal': row.elementAt(8),
      'roundOff': row.elementAt(9),
      'grandTotal': row.elementAt(10),
      'paidTotal': row.elementAt(11),
      'type': row.elementAt(12),
      'status': row.elementAt(13),
      'voidReason': row.elementAt(14),
      'voidedBy': row.elementAt(15),
      'voidedAt': row.elementAt(16),
    });
  }

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['customerPhone'],
      map['createdAt'],
      map['updatedAt'],
      map['totalQuantity'],
      map['subTotal'],
      map['discountTotal'],
      map['taxTotal'],
      map['finalTotal'],
      map['roundOff'],
      map['grandTotal'],
      map['paidTotal'],
      map['type'],
      map['status'],
      map['voidReason'],
      map['voidedBy'],
      map['voidedAt'],
    ];
  }
}

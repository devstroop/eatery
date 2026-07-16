import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/models/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

int _statusToJson(OrderStatus s) => s.id;
OrderStatus _statusFromJson(Object? v) {
  if (v is int) return OrderStatus.fromId(v);
  if (v is String) return OrderStatus.fromString(v);
  return OrderStatus.pending;
}

@freezed
abstract class Order with _$Order {
  const factory Order({
    int? id,
    String? customerPhone,
    int? customerId,
    int? employeeId,
    int? companyId,
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
    @Default(OrderStatus.pending)
    @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
    OrderStatus status,
    String? voidReason,
    String? voidedBy,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? voidedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  static Order fromMap(Map<String, dynamic> map) => Order.fromJson(map);
}

extension OrderX on Order {
  Map<String, Object?> toMap() {
    final m = toJson() as Map<String, Object?>;
    m['status'] = status.id;
    return m;
  }

  static Order fromIterable(Iterable<dynamic> row) {
    return Order.fromMap({
      'id': row.elementAt(0),
      'customerPhone': row.elementAt(1),
      'customerId': row.elementAt(2),
      'employeeId': row.elementAt(3),
      'companyId': row.elementAt(4),
      'createdAt': row.elementAt(5),
      'updatedAt': row.elementAt(6),
      'totalQuantity': row.elementAt(7),
      'subTotal': row.elementAt(8),
      'discountTotal': row.elementAt(9),
      'taxTotal': row.elementAt(10),
      'finalTotal': row.elementAt(11),
      'roundOff': row.elementAt(12),
      'grandTotal': row.elementAt(13),
      'paidTotal': row.elementAt(14),
      'type': row.elementAt(15),
      'status': row.elementAt(16),
      'voidReason': row.elementAt(17),
      'voidedBy': row.elementAt(18),
      'voidedAt': row.elementAt(19),
    });
  }

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['customerPhone'],
      map['customerId'],
      map['employeeId'],
      map['companyId'],
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

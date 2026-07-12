import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/database/eatery_db_shim.dart';

part 'order.g.dart';

@HiveType(typeId: TypeIndex.order)
class Order extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? customerPhone;
  @HiveField(2)
  DateTime createdAt;
  @HiveField(3)
  DateTime? updatedAt;
  @HiveField(4)
  int totalQuantity;
  @HiveField(5)
  double subTotal;
  @HiveField(6)
  double discountTotal;
  @HiveField(7)
  double taxTotal;
  @HiveField(8)
  double finalTotal;
  @HiveField(9)
  double roundOff;
  @HiveField(10)
  double grandTotal;
  @HiveField(11)
  double? paidTotal;
  @HiveField(12)
  OrderType type;
  @HiveField(13)
  String status; // "active", "completed", "voided", "refunded"
  @HiveField(14)
  String? voidReason;
  @HiveField(15)
  String? voidedBy;
  @HiveField(16)
  DateTime? voidedAt;

  Order({
    this.customerPhone,
    required this.totalQuantity,
    required this.subTotal,
    required this.discountTotal,
    required this.taxTotal,
    required this.finalTotal,
    required this.roundOff,
    required this.grandTotal,
    this.paidTotal,
    required this.type,
    this.status = 'active',
    this.voidReason,
    this.voidedBy,
    this.voidedAt,
  })   : id = EateryDB.instance.orderBox?.nextId(),
        createdAt = DateTime.now();

  Order.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        customerPhone = map['customerPhone'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        updatedAt = map['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt']) : null,
        totalQuantity = map['totalQuantity'],
        subTotal = map['subTotal'],
        discountTotal = map['discountTotal'],
        taxTotal = map['taxTotal'],
        finalTotal = map['finalTotal'],
        roundOff = map['roundOff'],
        grandTotal = map['grandTotal'],
        paidTotal = map['paidTotal'],
        type = OrderType.values[map['type']],
        status = map['status'] ?? 'active',
        voidReason = map['voidReason'],
        voidedBy = map['voidedBy'],
        voidedAt = map['voidedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['voidedAt']) : null;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'customerPhone': customerPhone,
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
      'type': type.index,
      'status': status,
      'voidReason': voidReason,
      'voidedBy': voidedBy,
      'voidedAt': voidedAt?.millisecondsSinceEpoch,
    };
  }
}

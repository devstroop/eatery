import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/database/eatery_db_shim.dart';
import 'package:eatery_core/data/database/native/store_config.dart';

class Order {
  int? id;
  String? customerPhone;
  DateTime createdAt;
  DateTime? updatedAt;
  int totalQuantity;
  double subTotal;
  double discountTotal;
  double taxTotal;
  double finalTotal;
  double roundOff;
  double grandTotal;
  double? paidTotal;
  OrderType type;
  String status; // "active", "completed", "voided", "refunded"
  String? voidReason;
  String? voidedBy;
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
  }) : id = kUseSqliteOrderStore ? null : EateryDB.instance.orderBox?.nextId(),
       createdAt = DateTime.now();

  Order.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      customerPhone = map['customerPhone'],
      createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt = map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
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
      voidedAt = map['voidedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['voidedAt'])
          : null;

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

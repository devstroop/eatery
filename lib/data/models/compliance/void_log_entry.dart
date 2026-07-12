import 'package:eatery/data/models/eatery_db.dart';

part 'void_log_entry.g.dart';

@HiveType(typeId: TypeIndex.voidLogEntry)
class VoidLogEntry extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int orderId;
  @HiveField(2)
  DateTime voidedAt;
  @HiveField(3)
  String voidedBy;
  @HiveField(4)
  String reasonCode;
  @HiveField(5)
  String? reasonDescription;
  @HiveField(6)
  double amount;
  @HiveField(7)
  String? orderReference;

  VoidLogEntry({
    required this.orderId,
    required this.voidedAt,
    required this.voidedBy,
    required this.reasonCode,
    this.reasonDescription,
    required this.amount,
    this.orderReference,
  });

  VoidLogEntry.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        orderId = map['orderId'],
        voidedAt = DateTime.fromMillisecondsSinceEpoch(map['voidedAt']),
        voidedBy = map['voidedBy'],
        reasonCode = map['reasonCode'],
        reasonDescription = map['reasonDescription'],
        amount = (map['amount'] as num).toDouble(),
        orderReference = map['orderReference'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'voidedAt': voidedAt.millisecondsSinceEpoch,
      'voidedBy': voidedBy,
      'reasonCode': reasonCode,
      'reasonDescription': reasonDescription,
      'amount': amount,
      'orderReference': orderReference,
    };
  }
}

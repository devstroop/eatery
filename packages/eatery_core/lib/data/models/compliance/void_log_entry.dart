class VoidLogEntry {
  int? id;
  int orderId;
  DateTime voidedAt;
  String voidedBy;
  String reasonCode;
  String? reasonDescription;
  double amount;
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

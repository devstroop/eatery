import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/database/eatery_db_shim.dart';
import 'package:eatery_core/data/database/native/store_config.dart';

class Payment {
  int? id;
  int? orderId;
  DateTime date;
  double amount;
  PaymentMode mode;
  String? reference;
  String? attachment;
  String? processorTransactionId;
  String? processorName;
  String? processorStatus;
  String? cardLastFour;
  String? terminalId;

  Payment({
    this.orderId,
    required this.amount,
    required this.mode,
    this.reference,
    this.attachment,
    this.processorTransactionId,
    this.processorName,
    this.processorStatus,
    this.cardLastFour,
    this.terminalId,
  }) : id = kUseSqlitePaymentStore
           ? null
           : EateryDB.instance.paymentBox?.nextId(),
       date = DateTime.now();

  Payment.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      orderId = map['orderId'],
      date = DateTime.fromMillisecondsSinceEpoch(map['date']),
      amount = map['amount'],
      mode = PaymentMode.values[map['mode']],
      reference = map['reference'],
      attachment = map['attachment'],
      processorTransactionId = map['processorTransactionId'],
      processorName = map['processorName'],
      processorStatus = map['processorStatus'],
      cardLastFour = map['cardLastFour'],
      terminalId = map['terminalId'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'mode': mode.index,
      'reference': reference,
      'attachment': attachment,
      'processorTransactionId': processorTransactionId,
      'processorName': processorName,
      'processorStatus': processorStatus,
      'cardLastFour': cardLastFour,
      'terminalId': terminalId,
    };
  }

  static Payment fromIterable(Iterable<dynamic> row) {
    return Payment.fromMap({
      'id': row.elementAt(0),
      'order': row.elementAt(1),
      'date': row.elementAt(2),
      'amount': row.elementAt(3),
      'mode': row.elementAt(4),
      'reference': row.elementAt(5),
      'attachment': row.elementAt(6),
      'processorTransactionId': row.elementAt(7),
      'processorName': row.elementAt(8),
      'processorStatus': row.elementAt(9),
      'cardLastFour': row.elementAt(10),
      'terminalId': row.elementAt(11),
    });
  }

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['order'],
      map['date'],
      map['amount'],
      map['mode'],
      map['reference'],
      map['attachment'],
      map['processorTransactionId'],
      map['processorName'],
      map['processorStatus'],
      map['cardLastFour'],
      map['terminalId'],
    ];
  }
}

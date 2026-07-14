import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/models/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    int? id,
    int? orderId,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime date,
    required double amount,
    required PaymentMode mode,
    String? reference,
    String? attachment,
    String? processorTransactionId,
    String? processorName,
    String? processorStatus,
    String? cardLastFour,
    String? terminalId,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  static Payment fromMap(Map<String, dynamic> map) => Payment.fromJson(map);

  static Payment fromIterable(Iterable<dynamic> row) {
    return Payment.fromMap({
      'id': row.elementAt(0),
      'orderId': row.elementAt(1),
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
}

extension PaymentX on Payment {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['orderId'],
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

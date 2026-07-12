import 'base_dto.dart';

class PaymentDto extends BaseDto<PaymentDto> {
  @override
  int get schemaVersion => 1;

  final String? id;
  final String? orderId;
  final DateTime date;
  final double amount;
  final String mode;
  final String? reference;
  final String? attachment;
  final String? processorTransactionId;
  final String? processorName;
  final String? processorStatus;
  final String? cardLastFour;
  final String? terminalId;

  PaymentDto({
    this.id,
    this.orderId,
    required this.date,
    required this.amount,
    required this.mode,
    this.reference,
    this.attachment,
    this.processorTransactionId,
    this.processorName,
    this.processorStatus,
    this.cardLastFour,
    this.terminalId,
  });

  factory PaymentDto.fromJson(Map<String, dynamic> json) {
    return PaymentDto(
      id: json['id'] as String?,
      orderId: json['orderId'] as String?,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      amount: (json['amount'] as num).toDouble(),
      mode: json['mode'] as String,
      reference: json['reference'] as String?,
      attachment: json['attachment'] as String?,
      processorTransactionId: json['processorTransactionId'] as String?,
      processorName: json['processorName'] as String?,
      processorStatus: json['processorStatus'] as String?,
      cardLastFour: json['cardLastFour'] as String?,
      terminalId: json['terminalId'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'id': id,
      'orderId': orderId,
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'mode': mode,
      'reference': reference,
      'attachment': attachment,
      'processorTransactionId': processorTransactionId,
      'processorName': processorName,
      'processorStatus': processorStatus,
      'cardLastFour': cardLastFour,
      'terminalId': terminalId,
    };
  }
}

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum PaymentMode {
  @JsonValue(0)
  cash,
  @JsonValue(1)
  card,
  @JsonValue(2)
  upi,
  @JsonValue(3)
  wallet,
  @JsonValue(4)
  other,
}

extension PaymentModeExtension on PaymentMode {
  String get name {
    switch (this) {
      case PaymentMode.cash:
        return 'Cash';
      case PaymentMode.card:
        return 'Card';
      case PaymentMode.upi:
        return 'UPI';
      case PaymentMode.wallet:
        return 'Wallet';
      case PaymentMode.other:
        return 'Other';
    }
  }
}

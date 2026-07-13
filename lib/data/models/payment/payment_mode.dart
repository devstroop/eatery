enum PaymentMode { cash, card, upi, wallet, other }

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
      default:
        return 'Unknown';
    }
  }
}

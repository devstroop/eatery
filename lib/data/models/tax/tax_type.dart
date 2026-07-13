enum TaxType { inclusive, exclusive }

extension TaxTypeExtension on TaxType {
  int? get id {
    switch (this) {
      case TaxType.inclusive:
        return 0;
      case TaxType.exclusive:
        return 1;
      default:
        return null;
    }
  }

  String? get name {
    switch (this) {
      case TaxType.inclusive:
        return "Inclusive";
      case TaxType.exclusive:
        return "Exclusive";
      default:
        return null;
    }
  }

  String? get description {
    switch (this) {
      case TaxType.inclusive:
        return 'Tax Inclusive rates will always include tax in the total that you see in the unit price';
      case TaxType.exclusive:
        return 'Tax Exclusive rates will be excluding the tax that will be added at the point of purchase';
      default:
        return null;
    }
  }
}

class License {
  final String purchaseCode;
  License({required this.purchaseCode});
  DateTime? validFrom;
  DateTime? validTill;

  void validate(Function(DateTime? validFrom, DateTime? validTill)? callback) {
    if (purchaseCode == "12345678") {
      validFrom = DateTime.now();
      validTill = DateTime.now().add(const Duration(days: 365));
    }
    if (callback != null) {
      callback(validFrom, validTill);
    }
  }
}

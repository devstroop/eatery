class ComplianceReport {
  int? id;
  String reportType; // "Z", "X"
  DateTime generatedAt;
  String generatedBy;
  DateTime periodStart;
  DateTime periodEnd;
  String reportNumber;
  double grossSales;
  double netSales;
  double taxCollected;
  int transactionCount;
  double averageTicket;
  double totalDiscounts;
  int discountCount;
  int voidCount;
  double voidAmount;
  int refundCount;
  double refundAmount;
  double openingBalance;
  double closingBalance;
  double? expectedCash;
  double? actualCash;
  double? cashVariance;
  String? paymentBreakdownJson; // JSON-encoded Map<String, double>
  String? taxBreakdownJson; // JSON-encoded list of tax lines

  ComplianceReport({
    required this.reportType,
    required this.generatedAt,
    required this.generatedBy,
    required this.periodStart,
    required this.periodEnd,
    required this.reportNumber,
    required this.grossSales,
    required this.netSales,
    required this.taxCollected,
    required this.transactionCount,
    required this.averageTicket,
    this.totalDiscounts = 0,
    this.discountCount = 0,
    this.voidCount = 0,
    this.voidAmount = 0,
    this.refundCount = 0,
    this.refundAmount = 0,
    required this.openingBalance,
    required this.closingBalance,
    this.expectedCash,
    this.actualCash,
    this.cashVariance,
    this.paymentBreakdownJson,
    this.taxBreakdownJson,
  });

  ComplianceReport.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      reportType = map['reportType'],
      generatedAt = DateTime.fromMillisecondsSinceEpoch(map['generatedAt']),
      generatedBy = map['generatedBy'],
      periodStart = DateTime.fromMillisecondsSinceEpoch(map['periodStart']),
      periodEnd = DateTime.fromMillisecondsSinceEpoch(map['periodEnd']),
      reportNumber = map['reportNumber'],
      grossSales = (map['grossSales'] as num).toDouble(),
      netSales = (map['netSales'] as num).toDouble(),
      taxCollected = (map['taxCollected'] as num).toDouble(),
      transactionCount = map['transactionCount'],
      averageTicket = (map['averageTicket'] as num).toDouble(),
      totalDiscounts = (map['totalDiscounts'] as num?)?.toDouble() ?? 0,
      discountCount = map['discountCount'] ?? 0,
      voidCount = map['voidCount'] ?? 0,
      voidAmount = (map['voidAmount'] as num?)?.toDouble() ?? 0,
      refundCount = map['refundCount'] ?? 0,
      refundAmount = (map['refundAmount'] as num?)?.toDouble() ?? 0,
      openingBalance = (map['openingBalance'] as num).toDouble(),
      closingBalance = (map['closingBalance'] as num).toDouble(),
      expectedCash = (map['expectedCash'] as num?)?.toDouble(),
      actualCash = (map['actualCash'] as num?)?.toDouble(),
      cashVariance = (map['cashVariance'] as num?)?.toDouble(),
      paymentBreakdownJson = map['paymentBreakdownJson'],
      taxBreakdownJson = map['taxBreakdownJson'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'reportType': reportType,
      'generatedAt': generatedAt.millisecondsSinceEpoch,
      'generatedBy': generatedBy,
      'periodStart': periodStart.millisecondsSinceEpoch,
      'periodEnd': periodEnd.millisecondsSinceEpoch,
      'reportNumber': reportNumber,
      'grossSales': grossSales,
      'netSales': netSales,
      'taxCollected': taxCollected,
      'transactionCount': transactionCount,
      'averageTicket': averageTicket,
      'totalDiscounts': totalDiscounts,
      'discountCount': discountCount,
      'voidCount': voidCount,
      'voidAmount': voidAmount,
      'refundCount': refundCount,
      'refundAmount': refundAmount,
      'openingBalance': openingBalance,
      'closingBalance': closingBalance,
      'expectedCash': expectedCash,
      'actualCash': actualCash,
      'cashVariance': cashVariance,
      'paymentBreakdownJson': paymentBreakdownJson,
      'taxBreakdownJson': taxBreakdownJson,
    };
  }
}

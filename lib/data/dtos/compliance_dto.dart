import 'base_dto.dart';

class ZReportDto extends BaseDto<ZReportDto> {
  @override
  int get schemaVersion => 1;

  final String id;
  final DateTime generatedAt;
  final String generatedBy;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String reportNumber;

  // Sales summary
  final double grossSales;
  final double netSales;
  final double taxCollected;
  final int transactionCount;
  final double averageTicket;

  // Payment breakdown
  final Map<String, double> paymentModeTotals;

  // Tax breakdown
  final List<TaxLineDto> taxLines;

  // Discounts
  final double totalDiscounts;
  final int discountCount;

  // Voids
  final int voidCount;
  final double voidAmount;
  final List<VoidLogEntryDto> voids;

  // Refunds
  final int refundCount;
  final double refundAmount;

  // Opening / closing balances
  final double openingBalance;
  final double closingBalance;
  final double? expectedCash;
  final double? actualCash;
  final double? cashVariance;

  ZReportDto({
    required this.id,
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
    required this.paymentModeTotals,
    required this.taxLines,
    required this.totalDiscounts,
    required this.discountCount,
    required this.voidCount,
    required this.voidAmount,
    required this.voids,
    required this.refundCount,
    required this.refundAmount,
    required this.openingBalance,
    required this.closingBalance,
    this.expectedCash,
    this.actualCash,
    this.cashVariance,
  });

  factory ZReportDto.fromJson(Map<String, dynamic> json) {
    return ZReportDto(
      id: json['id'] as String,
      generatedAt: DateTime.fromMillisecondsSinceEpoch(json['generatedAt'] as int),
      generatedBy: json['generatedBy'] as String,
      periodStart: DateTime.fromMillisecondsSinceEpoch(json['periodStart'] as int),
      periodEnd: DateTime.fromMillisecondsSinceEpoch(json['periodEnd'] as int),
      reportNumber: json['reportNumber'] as String,
      grossSales: (json['grossSales'] as num).toDouble(),
      netSales: (json['netSales'] as num).toDouble(),
      taxCollected: (json['taxCollected'] as num).toDouble(),
      transactionCount: json['transactionCount'] as int,
      averageTicket: (json['averageTicket'] as num).toDouble(),
      paymentModeTotals: Map<String, double>.from(
        (json['paymentModeTotals'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      ),
      taxLines: (json['taxLines'] as List<dynamic>)
          .map((e) => TaxLineDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDiscounts: (json['totalDiscounts'] as num).toDouble(),
      discountCount: json['discountCount'] as int,
      voidCount: json['voidCount'] as int,
      voidAmount: (json['voidAmount'] as num).toDouble(),
      voids: (json['voids'] as List<dynamic>)
          .map((e) => VoidLogEntryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      refundCount: json['refundCount'] as int,
      refundAmount: (json['refundAmount'] as num).toDouble(),
      openingBalance: (json['openingBalance'] as num).toDouble(),
      closingBalance: (json['closingBalance'] as num).toDouble(),
      expectedCash: json['expectedCash'] != null
          ? (json['expectedCash'] as num).toDouble()
          : null,
      actualCash: json['actualCash'] != null
          ? (json['actualCash'] as num).toDouble()
          : null,
      cashVariance: json['cashVariance'] != null
          ? (json['cashVariance'] as num).toDouble()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'id': id,
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
      'paymentModeTotals': paymentModeTotals,
      'taxLines': taxLines.map((e) => e.toJson()).toList(),
      'totalDiscounts': totalDiscounts,
      'discountCount': discountCount,
      'voidCount': voidCount,
      'voidAmount': voidAmount,
      'voids': voids.map((e) => e.toJson()).toList(),
      'refundCount': refundCount,
      'refundAmount': refundAmount,
      'openingBalance': openingBalance,
      'closingBalance': closingBalance,
      'expectedCash': expectedCash,
      'actualCash': actualCash,
      'cashVariance': cashVariance,
    };
  }
}

class TaxLineDto extends BaseDto<TaxLineDto> {
  @override
  int get schemaVersion => 1;

  final String name;
  final double rate;
  final double taxableAmount;
  final double taxAmount;

  TaxLineDto({
    required this.name,
    required this.rate,
    required this.taxableAmount,
    required this.taxAmount,
  });

  factory TaxLineDto.fromJson(Map<String, dynamic> json) {
    return TaxLineDto(
      name: json['name'] as String,
      rate: (json['rate'] as num).toDouble(),
      taxableAmount: (json['taxableAmount'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'name': name,
      'rate': rate,
      'taxableAmount': taxableAmount,
      'taxAmount': taxAmount,
    };
  }
}

class VoidLogEntryDto extends BaseDto<VoidLogEntryDto> {
  @override
  int get schemaVersion => 1;

  final String orderId;
  final DateTime voidedAt;
  final String voidedBy;
  final String reasonCode;
  final String? reasonDescription;
  final double amount;

  VoidLogEntryDto({
    required this.orderId,
    required this.voidedAt,
    required this.voidedBy,
    required this.reasonCode,
    this.reasonDescription,
    required this.amount,
  });

  factory VoidLogEntryDto.fromJson(Map<String, dynamic> json) {
    return VoidLogEntryDto(
      orderId: json['orderId'] as String,
      voidedAt: DateTime.fromMillisecondsSinceEpoch(json['voidedAt'] as int),
      voidedBy: json['voidedBy'] as String,
      reasonCode: json['reasonCode'] as String,
      reasonDescription: json['reasonDescription'] as String?,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'orderId': orderId,
      'voidedAt': voidedAt.millisecondsSinceEpoch,
      'voidedBy': voidedBy,
      'reasonCode': reasonCode,
      'reasonDescription': reasonDescription,
      'amount': amount,
    };
  }
}

class XReportDto extends BaseDto<XReportDto> {
  @override
  int get schemaVersion => 1;

  final String id;
  final DateTime generatedAt;
  final String generatedBy;
  final DateTime periodStart;

  final double grossSales;
  final double netSales;
  final double taxCollected;
  final int transactionCount;
  final int activeTables;
  final int pendingOrders;
  final Map<String, double> paymentModeTotals;

  XReportDto({
    required this.id,
    required this.generatedAt,
    required this.generatedBy,
    required this.periodStart,
    required this.grossSales,
    required this.netSales,
    required this.taxCollected,
    required this.transactionCount,
    required this.activeTables,
    required this.pendingOrders,
    required this.paymentModeTotals,
  });

  factory XReportDto.fromJson(Map<String, dynamic> json) {
    return XReportDto(
      id: json['id'] as String,
      generatedAt: DateTime.fromMillisecondsSinceEpoch(json['generatedAt'] as int),
      generatedBy: json['generatedBy'] as String,
      periodStart: DateTime.fromMillisecondsSinceEpoch(json['periodStart'] as int),
      grossSales: (json['grossSales'] as num).toDouble(),
      netSales: (json['netSales'] as num).toDouble(),
      taxCollected: (json['taxCollected'] as num).toDouble(),
      transactionCount: json['transactionCount'] as int,
      activeTables: json['activeTables'] as int,
      pendingOrders: json['pendingOrders'] as int,
      paymentModeTotals: Map<String, double>.from(
        (json['paymentModeTotals'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'id': id,
      'generatedAt': generatedAt.millisecondsSinceEpoch,
      'generatedBy': generatedBy,
      'periodStart': periodStart.millisecondsSinceEpoch,
      'grossSales': grossSales,
      'netSales': netSales,
      'taxCollected': taxCollected,
      'transactionCount': transactionCount,
      'activeTables': activeTables,
      'pendingOrders': pendingOrders,
      'paymentModeTotals': paymentModeTotals,
    };
  }
}

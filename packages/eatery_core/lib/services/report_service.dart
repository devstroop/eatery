import 'dart:convert';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/models/eatery_db.dart';

/// Aggregates sales data for Z (end-of-day) and X (mid-day) reports.
class ReportService {
  final EateryStore _store;

  ReportService(this._store);

  /// Generates a compliance report for the given period.
  ComplianceReport generateReport({
    required String reportType,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String generatedBy,
    double? expectedCash,
    double? actualCash,
  }) {
    final startMs = periodStart.millisecondsSinceEpoch;
    final endMs = periodEnd.millisecondsSinceEpoch;

    // Total gross sales (sum of completed/active orders)
    final grossResult = _store.queryScalar('''
      SELECT COALESCE(SUM(grandTotal), 0) FROM orders
      WHERE createdAt >= ? AND createdAt <= ?
      AND status IN (0, 1, 2, 3, 4)
    ''', [startMs, endMs]);
    final grossSales = (grossResult as num).toDouble();

    // Net sales (gross - voided - refunded)
    final voidResult = _store.queryScalar('''
      SELECT COALESCE(SUM(grandTotal), 0) FROM orders
      WHERE createdAt >= ? AND createdAt <= ? AND status = 5
    ''', [startMs, endMs]);
    final voidAmount = (voidResult as num).toDouble();

    // Tax collected
    final taxResult = _store.queryScalar('''
      SELECT COALESCE(SUM(taxTotal), 0) FROM orders
      WHERE createdAt >= ? AND createdAt <= ?
    ''', [startMs, endMs]);
    final taxCollected = (taxResult as num).toDouble();

    // Transaction count
    final txnResult = _store.queryScalar('''
      SELECT COUNT(*) FROM orders
      WHERE createdAt >= ? AND createdAt <= ?
    ''', [startMs, endMs]);
    final transactionCount = (txnResult as int);

    // Total discounts
    final discResult = _store.queryScalar('''
      SELECT COALESCE(SUM(discountTotal), 0) FROM orders
      WHERE createdAt >= ? AND createdAt <= ?
    ''', [startMs, endMs]);
    final totalDiscounts = (discResult as num).toDouble();

    // Void count
    final voidCountResult = _store.queryScalar('''
      SELECT COUNT(*) FROM orders
      WHERE createdAt >= ? AND createdAt <= ? AND status = 5
    ''', [startMs, endMs]);
    final voidCount = (voidCountResult as int);

    // Payment breakdown by mode
    final paymentRows = _store.query('''
      SELECT mode, COALESCE(SUM(amount), 0) as total
      FROM payment
      WHERE date >= ? AND date <= ?
      GROUP BY mode
    ''', [startMs, endMs]);
    final paymentBreakdown = {
      for (final row in paymentRows)
        PaymentMode.values.firstWhere(
          (e) => e.index == (row['mode'] as int),
          orElse: () => PaymentMode.other,
        ).name: (row['total'] as num).toDouble(),
    };

    final netSales = grossSales - voidAmount;
    final avgTicket = transactionCount > 0 ? grossSales / transactionCount : 0.0;
    final openingBalance = _openingBalance(startMs);
    final closingBalance = openingBalance + grossSales;

    final report = ComplianceReport(
      reportType: reportType,
      generatedAt: DateTime.now(),
      generatedBy: generatedBy,
      periodStart: periodStart,
      periodEnd: periodEnd,
      reportNumber: '${reportType.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}',
      grossSales: grossSales,
      netSales: netSales,
      taxCollected: taxCollected,
      transactionCount: transactionCount,
      averageTicket: avgTicket,
      totalDiscounts: totalDiscounts,
      voidCount: voidCount,
      voidAmount: voidAmount,
      openingBalance: openingBalance,
      closingBalance: closingBalance,
      expectedCash: expectedCash,
      actualCash: actualCash,
      cashVariance: actualCash != null && expectedCash != null
          ? actualCash - expectedCash
          : null,
      paymentBreakdownJson: jsonEncode(paymentBreakdown),
    );

    // Persist the report
    _store.execute('''
      INSERT INTO compliance_report
      (reportType, generatedAt, generatedBy, periodStart, periodEnd,
       reportNumber, grossSales, netSales, taxCollected, transactionCount,
       averageTicket, totalDiscounts, discountCount, voidCount, voidAmount,
       refundCount, refundAmount, openingBalance, closingBalance,
       expectedCash, actualCash, cashVariance, paymentBreakdownJson, taxBreakdownJson)
      VALUES (?,?,?,?,?,?,?,?,?,?,?,?,0,?,?,0,0,?,?,?,?,?,?,NULL)
    ''', [
      report.reportType,
      report.generatedAt.millisecondsSinceEpoch,
      report.generatedBy,
      report.periodStart.millisecondsSinceEpoch,
      report.periodEnd.millisecondsSinceEpoch,
      report.reportNumber,
      report.grossSales,
      report.netSales,
      report.taxCollected,
      report.transactionCount,
      report.averageTicket,
      report.totalDiscounts,
      report.voidCount,
      report.voidAmount,
      report.openingBalance,
      report.closingBalance,
      report.expectedCash,
      report.actualCash,
      report.cashVariance,
      report.paymentBreakdownJson,
    ]);

    return report;
  }

  double _openingBalance(int periodStartMs) {
    final result = _store.queryScalar('''
      SELECT COALESCE(SUM(grandTotal), 0) FROM orders
      WHERE createdAt < ?
    ''', [periodStartMs]);
    return (result as num).toDouble();
  }

  /// Returns all previously generated reports.
  List<ComplianceReport> getReports() =>
      _store.query('SELECT * FROM compliance_report ORDER BY generatedAt DESC')
          .map(ComplianceReport.fromMap).toList();
}

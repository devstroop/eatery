import 'dart:async';
import 'dart:convert';
import 'package:eatery_core/data/database/native/eatery_store_isolate.dart';
import 'package:eatery_core/data/models/eatery_db.dart';

/// Aggregates sales data for Z (end-of-day) and X (mid-day) reports.
///
/// Uses [EateryStoreIsolate] so heavy aggregate queries run off the
/// main (UI) thread — no jank during report generation.
class ReportService {
  final EateryStoreIsolate _store;

  ReportService(this._store);

  /// Generates a compliance report for the given period.
  Future<ComplianceReport> generateReport({
    required String reportType,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String generatedBy,
    double? expectedCash,
    double? actualCash,
  }) async {
    final startMs = periodStart.millisecondsSinceEpoch;
    final endMs = periodEnd.millisecondsSinceEpoch;

    final grossSales = await _queryGrossSum(startMs, endMs, [0, 1, 2, 3, 4]);
    final voidAmount = await _queryGrossSum(startMs, endMs, [5]);
    final taxCollected = await _queryTaxSum(startMs, endMs);
    final transactionCount = await _queryCount(startMs, endMs);
    final totalDiscounts = await _queryDiscountSum(startMs, endMs);
    final voidCount = await _queryCount(startMs, endMs, status: 5);
    final discountCount = await _queryDiscountCount(startMs, endMs);
    final paymentRows = await _store.query(
      '''
      SELECT mode, COALESCE(SUM(amount), 0) as total
      FROM payment
      WHERE date >= ? AND date <= ?
      GROUP BY mode
    ''',
      [startMs, endMs],
    );
    final openingBalance = await _openingBalance(startMs);

    final netSales = grossSales - voidAmount;
    final avgTicket = transactionCount > 0
        ? grossSales / transactionCount
        : 0.0;
    final closingBalance = openingBalance + grossSales;

    final paymentBreakdown = {
      for (final row in paymentRows)
        PaymentMode.values
            .firstWhere(
              (e) => e.index == (row['mode'] as int),
              orElse: () => PaymentMode.other,
            )
            .name: (row['total'] as num)
            .toDouble(),
    };

    final report = ComplianceReport(
      reportType: reportType,
      generatedAt: DateTime.now(),
      generatedBy: generatedBy,
      periodStart: periodStart,
      periodEnd: periodEnd,
      reportNumber:
          '${reportType.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}',
      grossSales: grossSales,
      netSales: netSales,
      taxCollected: taxCollected,
      transactionCount: transactionCount,
      averageTicket: avgTicket,
      totalDiscounts: totalDiscounts,
      discountCount: discountCount,
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

    await _store.execute(
      '''
      INSERT INTO compliance_report
      (reportType, generatedAt, generatedBy, periodStart, periodEnd,
       reportNumber, grossSales, netSales, taxCollected, transactionCount,
       averageTicket, totalDiscounts, discountCount, voidCount, voidAmount,
       refundCount, refundAmount, openingBalance, closingBalance,
       expectedCash, actualCash, cashVariance, paymentBreakdownJson, taxBreakdownJson)
      VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''',
      [
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
        report.discountCount,
        report.voidCount,
        report.voidAmount,
        report.refundCount,
        report.refundAmount,
        report.openingBalance,
        report.closingBalance,
        report.expectedCash,
        report.actualCash,
        report.cashVariance,
        report.paymentBreakdownJson,
        report.taxBreakdownJson,
      ],
    );

    return report;
  }

  Future<double> _queryGrossSum(
    int startMs,
    int endMs,
    List<int> statuses,
  ) async {
    if (statuses.isEmpty) {
      throw ArgumentError('statuses must not be empty �� produces invalid SQL');
    }
    final placeholders = statuses.map((_) => '?').join(', ');
    final result = await _store.queryScalar(
      'SELECT COALESCE(SUM(grandTotal), 0) FROM orders '
      'WHERE createdAt >= ? AND createdAt <= ? AND status IN ($placeholders)',
      [startMs, endMs, ...statuses],
    );
    return (result as num).toDouble();
  }

  Future<double> _queryTaxSum(int startMs, int endMs) async {
    final result = await _store.queryScalar(
      'SELECT COALESCE(SUM(taxTotal), 0) FROM orders '
      'WHERE createdAt >= ? AND createdAt <= ?',
      [startMs, endMs],
    );
    return (result as num).toDouble();
  }

  Future<int> _queryCount(int startMs, int endMs, {int? status}) async {
    if (status != null) {
      final result = await _store.queryScalar(
        'SELECT COUNT(*) FROM orders WHERE createdAt >= ? AND createdAt <= ? AND status = ?',
        [startMs, endMs, status],
      );
      return result as int;
    }
    final result = await _store.queryScalar(
      'SELECT COUNT(*) FROM orders WHERE createdAt >= ? AND createdAt <= ?',
      [startMs, endMs],
    );
    return result as int;
  }

  Future<double> _queryDiscountSum(int startMs, int endMs) async {
    final result = await _store.queryScalar(
      'SELECT COALESCE(SUM(discountTotal), 0) FROM orders '
      'WHERE createdAt >= ? AND createdAt <= ?',
      [startMs, endMs],
    );
    return (result as num).toDouble();
  }

  Future<int> _queryDiscountCount(int startMs, int endMs) async {
    final result = await _store.queryScalar(
      'SELECT COUNT(*) FROM orders WHERE discountTotal > 0 '
      'AND createdAt >= ? AND createdAt <= ?',
      [startMs, endMs],
    );
    return (result as int);
  }

  Future<double> _openingBalance(int periodStartMs) async {
    final result = await _store.queryScalar(
      'SELECT COALESCE(SUM(grandTotal), 0) FROM orders WHERE createdAt < ?',
      [periodStartMs],
    );
    return (result as num).toDouble();
  }

  /// Returns all previously generated reports.
  Future<List<ComplianceReport>> getReports() async {
    final rows = await _store.query(
      'SELECT * FROM compliance_report ORDER BY generatedAt DESC',
    );
    return rows.map(ComplianceReport.fromMap).toList();
  }
}

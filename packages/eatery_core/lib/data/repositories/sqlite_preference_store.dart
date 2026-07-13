import 'package:eatery_core/data/models/eatery_db.dart';
import '../database/native/eatery_store.dart';

/// A generic SQLite-backed holder for singleton/preference-style entities that
/// don't have dedicated repository interfaces. Pages read/write them through
/// the EateryDatabase shim; this provides the SQLite path.
///
/// Each type here has a corresponding table in the schema but is rarely
/// queried — typically loaded as a singleton list or single row.
class SqlitePreferenceStore {
  SqlitePreferenceStore({required EateryStore store}) : _store = store;
  final EateryStore _store;

  // ── AutoPrint ──────────────────────────────────────────────────────────

  List<AutoPrint> getAllAutoPrint() =>
      _store.query('SELECT * FROM auto_print').map(_toAutoPrint).toList();

  void saveAutoPrint(AutoPrint ap) {
    final m = ap.toMap();
    _store.execute(
      '''
      INSERT OR REPLACE INTO auto_print
        (id, invoicePrint, kotPrint, invoicePrinterId, kotPrinterId)
      VALUES (?,?,?,?,?)
    ''',
      [
        m['id'] ?? 1,
        m['invoicePrint'],
        m['kotPrint'],
        m['invoicePrinterId'],
        m['kotPrinterId'],
      ],
    );
  }

  AutoPrint _toAutoPrint(Map<String, Object?> row) => AutoPrint(
    invoicePrintEnabled: (row['invoicePrint'] as int?) == 1,
    kotPrintEnabled: (row['kotPrint'] as int?) == 1,
    invoicePrinterId: row['invoicePrinterId'] as int?,
    kotPrinterId: row['kotPrinterId'] as int?,
  )..id = row['id'] as int;

  // ── KdsStation ─────────────────────────────────────────────────────────

  List<KdsStation> getAllKdsStations() =>
      _store.query('SELECT * FROM kds_station').map(_toKdsStation).toList();

  KdsStation _toKdsStation(Map<String, Object?> row) => KdsStation(
    name: row['name'] as String,
    description: row['description'] as String?,
    sortOrder: (row['sortOrder'] as int?) ?? 0,
    isActive: (row['isActive'] as int) == 1,
  )..id = row['id'] as int;

  // ── ComplianceReport ───────────────────────────────────────────────────

  List<ComplianceReport> getAllComplianceReports() => _store
      .query('SELECT * FROM compliance_report ORDER BY id DESC')
      .map(_toComplianceReport)
      .toList();

  void saveComplianceReport(ComplianceReport cr) {
    final m = cr.toMap();
    final values = <Object?>[
      m['reportType'],
      m['generatedAt'],
      m['generatedBy'],
      m['periodStart'],
      m['periodEnd'],
      m['reportNumber'],
      m['grossSales'],
      m['netSales'],
      m['taxCollected'],
      m['transactionCount'],
      m['averageTicket'],
      m['totalDiscounts'],
      m['discountCount'],
      m['voidCount'],
      m['voidAmount'],
      m['refundCount'],
      m['refundAmount'],
      m['openingBalance'],
      m['closingBalance'],
      m['expectedCash'],
      m['actualCash'],
      m['cashVariance'],
      m['paymentBreakdownJson'],
      m['taxBreakdownJson'],
    ];
    if (cr.id != null) {
      _store.execute(
        '''
        UPDATE compliance_report SET reportType=?, generatedAt=?, generatedBy=?,
        periodStart=?, periodEnd=?, reportNumber=?, grossSales=?, netSales=?,
        taxCollected=?, transactionCount=?, averageTicket=?, totalDiscounts=?,
        discountCount=?, voidCount=?, voidAmount=?, refundCount=?, refundAmount=?,
        openingBalance=?, closingBalance=?, expectedCash=?, actualCash=?,
        cashVariance=?, paymentBreakdownJson=?, taxBreakdownJson=? WHERE id=?
      ''',
        [...values, cr.id],
      );
    } else {
      _store.execute('''
        INSERT INTO compliance_report (reportType, generatedAt, generatedBy,
          periodStart, periodEnd, reportNumber, grossSales, netSales,
          taxCollected, transactionCount, averageTicket, totalDiscounts,
          discountCount, voidCount, voidAmount, refundCount, refundAmount,
          openingBalance, closingBalance, expectedCash, actualCash,
          cashVariance, paymentBreakdownJson, taxBreakdownJson)
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
      ''', values);
      cr.id = _store.queryScalar('SELECT last_insert_rowid()') as int?;
    }
  }

  ComplianceReport _toComplianceReport(Map<String, Object?> row) =>
      ComplianceReport.fromMap(row);

  // ── VoidLogEntry ───────────────────────────────────────────────────────

  List<VoidLogEntry> getAllVoidLogs() => _store
      .query('SELECT * FROM void_log_entry ORDER BY id DESC')
      .map(_toVoidLog)
      .toList();

  VoidLogEntry _toVoidLog(Map<String, Object?> row) =>
      VoidLogEntry.fromMap(row);
}

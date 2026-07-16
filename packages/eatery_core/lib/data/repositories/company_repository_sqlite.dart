import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/company_repository.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';

import '../database/native/eatery_store.dart';

/// SQLite-backed implementation of [CompanyRepository], powered by the native
/// libeaterystore (Zig + embedded SQLite) over dart:ffi.
class SqliteCompanyRepository implements CompanyRepository {
  SqliteCompanyRepository({required EateryStore store}) : _store = store;

  final EateryStore _store;

  // ── Company ──────────────────────────────────────────────────────────────

  @override
  Company? getCurrentCompany() {
    // Company is a singleton — there should be at most one row. We read it
    // by its known ID (1) or the first row if that fails.
    var rows = _store.query('SELECT * FROM company WHERE id = 1');
    if (rows.isEmpty) rows = _store.query('SELECT * FROM company LIMIT 1');
    if (rows.isEmpty) return null;
    return _toCompany(rows.first);
  }

  @override
  Future<void> saveCompany(Company company) async {
    final m = company.toMap();
    final id =
        company.id ??
        (_store.queryScalar('SELECT COALESCE(MAX(id), 0) + 1 FROM company')
            as int);
    _store.execute(
      '''
      INSERT OR REPLACE INTO company
        (id, logo, name, email, phone, address, taxation,
         currencyCode, salesTaxNumber, foodLicenseNo, subscriptionId,
         adminEmployeeId)
      VALUES (?,?,?,?,?,?,?,?,?,?,?,?)
    ''',
      [
        id,
        m['logo'],
        m['name'],
        m['email'],
        m['phone'],
        m['address'],
        m['taxation'],
        m['currencyCode'],
        m['salesTaxNumber'],
        m['foodLicenseNo'],
        m['subscriptionId'],
        m['adminEmployeeId'],
      ],
    );
    company = company.copyWith(id: id);
    notifyMutation('company', id, 'save', company.toMap());
  }

  // ── Currencies ───────────────────────────────────────────────────────────

  @override
  KCurrency? getCurrencyByCode(String code) {
    final rows = _store.query('SELECT * FROM currency WHERE code = ?', [code]);
    return rows.isEmpty ? null : _toCurrency(rows.first);
  }

  @override
  List<KCurrency> getAllCurrencies() =>
      _store.query('SELECT * FROM currency').map(_toCurrency).toList();

  /// Seeds the currency table from a provided list (called once at startup
  /// if the table is empty). Not part of the [CompanyRepository] interface.
  void seedCurrencies(Iterable<KCurrency> currencies) {
    if (_store.queryScalar('SELECT COUNT(*) FROM currency') != 0) return;
    for (final c in currencies) {
      _store.execute(
        '''
        INSERT OR IGNORE INTO currency
          (code, name, symbol, flag, number, decimal_digits, name_plural,
           symbol_on_left, decimal_separator, thousands_separator,
           space_between_amount_and_symbol)
        VALUES (?,?,?,?,?,?,?,?,?,?,?)
      ''',
        [
          c.code,
          c.name,
          c.symbol,
          c.flag,
          c.number,
          c.decimalDigits,
          c.namePlural,
          c.symbolOnLeft ? 1 : 0,
          c.decimalSeparator,
          c.thousandsSeparator,
          c.spaceBetweenAmountAndSymbol ? 1 : 0,
        ],
      );
    }
  }

  // ── Mappers ──────────────────────────────────────────────────────────────

  Company _toCompany(Map<String, Object?> row) {
    final editionIdx = row['edition'] as int;
    // Taxation enum: none=-1, gst=0, vat=1. Map via id, with fallback.
    Taxation taxation;
    try {
      taxation = Taxation.values.firstWhere((e) => e.id == editionIdx);
    } catch (_) {
      taxation = Taxation.none;
    }
    return Company(
      logo: row['logo'] as String?,
      name: row['name'] as String,
      email: row['email'] as String,
      phone: row['phone'] as String,
      address: row['address'] as String,
      taxation: taxation,
      currencyCode: row['currencyCode'] as String?,
      salesTaxNumber: row['salesTaxNumber'] as String?,
      foodLicenseNo: row['foodLicenseNo'] as String?,
      subscriptionId: row['subscriptionId'] as int?,
      adminEmployeeId: row['adminEmployeeId'] as int?,
      id: row['id'] as int,
    );
  }

  KCurrency _toCurrency(Map<String, Object?> row) => KCurrency(
    code: row['code'] as String,
    name: row['name'] as String,
    symbol: row['symbol'] as String,
    flag: row['flag'] as String?,
    number: (row['number'] as num).toInt(),
    decimalDigits: (row['decimal_digits'] as num).toInt(),
    namePlural: row['name_plural'] as String,
    symbolOnLeft: (row['symbol_on_left'] as int) == 1,
    decimalSeparator: row['decimal_separator'] as String,
    thousandsSeparator: row['thousands_separator'] as String,
    spaceBetweenAmountAndSymbol:
        (row['space_between_amount_and_symbol'] as int) == 1,
  );
}

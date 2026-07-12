import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/models/eatery_db.dart';

/// Repository for [Company] and [KCurrency] operations.
class CompanyRepository {
  CompanyRepository({required EateryDatabase db}) : _db = db;

  final EateryDatabase _db;

  /// Returns the first (and only) company, or null if none exists.
  Company? getCurrentCompany() {
    if (_db.companyBox.values.isEmpty) return null;
    return _db.companyBox.values.first;
  }

  /// Returns the [KCurrency] matching [code], or null.
  KCurrency? getCurrencyByCode(String code) {
    try {
      return _db.currencyBox.values.firstWhere((c) => c.code == code);
    } catch (_) {
      return null;
    }
  }

  /// Saves the company (always ID 1).
  Future<void> saveCompany(Company company) async {
    await company.save();
  }

  /// Returns all known currencies.
  List<KCurrency> getAllCurrencies() => _db.currencyBox.values.toList();
}

import 'package:eatery/data/models/eatery_db.dart';
abstract class CompanyRepository {
  Company? getCurrentCompany();
  KCurrency? getCurrencyByCode(String code);
  List<KCurrency> getAllCurrencies();
  Future<void> saveCompany(Company company);
}

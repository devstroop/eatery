import 'package:eatery/data/database/native/eatery_schema.dart';
import 'package:eatery/data/database/native/eatery_store.dart';
import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/repositories/company_repository_sqlite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SqliteCompanyRepository', () {
    late EateryStore store;
    late SqliteCompanyRepository repo;

    setUp(() async {
      store = EateryStore.open(':memory:');
      final sql = await rootBundle.loadString(kSchemaAssetPath);
      initEaterySchema(store, sql);
      repo = SqliteCompanyRepository(store: store);
    });

    tearDown(() => store.close());

    test('getCurrentCompany returns null when empty', () {
      expect(repo.getCurrentCompany(), isNull);
    });

    test('saveCompany stores with id=1', () async {
      final c = Company(
        name: 'Test Eatery',
        email: 'test@eatery.com',
        phone: '555-0100',
        address: '123 Main St',
        taxation: Taxation.gst,
        currencyCode: 'INR',
      );
      await repo.saveCompany(c);
      expect(c.id, 1);

      final fetched = repo.getCurrentCompany()!;
      expect(fetched.name, 'Test Eatery');
      expect(fetched.email, 'test@eatery.com');
      expect(fetched.taxation, Taxation.gst);
      expect(fetched.currencyCode, 'INR');
    });

    test('saveCompany replaces existing (singleton)', () async {
      await repo.saveCompany(
        Company(
          name: 'Old',
          email: 'old@eatery.com',
          phone: '000',
          address: 'Old St',
          taxation: Taxation.none,
        ),
      );

      await repo.saveCompany(
        Company(
          name: 'New',
          email: 'new@eatery.com',
          phone: '111',
          address: 'New St',
          taxation: Taxation.vat,
        ),
      );

      expect(repo.getCurrentCompany()!.name, 'New');
      expect(repo.getCurrentCompany()!.taxation, Taxation.vat);
      expect(store.queryScalar('SELECT COUNT(*) FROM company'), 1);
    });

    test('getCurrencyByCode works with seedCurrencies', () {
      repo.seedCurrencies([
        KCurrency(
          code: 'USD',
          name: 'US Dollar',
          symbol: '\$',
          flag: null,
          number: 840,
          decimalDigits: 2,
          namePlural: 'US dollars',
          symbolOnLeft: true,
          decimalSeparator: '.',
          thousandsSeparator: ',',
          spaceBetweenAmountAndSymbol: false,
        ),
      ]);

      final usd = repo.getCurrencyByCode('USD')!;
      expect(usd.name, 'US Dollar');
      expect(usd.symbol, '\$');
      expect(repo.getCurrencyByCode('EUR'), isNull);
    });

    test('seedCurrencies is idempotent', () {
      repo.seedCurrencies([
        KCurrency(
          code: 'INR',
          name: 'Indian Rupee',
          symbol: '₹',
          flag: null,
          number: 356,
          decimalDigits: 2,
          namePlural: 'Indian rupees',
          symbolOnLeft: true,
          decimalSeparator: '.',
          thousandsSeparator: ',',
          spaceBetweenAmountAndSymbol: false,
        ),
      ]);

      repo.seedCurrencies([
        KCurrency(
          code: 'INR',
          name: 'Duplicate',
          symbol: '₹',
          flag: null,
          number: 356,
          decimalDigits: 2,
          namePlural: 'Duplicate',
          symbolOnLeft: true,
          decimalSeparator: '.',
          thousandsSeparator: ',',
          spaceBetweenAmountAndSymbol: false,
        ),
      ]);

      expect(repo.getAllCurrencies(), hasLength(1));
      expect(repo.getCurrencyByCode('INR')!.name, 'Indian Rupee');
    });
  });
}

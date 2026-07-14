import 'package:eatery/data/database/native/eatery_schema.dart';
import 'package:eatery/data/database/native/eatery_store.dart';
import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/repositories/payment_repository_sqlite.dart';
import 'package:eatery/data/repositories/tax_repository_sqlite.dart';
import 'package:eatery/data/repositories/dining_table_repository_sqlite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase A repositories', () {
    late EateryStore store;

    setUp(() async {
      store = EateryStore.open(':memory:');
      final sql = await rootBundle.loadString(kSchemaAssetPath);
      initEaterySchema(store, sql);
    });

    tearDown(() => store.close());

    // ==========================================================================
    // Payment
    // ==========================================================================

    group('SqlitePaymentRepository', () {
      late SqlitePaymentRepository repo;

      setUp(() {
        repo = SqlitePaymentRepository(store: store);
      });

      test('insert assigns id and round-trips all fields', () async {
        final p = Payment(
          orderId: 1,
          amount: 49.99,
          mode: PaymentMode.upi,
          reference: 'ref-001',
          processorTransactionId: 'txn-001',
          processorName: 'razorpay',
          processorStatus: 'captured',
          cardLastFour: '1234',
          terminalId: 'term-01',
        );
        final id = await repo.savePayment(p);
        expect(id, greaterThan(0));
        expect(p.id, id);

        final payments = repo.getAllPayments();
        expect(payments, hasLength(1));
        final fetched = payments.first;
        expect(fetched.orderId, 1);
        expect(fetched.amount, 49.99);
        expect(fetched.mode, PaymentMode.upi);
        expect(fetched.reference, 'ref-001');
        expect(fetched.processorTransactionId, 'txn-001');
      });

      test('getPaymentsByOrder filters correctly', () async {
        await repo.savePayment(
          Payment(orderId: 1, amount: 10, mode: PaymentMode.cash),
        );
        await repo.savePayment(
          Payment(orderId: 2, amount: 20, mode: PaymentMode.card),
        );
        await repo.savePayment(
          Payment(orderId: 1, amount: 30, mode: PaymentMode.cash),
        );

        expect(repo.getPaymentsByOrder(1), hasLength(2));
        expect(repo.getPaymentsByOrder(2), hasLength(1));
        expect(repo.getPaymentsByOrder(3), isEmpty);
      });

      test('update mutates existing row (no duplicate)', () async {
        final p = Payment(orderId: 1, amount: 50, mode: PaymentMode.cash);
        final id = await repo.savePayment(p);

        p.amount = 75;
        p.mode = PaymentMode.card;
        await repo.savePayment(p);

        expect(repo.getAllPayments(), hasLength(1));
        expect(repo.getAllPayments().first.amount, 75);
        expect(repo.getAllPayments().first.mode, PaymentMode.card);
      });
    });

    // ==========================================================================
    // TaxSlab
    // ==========================================================================

    group('SqliteTaxRepository', () {
      late SqliteTaxRepository repo;

      setUp(() {
        repo = SqliteTaxRepository(store: store);
      });

      test('insert assigns id and round-trips fields', () async {
        final slab = TaxSlab(
          name: 'GST 18%',
          rate: 18.0,
          type: TaxType.inclusive,
        );
        final id = await repo.saveTaxSlab(slab);
        expect(id, greaterThan(0));

        final slabs = repo.getAllTaxSlabs();
        expect(slabs, hasLength(1));
        final fetched = slabs.first;
        expect(fetched.name, 'GST 18%');
        expect(fetched.rate, 18.0);
        expect(fetched.type, TaxType.inclusive);
      });

      test('getTaxSlabById works', () async {
        await repo.saveTaxSlab(
          TaxSlab(name: 'A', rate: 5, type: TaxType.exclusive),
        );
        final fetched = repo.getTaxSlabById(1)!;
        expect(fetched.name, 'A');
        expect(repo.getTaxSlabById(999), isNull);
      });

      test('update mutates existing row', () async {
        final s = TaxSlab(name: 'Old', rate: 10, type: TaxType.inclusive);
        final id = await repo.saveTaxSlab(s);

        s.name = 'Updated';
        s.rate = 12.0;
        await repo.saveTaxSlab(s);

        expect(repo.getAllTaxSlabs(), hasLength(1));
        expect(repo.getTaxSlabById(id)!.name, 'Updated');
      });
    });

    // ==========================================================================
    // DiningTable + DiningTableCategory
    // ==========================================================================

    group('SqliteDiningTableRepository', () {
      late SqliteDiningTableRepository repo;

      setUp(() {
        repo = SqliteDiningTableRepository(store: store);
      });

      // --- Categories ---

      test('category insert + get', () async {
        final cat = DiningTableCategory(name: 'Window Side', isActive: true);
        final id = await repo.saveCategory(cat);
        expect(id, greaterThan(0));

        final fetched = repo.getCategoryById(id)!;
        expect(fetched.name, 'Window Side');
        expect(fetched.isActive, isTrue);

        expect(repo.getCategoryById(999), isNull);
      });

      test('category update', () async {
        final c = DiningTableCategory(name: 'X', isActive: false);
        await repo.saveCategory(c);
        c.name = 'Y';
        c.isActive = true;
        await repo.saveCategory(c);

        expect(repo.getAllCategories().map((c) => c.name), ['Y']);
        expect(repo.getCategoryById(c.id!)!.isActive, isTrue);
      });

      // --- Tables ---

      test('table insert assigns id', () async {
        final t = DiningTable(
          name: 'Table 1',
          status: DiningTableStatus.available,
        );
        final id = await repo.saveTable(t);
        expect(id, greaterThan(0));
        expect(t.id, id);
      });

      test(
        'table round-trips all fields including status and category',
        () async {
          final cat = DiningTableCategory(name: 'Outdoor', isActive: true);
          await repo.saveCategory(cat);

          final t = DiningTable(
            name: 'T3',
            category: cat,
            capacity: 4,
            status: DiningTableStatus.reserved,
            customerPhone: '555-0100',
          );
          final id = await repo.saveTable(t);

          final fetched = repo.getTableById(id)!;
          expect(fetched.name, 'T3');
          expect(fetched.capacity, 4);
          expect(fetched.status, DiningTableStatus.reserved);
          expect(fetched.customerPhone, '555-0100');
          // categoryId stored correctly in SQLite (verified via raw query).
          expect(
            store.queryScalar(
              'SELECT categoryId FROM dining_table WHERE id = ?',
              [id],
            ),
            cat.id,
          );
        },
      );

      test('getAllTables returns all', () async {
        await repo.saveTable(DiningTable(name: 'A'));
        await repo.saveTable(DiningTable(name: 'B'));
        expect(repo.getAllTables(), hasLength(2));
      });

      test('table update mutates row (no duplicate)', () async {
        final t = DiningTable(name: 'Initial', capacity: 2);
        final id = await repo.saveTable(t);

        t.name = 'Changed';
        t.capacity = 6;
        t.status = DiningTableStatus.occupied;
        await repo.saveTable(t);

        expect(repo.getAllTables(), hasLength(1));
        final fetched = repo.getTableById(id)!;
        expect(fetched.name, 'Changed');
        expect(fetched.capacity, 6);
        expect(fetched.status, DiningTableStatus.occupied);
      });
    });
  });
}

import 'package:eatery_core/data/database/eatery_database.dart';
import 'package:eatery_core/data/database/native/eatery_schema.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/customer_repository_sqlite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SqliteCustomerRepository', () {
    late EateryStore store;
    late SqliteCustomerRepository repo;

    setUp(() async {
      store = EateryStore.open(':memory:');
      final schema = await rootBundle.loadString(kSchemaAssetPath);
      initEaterySchema(store, schema);
      repo = SqliteCustomerRepository(
        store: store,
        db: EateryDatabase(dataDir: '.', store: store),
      );
    });

    tearDown(() => store.close());

    test('insert assigns an id and round-trips all fields', () async {
      final now = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch,
      );
      final c = Customer(
        name: 'Ada Lovelace',
        phone: '555-0100',
        address: '12 Analytical Way',
        landmark: 'Near the Engine',
        latitude: 51.5074,
        longitude: -0.1278,
        isActive: true,
        lastOrderAt: now,
      );

      final id = await repo.saveCustomer(c);
      expect(id, greaterThan(0));
      expect(c.id, id);

      final fetched = repo.getCustomerByPhone('555-0100')!;
      expect(fetched.name, 'Ada Lovelace');
      expect(fetched.phone, '555-0100');
      expect(fetched.address, '12 Analytical Way');
      expect(fetched.landmark, 'Near the Engine');
      expect(fetched.latitude, closeTo(51.5074, 1e-9));
      expect(fetched.longitude, closeTo(-0.1278, 1e-9));
      expect(fetched.isActive, isTrue);
      expect(fetched.lastOrderAt, now);
    });

    test('nullable fields round-trip as null', () async {
      final c = Customer(phone: '555-0199');
      await repo.saveCustomer(c);

      final fetched = repo.getCustomerByPhone('555-0199')!;
      expect(fetched.name, isNull);
      expect(fetched.address, isNull);
      expect(fetched.latitude, isNull);
      expect(fetched.longitude, isNull);
      expect(fetched.lastOrderAt, isNull);
      expect(fetched.isActive, isTrue); // default
    });

    test('update mutates the existing row (no duplicate)', () async {
      final c = Customer(name: 'Grace', phone: '555-0200');
      final id = await repo.saveCustomer(c);

      c.name = 'Grace Hopper';
      c.isActive = false;
      final id2 = await repo.saveCustomer(c);

      expect(id2, id);
      expect(repo.getAllCustomers(), hasLength(1));
      final fetched = repo.getCustomerByPhone('555-0200')!;
      expect(fetched.name, 'Grace Hopper');
      expect(fetched.isActive, isFalse);
    });

    test('getAllCustomers returns every row', () async {
      await repo.saveCustomer(Customer(phone: '111'));
      await repo.saveCustomer(Customer(phone: '222'));
      await repo.saveCustomer(Customer(phone: '333'));

      expect(repo.getAllCustomers().map((c) => c.phone).toSet(), {
        '111',
        '222',
        '333',
      });
    });

    test('getCustomerByPhone returns null when absent', () {
      expect(repo.getCustomerByPhone('nope'), isNull);
    });
  });
}

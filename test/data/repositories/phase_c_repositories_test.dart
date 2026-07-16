import 'package:eatery_core/data/database/native/eatery_schema.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/employee_repository_sqlite.dart';
import 'package:eatery_core/data/repositories/subscription_repository_sqlite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late EateryStore store;

  setUp(() async {
    store = EateryStore.open(':memory:');
    final sql = await rootBundle.loadString(kSchemaAssetPath);
    initEaterySchema(store, sql);
  });

  tearDown(() => store.close());

  // ==========================================================================
  // Employee
  // ==========================================================================

  group('SqliteEmployeeRepository', () {
    late SqliteEmployeeRepository repo;

    setUp(() {
      repo = SqliteEmployeeRepository(store: store);
    });

    test('insert assigns id and round-trips fields', () async {
      final s = Employee(
        name: 'Alice',
        type: EmployeeRole.waiter,
        isActive: true,
      );
      final id = await repo.saveEmployee(s);
      expect(id, greaterThan(0));

      final all = repo.getAllEmployees();
      expect(all, hasLength(1));
      expect(all.first.name, 'Alice');
      expect(all.first.type, EmployeeRole.waiter);
      expect(all.first.isActive, isTrue);
    });

    test('getEmployeeById works', () async {
      final s = Employee(name: 'Bob', type: EmployeeRole.chef, isActive: true);
      final id = await repo.saveEmployee(s);
      expect(repo.getEmployeeById(id)!.name, 'Bob');
      expect(repo.getEmployeeById(999), isNull);
    });

    test('name and phone taken checks', () async {
      await repo.saveEmployee(
        Employee(
          name: 'Alice',
          phone: '555-0001',
          type: EmployeeRole.waiter,
          isActive: true,
        ),
      );

      expect(repo.isEmployeeNameTaken('Alice'), isTrue);
      expect(repo.isEmployeeNameTaken('alice'), isTrue);
      expect(repo.isEmployeeNameTaken('Bob'), isFalse);

      expect(repo.isEmployeePhoneTaken('555-0001'), isTrue);
      expect(repo.isEmployeePhoneTaken('0000'), isFalse);
    });

    test('clearAll and addAll round-trip', () async {
      await repo.saveEmployee(
        Employee(name: 'A', type: EmployeeRole.waiter, isActive: true),
      );
      await repo.saveEmployee(
        Employee(name: 'B', type: EmployeeRole.chef, isActive: false),
      );
      expect(repo.getAllEmployees(), hasLength(2));

      await repo.clearAll();
      expect(repo.getAllEmployees(), isEmpty);

      await repo.addAll([
        Employee(name: 'X', type: EmployeeRole.driver, isActive: true),
        Employee(name: 'Y', type: EmployeeRole.other, isActive: true),
      ]);
      expect(repo.getAllEmployees(), hasLength(2));
    });
  });

  // ==========================================================================
  // Subscription
  // ==========================================================================

  group('SqliteSubscriptionRepository', () {
    late SqliteSubscriptionRepository repo;

    setUp(() {
      repo = SqliteSubscriptionRepository(store: store);
    });

    test('save and getFirst round-trip', () async {
      final sub = Subscription(
        purchaseCode: 'ABC-123',
        subscriptionType: SubscriptionType.business,
        validFrom: DateTime(2025, 1, 1),
        validTill: DateTime(2026, 12, 31),
      );
      final id = await repo.save(sub);
      expect(id, greaterThan(0));

      final fetched = repo.getFirst()!;
      expect(fetched.purchaseCode, 'ABC-123');
      expect(fetched.subscriptionType, SubscriptionType.business);
      expect(fetched.validFrom, DateTime(2025, 1, 1));
      expect(fetched.validTill, DateTime(2026, 12, 31));
    });

    test('getFirst returns null when empty', () {
      expect(repo.getFirst(), isNull);
    });

    test('save replaces existing when id set', () async {
      final sub = Subscription(subscriptionType: SubscriptionType.individual);
      final id = await repo.save(sub);

      final updated = sub.copyWith(
        subscriptionType: SubscriptionType.business,
        id: id,
      );
      final id2 = await repo.save(updated);

      expect(id2, id);
      final fetched = repo.getFirst()!;
      expect(fetched.subscriptionType, SubscriptionType.business);
    });

    test('clearAll works', () async {
      await repo.save(
        Subscription(subscriptionType: SubscriptionType.individual),
      );
      await repo.save(
        Subscription(subscriptionType: SubscriptionType.business),
      );
      expect(repo.getFirst(), isNotNull);
      await repo.clearAll();
      expect(repo.getFirst(), isNull);
    });
  });
}

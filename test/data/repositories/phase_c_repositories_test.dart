import 'package:eatery_core/data/database/native/eatery_schema.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/staff_repository_sqlite.dart';
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
  // Staff
  // ==========================================================================

  group('SqliteStaffRepository', () {
    late SqliteStaffRepository repo;

    setUp(() {
      repo = SqliteStaffRepository(store: store);
    });

    test('insert assigns id and round-trips fields', () async {
      final s = Staff(name: 'Alice', type: StaffType.waiter, isActive: true);
      final id = await repo.saveStaff(s);
      expect(id, greaterThan(0));

      final all = repo.getAllStaff();
      expect(all, hasLength(1));
      expect(all.first.name, 'Alice');
      expect(all.first.type, StaffType.waiter);
      expect(all.first.isActive, isTrue);
    });

    test('getStaffById works', () async {
      final s = Staff(name: 'Bob', type: StaffType.chef, isActive: true);
      final id = await repo.saveStaff(s);
      expect(repo.getStaffById(id)!.name, 'Bob');
      expect(repo.getStaffById(999), isNull);
    });

    test('name and phone taken checks', () async {
      await repo.saveStaff(
        Staff(
          name: 'Alice',
          phone: '555-0001',
          type: StaffType.waiter,
          isActive: true,
        ),
      );

      expect(repo.isStaffNameTaken('Alice'), isTrue);
      expect(repo.isStaffNameTaken('alice'), isTrue);
      expect(repo.isStaffNameTaken('Bob'), isFalse);

      expect(repo.isStaffPhoneTaken('555-0001'), isTrue);
      expect(repo.isStaffPhoneTaken('0000'), isFalse);
    });

    test('clearAll and addAll round-trip', () async {
      await repo.saveStaff(
        Staff(name: 'A', type: StaffType.waiter, isActive: true),
      );
      await repo.saveStaff(
        Staff(name: 'B', type: StaffType.chef, isActive: false),
      );
      expect(repo.getAllStaff(), hasLength(2));

      await repo.clearAll();
      expect(repo.getAllStaff(), isEmpty);

      await repo.addAll([
        Staff(name: 'X', type: StaffType.driver, isActive: true),
        Staff(name: 'Y', type: StaffType.other, isActive: true),
      ]);
      expect(repo.getAllStaff(), hasLength(2));
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
      await repo.save(sub);

      sub.subscriptionType = SubscriptionType.business;
      await repo.save(sub);

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

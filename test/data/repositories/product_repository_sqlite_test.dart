import 'package:eatery_core/data/database/native/eatery_schema.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/product_repository_sqlite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SqliteProductRepository', () {
    late EateryStore store;
    late SqliteProductRepository repo;

    setUp(() async {
      store = EateryStore.open(':memory:');
      final sql = await rootBundle.loadString(kSchemaAssetPath);
      initEaterySchema(store, sql);
      repo = SqliteProductRepository(store: store);
    });

    tearDown(() => store.close());

    Product makeProduct({
      String name = 'Latte',
      double mrp = 4.0,
      ProductType type = ProductType.kitchenDish,
      FoodType? food = FoodType.veg,
      bool active = true,
      int? categoryId,
    }) {
      return Product(
        name: name,
        mrpPrice: mrp,
        type: type,
        foodType: food,
        isActive: active,
        categoryId: categoryId,
      );
    }

    test('insert assigns an id and round-trips all fields', () async {
      final p = makeProduct(name: 'Cappuccino', mrp: 3.5, food: FoodType.veg);
      final id = await repo.saveProduct(p);

      expect(id, greaterThan(0));
      expect(p.id, id);

      final fetched = repo.getProductById(id)!;
      expect(fetched.name, 'Cappuccino');
      expect(fetched.mrpPrice, 3.5);
      expect(fetched.mrpPrice, isA<double>());
      expect(fetched.type, ProductType.kitchenDish);
      expect(fetched.foodType, FoodType.veg);
      expect(fetched.isActive, isTrue);
    });

    test('whole-number REAL round-trips as double (not int)', () async {
      final id = await repo.saveProduct(makeProduct(mrp: 4.0));
      final fetched = repo.getProductById(id)!;
      expect(fetched.mrpPrice, 4.0);
      expect(fetched.mrpPrice, isA<double>());
    });

    test('update mutates the existing row (no duplicate)', () async {
      final p = makeProduct(name: 'Mocha', mrp: 5.0);
      final id = await repo.saveProduct(p);

      p.name = 'Mocha Deluxe';
      p.mrpPrice = 6.5;
      p.isActive = false;
      final id2 = await repo.saveProduct(p);

      expect(id2, id);
      expect(repo.getAllProducts(), hasLength(1));
      final fetched = repo.getProductById(id)!;
      expect(fetched.name, 'Mocha Deluxe');
      expect(fetched.mrpPrice, 6.5);
      expect(fetched.isActive, isFalse);
    });

    test('delete removes the row', () async {
      final p = makeProduct();
      final id = await repo.saveProduct(p);
      expect(repo.getAllProducts(), hasLength(1));

      await repo.deleteProduct(p);
      expect(repo.getAllProducts(), isEmpty);
      expect(repo.getProductById(id), isNull);
    });

    test('filter by type and category', () async {
      await repo.saveProduct(
        makeProduct(name: 'Dish', type: ProductType.kitchenDish, categoryId: 1),
      );
      await repo.saveProduct(
        makeProduct(
          name: 'Item',
          type: ProductType.inventoryItem,
          categoryId: 2,
        ),
      );

      expect(
        repo.getProductsByType(ProductType.kitchenDish).map((p) => p.name),
        ['Dish'],
      );
      expect(
        repo.getProductsByType(ProductType.inventoryItem).map((p) => p.name),
        ['Item'],
      );
      expect(repo.getProductsByCategory(2).map((p) => p.name), ['Item']);
    });

    test('search is case-insensitive and partial', () async {
      await repo.saveProduct(makeProduct(name: 'Green Tea'));
      await repo.saveProduct(makeProduct(name: 'Black Coffee'));

      expect(repo.searchProducts('tea').map((p) => p.name), ['Green Tea']);
      expect(repo.searchProducts('COFFEE').map((p) => p.name), [
        'Black Coffee',
      ]);
      expect(repo.searchProducts('').length, 2);
    });

    test('isProductNameTaken respects excludeId', () async {
      final p = makeProduct(name: 'Unique');
      final id = await repo.saveProduct(p);

      expect(repo.isProductNameTaken('Unique'), isTrue);
      expect(repo.isProductNameTaken('unique'), isTrue);
      expect(repo.isProductNameTaken('Unique', excludeId: id), isFalse);
      expect(repo.isProductNameTaken('Other'), isFalse);
    });

    test('category CRUD', () async {
      final cat = ProductCategory(name: 'Beverages', description: 'Drinks');
      final id = await repo.saveCategory(cat);
      expect(id, greaterThan(0));

      final fetched = repo.getCategoryById(id)!;
      expect(fetched.name, 'Beverages');
      expect(fetched.description, 'Drinks');

      cat.name = 'Hot Beverages';
      await repo.saveCategory(cat);
      expect(repo.getAllCategories(), hasLength(1));
      expect(repo.getCategoryById(id)!.name, 'Hot Beverages');

      await repo.deleteCategory(cat);
      expect(repo.getAllCategories(), isEmpty);
    });
  });
}

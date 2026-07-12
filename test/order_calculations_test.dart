import 'package:flutter_test/flutter_test.dart';
import 'package:eatery/functions/order.function.dart';
import 'package:eatery/data/models/eatery_db.dart';

void main() {
  group('OrderFunction calculations (no DB dependency)', () {
    test('calculateRoundOff', () {
      expect(OrderFunction.calculateRoundOff(100.12), closeTo(-0.12, 0.01));
      expect(OrderFunction.calculateRoundOff(99.50), closeTo(0.50, 0.01));
      expect(OrderFunction.calculateRoundOff(100.0), closeTo(0.0, 0.01));
    });

    test('calculateSubtotal sums all product prices', () {
      final products = [
        _product(mrpPrice: 10.0, salePrice: null),
        _product(mrpPrice: 20.0, salePrice: 15.0),
        _product(mrpPrice: 30.0, salePrice: null),
      ];
      expect(OrderFunction.calculateSubtotal(products), closeTo(55.0, 0.01));
    });

    test('calculateSubtotal uses salePrice when available', () {
      final products = [
        _product(mrpPrice: 10.0, salePrice: 8.0),
        _product(mrpPrice: 20.0, salePrice: 18.0),
      ];
      expect(OrderFunction.calculateSubtotal(products), closeTo(26.0, 0.01));
    });
  });
}

Product _product({double mrpPrice = 0, double? salePrice, int? taxSlabId}) {
  return Product(
    name: 'Test Product',
    mrpPrice: mrpPrice,
    salePrice: salePrice,
    taxSlabId: taxSlabId,
    type: ProductType.inventoryItem,
    isActive: true,
  );
}

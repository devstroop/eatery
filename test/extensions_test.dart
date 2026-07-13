import 'package:flutter_test/flutter_test.dart';
import 'package:eatery/core/extensions/double_ext.dart';
import 'package:eatery/core/extensions/string_ext.dart';

void main() {
  group('DoublePrecision', () {
    test('toPrecision rounds correctly', () {
      expect(3.14159.toPrecision(2), 3.14);
      expect(3.14159.toPrecision(0), 3.0);
      expect(10.0.toPrecision(2), 10.0);
      expect(0.5678.toPrecision(2), 0.57);
      expect((-3.14159).toPrecision(2), -3.14);
    });
  });

  group('StringValidation', () {
    test('isNumericOnly returns true for digits only', () {
      expect('12345'.isNumericOnly, true);
      expect('0'.isNumericOnly, true);
      expect(''.isNumericOnly, false);
    });

    test('isNumericOnly returns false for non-digit strings', () {
      expect('12a45'.isNumericOnly, false);
      expect('abc'.isNumericOnly, false);
      expect('12.34'.isNumericOnly, false);
      expect('12 34'.isNumericOnly, false);
    });
  });
}

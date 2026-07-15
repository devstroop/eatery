import 'package:flutter_test/flutter_test.dart';
import 'package:eatery_core/extensions/double_ext.dart';
import 'package:eatery_core/extensions/string_ext.dart';

void main() {
  testWidgets('App smoke test - extensions only', (WidgetTester tester) async {
    expect(3.14159.toPrecision(2), 3.14);
    expect('12345'.isNumericOnly, true);
  });
}

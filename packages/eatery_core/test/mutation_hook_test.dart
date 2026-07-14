import 'package:eatery_core/eatery_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MutationHook isolation', () {
    test('set/clear controls callback invocation', () {
      final hook = MutationHook();
      String? captured;

      hook.set((type, id, op, data) => captured = '$type:$id:$op');
      hook.notify('product', 1, 'save', {});
      expect(captured, 'product:1:save');

      captured = null;
      hook.clear();
      hook.notify('product', 1, 'save', {});
      expect(captured, isNull);
    });

    test('two hooks do not cross-talk', () {
      final hookA = MutationHook();
      final hookB = MutationHook();

      String? capturedA;
      String? capturedB;

      hookA.set((type, id, op, data) => capturedA = 'A:$type:$id');
      hookB.set((type, id, op, data) => capturedB = 'B:$type:$id');

      hookA.notify('order', 1, 'save', {});
      expect(capturedA, 'A:order:1');
      expect(capturedB, isNull);

      hookB.notify('product', 2, 'save', {});
      expect(capturedB, 'B:product:2');
      expect(capturedA, 'A:order:1');
    });

    test('install/reset replaces shared instance', () {
      final hook = MutationHook();
      String? captured;
      hook.set((type, id, op, data) => captured = '$type:$id');

      MutationHook.install(hook);
      MutationHook.notifyMutation('product', 7, 'save', {});
      expect(captured, 'product:7');

      captured = null;
      MutationHook.reset();
      MutationHook.notifyMutation('product', 7, 'save', {});
      expect(captured, isNull);
    });

    test('notifyMutation free function delegates to instance', () {
      final hook = MutationHook();
      MutationHook.install(hook);

      String? captured;
      hook.set((type, id, op, data) => captured = '$type:$id');

      notifyMutation('order', 3, 'delete', {});
      expect(captured, 'order:3');

      MutationHook.reset();
    });
  });
}

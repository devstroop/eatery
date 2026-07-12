import 'package:eatery/references.dart';

/// Legacy global state container.
///
/// State fields (activeOrder, cart, company…) have been migrated to Riverpod
/// providers. Path fields have been consolidated into [AppFileSystem].
/// Only [baseDirectory] remains as a bridge until all consumers are updated.
class Common {
  // Absolute paths — use AppFileSystem instead.
  static String? _baseDirectory;

  static String? get baseDirectory => _baseDirectory;

  static set baseDirectory(String? value) {
    _baseDirectory = value;
  }
}

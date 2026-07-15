import '../references.dart';

extension CustomerExtension on Customer {
  double get getOutstandingAmount {
    // DEPRECATED: All callers now read directly from
    // `ref.read(customerRepositoryProvider).getOutstandingAmount(phone)`.
    // This extension is unused and kept only to avoid breaking existing imports.
    // Remove once all dangling references are verified.
    return 0.0;
  }
}

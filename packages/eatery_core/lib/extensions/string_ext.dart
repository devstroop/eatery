/// String validation extensions (replaces GetX string extensions).
extension StringValidation on String {
  /// Returns true if this string contains only numeric characters (0-9).
  bool get isNumericOnly {
    if (isEmpty) return false;
    return codeUnits.every((c) => c >= 48 && c <= 57);
  }
}

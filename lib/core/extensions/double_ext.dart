import 'dart:math';

/// Extension on [double] to replace GetX's `.toPrecision()`.
extension DoublePrecision on double {
  /// Returns this double rounded to [fractionDigits] decimal places.
  double toPrecision(int fractionDigits) {
    final mod = pow(10, fractionDigits.toDouble());
    return (this * mod).roundToDouble() / mod;
  }
}

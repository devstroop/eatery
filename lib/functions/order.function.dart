import 'package:eatery_core/extensions/double_ext.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/models/eatery_db.dart';

class OrderFunction {
  static EateryStore? _store;
  static void init(EateryStore store) {
    _store = store;
  }

  static TaxSlab? _getTaxSlab(int? id) {
    if (id == null || _store == null) return null;
    final rows = _store!.query('SELECT * FROM tax_slab WHERE id = ?', [id]);
    return rows.isEmpty ? null : TaxSlab.fromMap(rows.first);
  }

  static double calculateProductPriceWithoutTax(Product product) {
    final basePrice = product.salePrice ?? product.mrpPrice;
    final s = _getTaxSlab(product.taxSlabId);
    if (s != null && s.type == TaxType.inclusive)
      return (basePrice / (1 + s.rate / 100)).toPrecision(2);
    return basePrice.toPrecision(2);
  }

  static double calculateProductSubtotalInCartWithoutTax(
    List<Product> cart,
    Product product,
  ) => cart
      .where((e) => e.id == product.id)
      .map((e) => calculateProductPriceWithoutTax(e))
      .fold(0.0, (v, e) => v + e)
      .toPrecision(2);

  static double calculateCartTotalWithoutTax(List<Product> cart) => cart
      .map((e) => calculateProductPriceWithoutTax(e))
      .fold(0.0, (v, e) => v + e)
      .toPrecision(2);

  static double calculateTotalWithTax(List<Product> cart) =>
      (calculateCartTotalWithoutTax(cart) + calculateTaxAmount(cart))
          .toPrecision(2);

  static double calculateSubtotal(List<Product> cart) => cart
      .map((p) => p.salePrice ?? p.mrpPrice)
      .fold(0.0, (v, e) => v + e)
      .toPrecision(2);

  static double calculateTaxAmount(List<Product> cart) {
    double tax = 0;
    for (final p in cart) {
      final s = _getTaxSlab(p.taxSlabId);
      if (s != null) {
        if (s.type == TaxType.exclusive)
          tax += (p.salePrice ?? p.mrpPrice) * (s.rate / 100);
        else if (s.type == TaxType.inclusive)
          tax +=
              (p.salePrice ?? p.mrpPrice) - calculateProductPriceWithoutTax(p);
      }
    }
    return tax.toPrecision(2);
  }

  static double calculateRoundOff(double v) => (v.round() - v).toPrecision(2);
  static double calculatePayable(List<Product> cart) {
    final t = calculateTotalWithTax(cart);
    return (t + calculateRoundOff(t)).toPrecision(2);
  }

  static double? getProductTaxRate(Product p) => _getTaxSlab(p.taxSlabId)?.rate;

  static double? calculateProductTaxAmount(Product p) {
    final s = _getTaxSlab(p.taxSlabId);
    if (s != null) {
      if (s.type == TaxType.exclusive)
        return (p.salePrice ?? p.mrpPrice) * (s.rate / 100);
      if (s.type == TaxType.inclusive)
        return (p.salePrice ?? p.mrpPrice) - calculateProductPriceWithoutTax(p);
    }
    return null;
  }
}

import '../core/extensions/double_ext.dart';

import '../references.dart';

class OrderFunction {
  static double calculateProductPriceWithoutTax(Product product) {
    final basePrice = product.salePrice ?? product.mrpPrice;

    if (product.taxSlabId != null) {
      final taxSlab = EateryDB.instance.taxSlabBox!.values
          .where((element) => element.id == product.taxSlabId)
          .firstOrNull;

      if (taxSlab != null && taxSlab.type == TaxType.inclusive) {
        return (basePrice / (1 + taxSlab.rate / 100)).toPrecision(2);
      }
    }

    return basePrice.toPrecision(2);
  }

  static double calculateProductSubtotalInCartWithoutTax(
    List<Product> cart,
    Product product,
  ) {
    return cart
        .where((element) => element.id == product.id)
        .map((e) => calculateProductPriceWithoutTax(e))
        .fold(0.0, (value, element) => value + element)
        .toPrecision(2);
  }

  static double calculateCartTotalWithoutTax(List<Product> cart) {
    return cart
        .map((e) => calculateProductPriceWithoutTax(e))
        .fold(0.0, (value, element) => value + element)
        .toPrecision(2);
  }

  static double calculateTotalWithTax(List<Product> cart) {
    return (calculateCartTotalWithoutTax(cart) + calculateTaxAmount(cart))
        .toPrecision(2);
  }

  static double calculateSubtotal(List<Product> cart) {
    return cart
        .map((product) => product.salePrice ?? product.mrpPrice)
        .fold(0.0, (value, element) => value + element)
        .toPrecision(2);
  }

  static double calculateTaxAmount(List<Product> cart) {
    double taxAmount = 0;

    for (var product in cart) {
      if (product.taxSlabId != null) {
        final taxSlab = EateryDB.instance.taxSlabBox!.values
            .where((element) => element.id == product.taxSlabId)
            .firstOrNull;

        if (taxSlab != null) {
          if (taxSlab.type == TaxType.exclusive) {
            taxAmount +=
                (product.salePrice ?? product.mrpPrice) * (taxSlab.rate / 100);
          } else if (taxSlab.type == TaxType.inclusive) {
            taxAmount +=
                (product.salePrice ?? product.mrpPrice) -
                calculateProductPriceWithoutTax(product);
          }
        }
      }
    }

    return taxAmount.toPrecision(2);
  }

  static double calculateRoundOff(double value) {
    final decimal = value.round() - value;
    return decimal.toPrecision(2);
  }

  static double calculatePayable(List<Product> cart) {
    var finalTotal = calculateTotalWithTax(cart);
    return (finalTotal + calculateRoundOff(finalTotal)).toPrecision(2);
  }

  static double? getProductTaxRate(Product product) {
    return EateryDB.instance.taxSlabBox!.values
        .where((element) => element.id == product.taxSlabId)
        .firstOrNull
        ?.rate;
  }

  static double? calculateProductTaxAmount(Product product) {
    final taxSlab = EateryDB.instance.taxSlabBox!.values
        .where((element) => element.id == product.taxSlabId)
        .firstOrNull;

    if (taxSlab != null) {
      if (taxSlab.type == TaxType.exclusive) {
        return (product.salePrice ?? product.mrpPrice) * (taxSlab.rate / 100);
      } else if (taxSlab.type == TaxType.inclusive) {
        return (product.salePrice ?? product.mrpPrice) -
            calculateProductPriceWithoutTax(product);
      }
    }

    return null;
  }
}

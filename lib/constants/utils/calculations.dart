class Calculations {
  static String compressDoubleToString(double? value) {
    if (value != null) {
      if (value % 1 == 0) {
        return '${value.round()}';
      } else {
        return value.toString();
      }
    }
    return '';
  } // OK

  static double calculatePriceWithoutTax(
      {required String taxType, required double price, required double tax}) {
    return double.parse(
        (taxType == 'inclusive' ? price / (1 + (tax / 100)) : price)
            .toStringAsFixed(2));
  }

  static double calculateTaxableTotal(
      {required Map<String, Map<String, dynamic>> cart}) {
    double total = 0;
    for (String id in cart.keys) {
      double quantity = cart[id]!['quantity'];
      double price = cart[id]!['price'];
      double tax = cart[id]!['tax_slab'];

      if (cart[id]!['taxType'] == 'inclusive') {
        price = price / (1 + (tax / 100));
      }
      total += price * quantity;
    }
    return double.parse(total.toStringAsFixed(2));
  }

  static double calculateTaxTotal(
      {required Map<String, Map<String, dynamic>> cart}) {
    double total = 0;
    for (String id in cart.keys) {
      double quantity = cart[id]!['quantity'];
      double price = cart[id]!['price'];
      double tax = cart[id]!['tax_slab'];
      if (cart[id]!['taxType'] == 'inclusive') {
        total += (price - (price / (1 + (tax / 100)))) * quantity;
      } else {
        total += (price * tax / 100) * quantity;
      }
    }
    return double.parse(total.toStringAsFixed(2));
  }

  static int calculateRoundOff({required double finalTotal}) {
    return (finalTotal / 1).ceil();
  }

  static double calculateFinalTotal(
      {required Map<String, Map<String, dynamic>> cart}) {
    return calculateTaxableTotal(cart: cart) + calculateTaxTotal(cart: cart);
  }
}

import 'package:restaurant_pos/database/cart.dart';

class Calculations{

  static double? calculateCustomizationsTotal(dynamic customizations){
    double total = 0;
    for(Map<dynamic, dynamic> customization in customizations){
      total += customization['price'];
    }
    return total;
  }
  static double? getProductBillingPrice({required double? mrp, required double? salePrice}){
    if(mrp != null && salePrice != null){
      if(mrp >= salePrice){
        return salePrice;
      }else{
        return mrp;
      }
    }else if((mrp == null) && salePrice != null){
      return salePrice;
    }else if((salePrice == null) && mrp != null){
      return mrp;
    }else{
      return null;
    }
  }
  static double? getProductOtherPrice({required double? mrp, required double? salePrice}){
    if(mrp != null && salePrice != null){
      if(mrp > salePrice){
        return mrp;
      }
    }
    return null;
  }
  static String compressDoubleToString(double? value) {
    if (value != null) {
      if (value % 1 == 0) {
        return '${value.round()}';
      } else {
        return value.toString();
      }
    }
    return '';
  }
  static String? getAllTaxSlabsApplied({required Map<String, Map<String, dynamic>> cart}){
    List<String> taxSlabs = [];
    for(String id in cart.keys){
      double? taxSlab = cart[id]!['tax'];
      if(taxSlab != null){
        taxSlabs.add('$taxSlab%');
      }
    }
    return taxSlabs.isNotEmpty ? taxSlabs.join(", ") : null;
  }


  static double calculateTotal({required Map<String, Map<String, dynamic>> cart}){
    double total = 0;
    for(String id in cart.keys){
      double billingPrice = ((cart[id]!['mrp'] ?? cart[id]!['salePrice']) ?? cart[id]!['billingPrice']) ?? 0.0;
      double quantity = cart[id]!['quantity'];

      /*if(cart[id]!['taxType'] == 'inclusive'){

      }else if(cart[id]!['taxType'] == 'exclusive'){

      }*/
      
      total += billingPrice * quantity;
    }
    return total;
  }
  static double calculateDiscountTotal({required Map<String, Map<String, dynamic>> cart}){
    return (calculateTotal(cart: cart) - calculateTaxableTotal(cart: cart));
  }
  static double calculateAdditionalDiscountTotal({required Map<String, Map<String, dynamic>> cart}){
    double total = 0;
    for(String id in cart.keys){
      double billingPrice = cart[id]!['billingPrice'] ?? 0.0;
      double tax = cart[id]!['discount'] ?? 0.0;
      double quantity = cart[id]!['quantity'] ?? 0.0;
      total += (billingPrice * tax / 100) * quantity;
    }
    return total;
  }
  static double calculateTaxableTotal({required Map<String, Map<String, dynamic>> cart}){
    double total = 0;
    for(String id in cart.keys){
      double billingPrice = cart[id]!['billingPrice'] ?? 0.0;
      double quantity = cart[id]!['quantity'] ?? 0.0;
      total += billingPrice * quantity;
    }
    return total;
  }
  static double calculateTaxTotal({required Map<String, Map<String, dynamic>> cart}){
    double total = 0;
    for(String id in cart.keys){
      double billingPrice = cart[id]!['billingPrice'] ?? 0.0;
      double tax = cart[id]!['tax'] ?? 0.0;
      double quantity = cart[id]!['quantity'] ?? 0.0;
      total += (billingPrice * tax / 100) * quantity;
    }
    return total;
  }
  static double calculateFinalTotal({required Map<String, Map<String, dynamic>> cart}){
    return calculateTaxableTotal(cart: cart) + calculateTaxTotal(cart: cart);
  }
  static int calculateRoundOff({required double finalTotal}){
    return (finalTotal / 1).ceil();
  }
}

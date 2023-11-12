
import '../references.dart';

class OrderFunction{
  static double calculateTotalWithoutTax(List<Product> cart){
    double totalPrice = 0;
    for (var product in cart) {
      if(product.taxSlabId == null) {
        totalPrice += (product.salePrice ?? product.mrpPrice);
      } else {
        var taxSlab = EateryDB.instance.taxSlabBox!.values.where((element) => element.id == product.taxSlabId).firstOrNull;
        if (taxSlab == null) {
          totalPrice += (product.salePrice ?? product.mrpPrice);
        } else {
          if(taxSlab.type == TaxType.exclusive) {
            totalPrice += (product.salePrice ?? product.mrpPrice) * (1 + taxSlab.taxRate / 100);
          } else {
            totalPrice += (product.salePrice ?? product.mrpPrice) + taxSlab.taxRate;
          }
        }
      }
    }
    return totalPrice;
  }

  static double calculateTotalWithTax(List<Product> cart){

  }
}
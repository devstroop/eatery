import 'package:restaurant_pos/database/cart.dart';

class Calculations{
  static double? calculateSubtotal(){
    double subtotal = 0;
    for(dynamic id in Cart.cart.keys){
      double price = Cart.cart[id]!['price'];
      double quantity = Cart.cart[id]!['quantity'];
      subtotal += price * quantity;
    }
    return subtotal;
  }
  static double? calculateCustomizationsTotal(List<Map<String, dynamic>> customizations){
    double total = 0;
    for(Map<String, dynamic> customization in customizations){
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
      if(mrp > mrp){
        return mrp;
      }
    }
    return null;
  }
}

import 'package:eatery/references.dart';

extension CartExtension on List<OrderProduct> {
  double get getSubTotal {
    double subTotal = 0;
    for (var orderProduct in this) {
      subTotal += orderProduct.subTotal;
    }
    return subTotal;
  }

  double get getDiscountAmount {
    double discountAmount = 0;
    for (var orderProduct in this) {
      discountAmount += orderProduct.discountAmount ?? 0;
    }
    return discountAmount;
  }

  double get getTaxAmount {
    double taxAmount = 0;
    for (var orderProduct in this) {
      taxAmount += orderProduct.taxAmount ?? 0;
    }
    return taxAmount;
  }

  double get getGrandTotal {
    return getSubTotal - getDiscountAmount + getTaxAmount;
  }
}

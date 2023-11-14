import '../references.dart';

extension CustomerExtension on Customer {
  double get getOutstandingAmount {
    double outstandingAmount = 0;
    for (var order in EateryDB.instance.orderBox!.values.where((element) => element.customerPhone == phone)) {
      var payments = EateryDB.instance.paymentBox!.values.where((element) => element.orderId == order.id);
      if(payments.isNotEmpty){
        outstandingAmount += order.grandTotal - payments.map((e) => e.amount).reduce((value, element) => value + element);
      }
      else{
        outstandingAmount += order.grandTotal;
      }
    }
    return outstandingAmount;
  }
}
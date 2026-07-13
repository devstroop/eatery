/// Mappers between Hive models and sync DTOs.
library;

import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/dtos/dtos.dart';

// Product
extension ProductDtoX on ProductDto {
  Product toModel() => Product(
        name: name,
        categoryId: int.tryParse(categoryId ?? ''),
        description: description,
        image: image,
        mrpPrice: mrpPrice,
        salePrice: salePrice,
        taxSlabId: int.tryParse(taxSlabId ?? ''),
        foodType: foodType != null
            ? FoodType.values.firstWhere(
                (e) => (e.name ?? "").toLowerCase() == foodType!.toLowerCase(),
                orElse: () => FoodType.veg)
            : null,
        type: ProductType.values.firstWhere(
          (e) => (e.name ?? "").toLowerCase() == (productType ?? "inventoryItem").toLowerCase(),
          orElse: () => ProductType.inventoryItem,
        ),
        isActive: isActive,
      );
}
extension ProductX on Product {
  ProductDto toDto() => ProductDto(
        id: id?.toString(), name: name,
        categoryId: categoryId?.toString(),
        description: description, image: image,
        mrpPrice: mrpPrice, salePrice: salePrice,
        taxSlabId: taxSlabId?.toString(),
        foodType: foodType?.name, productType: type.name ?? "",
        isActive: isActive,
      );
}

// Customer
extension CustomerDtoX on CustomerDto {
  Customer toModel() => Customer(phone: phone, name: name, address: address, isActive: true);
}
extension CustomerX on Customer {
  CustomerDto toDto() => CustomerDto(id: id?.toString(), phone: phone, name: name, address: address);
}

// Payment
extension PaymentDtoX on PaymentDto {
  Payment toModel() => Payment(
        orderId: int.tryParse(orderId ?? '') ?? 0, amount: amount,
        mode: PaymentMode.values.firstWhere((e) => (e.name ?? "").toLowerCase() == (mode ?? "cash").toLowerCase(), orElse: () => PaymentMode.cash),
        reference: reference, processorTransactionId: processorTransactionId,
        processorName: processorName, processorStatus: processorStatus,
        cardLastFour: cardLastFour, terminalId: terminalId,
      );
}
extension PaymentX on Payment {
  PaymentDto toDto() => PaymentDto(
        id: id?.toString(), orderId: orderId?.toString(), date: date,
        amount: amount, mode: mode.name, reference: reference,
        processorTransactionId: processorTransactionId, processorName: processorName,
        processorStatus: processorStatus, cardLastFour: cardLastFour, terminalId: terminalId,
      );
}

// OrderProduct
extension OrderProductX on OrderProduct {
  OrderProductDto toDto() => OrderProductDto(
        productId: productId, productName: productName,
        quantity: quantity, price: price, subTotal: subTotal,
        discountRate: discountRate, discountAmount: discountAmount,
        taxRate: taxRate, taxAmount: taxAmount, total: total,
        stationId: stationId?.toString(), stationName: stationName,
      );
}

// Order
extension OrderDtoX on OrderDto {
  Order toModel() => Order(
        customerPhone: customerPhone, totalQuantity: totalQuantity,
        subTotal: subTotal, discountTotal: discountTotal,
        taxTotal: taxTotal, finalTotal: finalTotal,
        roundOff: roundOff, grandTotal: grandTotal, paidTotal: paidTotal,
        type: OrderType.values.firstWhere((e) => (e.name ?? "").toLowerCase() == (orderType ?? "dine").toLowerCase(), orElse: () => OrderType.dine),
      );
}
extension OrderX on Order {
  OrderDto toDto({String? deviceId, String? customerName, String? diningTableName, String? diningTableId, List<OrderProduct> products = const [], List<Payment> payments = const []}) => OrderDto(
        id: id?.toString(), deviceId: deviceId, customerPhone: customerPhone,
        customerName: customerName, createdAt: createdAt, updatedAt: updatedAt,
        totalQuantity: totalQuantity, subTotal: subTotal, discountTotal: discountTotal,
        taxTotal: taxTotal, finalTotal: finalTotal, roundOff: roundOff,
        grandTotal: grandTotal, paidTotal: paidTotal, orderType: type.name ?? "" ?? 'dine',
        diningTableName: diningTableName, diningTableId: diningTableId,
        products: products.map((p) => p.toDto()).toList(),
        payments: payments.map((p) => p.toDto()).toList(),
      );
}

// DiningTable
extension DiningTableDtoX on DiningTableDto {
  DiningTable toModel() => DiningTable(name: name, capacity: capacity, status: DiningTableStatus.values.firstWhere((e) => (e.name ?? "").toLowerCase() == status.toLowerCase(), orElse: () => DiningTableStatus.available));
}
extension DiningTableX on DiningTable {
  DiningTableDto toDto() => DiningTableDto(id: id?.toString(), name: name, capacity: capacity ?? 0, categoryId: category?.id?.toString(), status: status.name ?? "", orderId: orderId, customerPhone: customerPhone);
}

// Company
extension CompanyDtoX on CompanyDto {
  Company toModel() => Company(name: name, email: email, phone: phone, address: address, password: '', taxation: Taxation.none, currencyCode: currencyCode,
      salesTaxNumber: salesTaxNumber, foodLicenseNo: foodLicenseNo);
}
extension CompanyX on Company {
  CompanyDto toDto() => CompanyDto(id: id?.toString(), name: name, email: email, phone: phone, address: address,
      taxation: taxation.name, currencyCode: currencyCode, currencySymbol: '');
}

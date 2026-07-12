/// Models barrel — re-exports all Hive models and utilities.
library eatery_models;

// External packages (re-exported for convenience)
export 'package:hive_flutter/adapters.dart';
export 'package:hive/hive.dart';
export 'package:flutter/material.dart';
export 'dart:convert' show jsonEncode, jsonDecode;

// Order
export 'order/order_type.dart';
export 'order/order_product.dart';
export 'order/order.dart';

// Printer
export 'printer/printer_type.dart';
export 'printer/printer.dart';

// Product
export 'product/food_type.dart';
export 'product/product.dart';
export 'product/product_category.dart';
export 'product/product_type.dart';

// Subscription
export 'subscription/subscription.dart';
export 'subscription/subscription_type.dart';

// Company
export 'company/company.dart';
export 'company/edition.dart';
export 'company/k_currency.dart';

// Config
export 'config/auto_print.dart';

// Customer
export 'customer/customer.dart';

// Dining table
export 'dining_table/dining_table.dart';
export 'dining_table/dining_table_category.dart';
export 'dining_table/dining_table_status.dart';

// Tax
export 'tax/tax_slab.dart';
export 'tax/tax_type.dart';

// Staff
export 'staff/staff.dart';
export 'staff/staff_type.dart';

// Payment
export 'payment/payment.dart';
export 'payment/payment_mode.dart';

// Extensions
export 'extensions/box.extension.dart';

// Drawings
export 'drawings/dine_in.drawing.dart';
export 'drawings/delivery.drawing.dart';
export 'drawings/take_away.drawing.dart';

/// Hive TypeIndex constants.
/// WARNING: These values are persisted in user data.
/// Do NOT renumber — only append new types at the end.
class TypeIndex {
  TypeIndex._();

  static const company = 0;
  static const customer = 1;
  static const diningTable = 2;
  static const diningTableCategory = 3;
  static const order = 4;
  static const orderType = 5;
  static const printer = 6;
  static const printerType = 7;
  static const product = 8;
  static const productCategory = 9;
  static const productType = 10;
  static const foodType = 11;
  static const subscription = 12;
  static const subscriptionType = 13;
  static const taxSlab = 14;
  static const taxSlabType = 15;
  static const staff = 16;
  static const staffType = 17;
  static const edition = 18;
  static const currency = 19;
  static const autoPrint = 20;
  static const payment = 21;
  static const paymentMode = 22;
  static const diningTableStatus = 23;
  static const orderProduct = 24;
}

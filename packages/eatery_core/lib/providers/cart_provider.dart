import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery_core/data/repositories/order_repository.dart';
import 'package:eatery_core/data/repositories/product_repository.dart';
import 'package:eatery_core/data/repositories/customer_repository.dart';
import 'package:eatery_core/data/repositories/tax_repository.dart';
import 'package:eatery_core/data/repositories/dining_table_repository.dart';
import 'package:eatery_core/providers/order_provider.dart';

/// Active POS session state — replaces Common.cart / Common.activeOrder / etc.
class PosSession {
  final OrderType? activeOrderType;
  final DiningTable? activeDiningTable;
  final Customer? activeCustomer;
  final Order? activeOrder;
  final List<Product> cart;

  const PosSession({
    this.activeOrderType,
    this.activeDiningTable,
    this.activeCustomer,
    this.activeOrder,
    this.cart = const [],
  });

  PosSession copyWith({
    OrderType? activeOrderType,
    DiningTable? activeDiningTable,
    Customer? activeCustomer,
    Order? activeOrder,
    List<Product>? cart,
    bool clearOrderType = false,
    bool clearDiningTable = false,
    bool clearCustomer = false,
    bool clearOrder = false,
  }) {
    return PosSession(
      activeOrderType: clearOrderType
          ? null
          : (activeOrderType ?? this.activeOrderType),
      activeDiningTable: clearDiningTable
          ? null
          : (activeDiningTable ?? this.activeDiningTable),
      activeCustomer: clearCustomer
          ? null
          : (activeCustomer ?? this.activeCustomer),
      activeOrder: clearOrder ? null : (activeOrder ?? this.activeOrder),
      cart: cart ?? this.cart,
    );
  }
}

class CartNotifier extends Notifier<PosSession> {
  @override
  PosSession build() => const PosSession();

  void setOrderType(OrderType t) => state = state.copyWith(activeOrderType: t);
  void setDiningTable(DiningTable t) =>
      state = state.copyWith(activeDiningTable: t);
  void setCustomer(Customer c) => state = state.copyWith(activeCustomer: c);
  void setActiveOrder(Order o) => state = state.copyWith(activeOrder: o);

  void addToCart(Product product) {
    state = state.copyWith(cart: [...state.cart, product]);
  }

  void removeFromCart(Product product) {
    final idx = state.cart.indexOf(product);
    if (idx >= 0) {
      final updated = [...state.cart];
      updated.removeAt(idx);
      state = state.copyWith(cart: updated);
    }
  }

  int cartQuantity(Product product) {
    return state.cart.where((p) => p.id == product.id).length;
  }

  bool get hasCart => state.cart.isNotEmpty;

  void clearCart() => state = state.copyWith(
    cart: [],
    clearOrderType: true,
    clearDiningTable: true,
    clearCustomer: true,
    clearOrder: true,
  );
}

final cartProvider = NotifierProvider<CartNotifier, PosSession>(
  CartNotifier.new,
);

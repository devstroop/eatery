import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery_core/data/repositories/order_repository.dart';
import 'package:eatery_core/data/repositories/product_repository.dart';
import 'package:eatery_core/data/repositories/customer_repository.dart';
import 'package:eatery_core/data/repositories/tax_repository.dart';
import 'package:eatery_core/data/repositories/dining_table_repository.dart';
import 'package:eatery_core/providers/order_provider.dart';

/// A cart line item with quantity tracking.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get unitPrice => product.salePrice ?? product.mrpPrice;
  double get lineTotal => unitPrice * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);
}

/// Active POS session state.
class PosSession {
  final OrderType? activeOrderType;
  final DiningTable? activeDiningTable;
  final Customer? activeCustomer;
  final Order? activeOrder;
  final Map<int, CartItem> cart;

  const PosSession({
    this.activeOrderType,
    this.activeDiningTable,
    this.activeCustomer,
    this.activeOrder,
    this.cart = const {},
  });

  /// Flat list of products (one per CartItem entry) for backward compat.
  List<Product> get cartProducts => cart.values.map((e) => e.product).toList();
  int get cartTotalQuantity =>
      cart.values.fold(0, (sum, e) => sum + e.quantity);

  PosSession copyWith({
    OrderType? activeOrderType,
    DiningTable? activeDiningTable,
    Customer? activeCustomer,
    Order? activeOrder,
    Map<int, CartItem>? cart,
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
    final updated = Map<int, CartItem>.from(state.cart);
    final existing = updated[product.id];
    if (existing != null) {
      updated[product.id!] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      updated[product.id!] = CartItem(product: product);
    }
    state = state.copyWith(cart: updated);
  }

  void removeFromCart(Product product) {
    final updated = Map<int, CartItem>.from(state.cart);
    final existing = updated[product.id];
    if (existing == null) return;
    if (existing.quantity > 1) {
      updated[product.id!] = existing.copyWith(quantity: existing.quantity - 1);
    } else {
      updated.remove(product.id);
    }
    state = state.copyWith(cart: updated);
  }

  /// Returns the quantity of a specific product in the cart (0 if not present).
  int cartQuantity(Product product) {
    return state.cart[product.id]?.quantity ?? 0;
  }

  bool get hasCart => state.cart.isNotEmpty;

  void clearCart() => state = state.copyWith(
    cart: {},
    clearOrderType: true,
    clearDiningTable: true,
    clearCustomer: true,
    clearOrder: true,
  );
}

final cartProvider = NotifierProvider<CartNotifier, PosSession>(
  CartNotifier.new,
);

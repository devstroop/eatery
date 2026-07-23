import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/data/models/eatery_db.dart';

/// Generates a deterministic cart key that distinguishes modifier variants.
String _cartKey(int productId, Map<int, List<int>> modifiers) {
  if (modifiers.isEmpty) return 'p${productId}|';
  final entries = modifiers.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  final modPart = entries.map((e) => '${e.key}=${e.value.join(",")}').join("|");
  return 'p${productId}|$modPart';
}

/// A cart line item with quantity tracking.
class CartItem {
  final Product product;
  int quantity;

  /// Selected modifier IDs: groupId → list of modifierId.
  final Map<int, List<int>> modifiers;

  /// Price adjustment from selected modifiers.
  final double modifierPrice;

  /// Composite key derived from product ID and modifiers.
  /// Uses `|` as delimiter: "p<id>|" for plain, "p<id>|mods" for variants.
  String get cartKey {
    final pid = product.id;
    if (pid == null)
      throw ArgumentError('CartItem requires non-null product.id');
    return _cartKey(pid, modifiers);
  }

  CartItem({
    required this.product,
    this.quantity = 1,
    this.modifiers = const {},
    this.modifierPrice = 0,
  });

  double get unitPrice =>
      (product.salePrice ?? product.mrpPrice) + modifierPrice;
  double get lineTotal => unitPrice * quantity;

  CartItem copyWith({
    int? quantity,
    Map<int, List<int>>? modifiers,
    double? modifierPrice,
  }) => CartItem(
    product: product,
    quantity: quantity ?? this.quantity,
    modifiers: modifiers ?? this.modifiers,
    modifierPrice: modifierPrice ?? this.modifierPrice,
  );
}

/// Active POS session state.
class PosSession {
  final OrderType? activeOrderType;
  final DiningTable? activeDiningTable;
  final Customer? activeCustomer;
  final Order? activeOrder;
  final Map<String, CartItem> cart;

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

  /// Whether this product (any modifier variant) is in the cart.
  bool containsProduct(int productId) =>
      cart.keys.any((k) => k.startsWith('p${productId}|'));

  /// Total quantity of this product across all modifier variants.
  int cartQuantity(Product product) => cart.entries
      .where((e) => e.key.startsWith('p${product.id}|'))
      .fold(0, (sum, e) => sum + e.value.quantity);

  PosSession copyWith({
    OrderType? activeOrderType,
    DiningTable? activeDiningTable,
    Customer? activeCustomer,
    Order? activeOrder,
    Map<String, CartItem>? cart,
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

  void addToCart(
    Product product, {
    Map<int, List<int>>? modifiers,
    double modifierPrice = 0,
  }) {
    final pid = product.id;
    if (pid == null) return;
    final mods = modifiers ?? <int, List<int>>{};
    final key = _cartKey(pid, mods);
    final updated = Map<String, CartItem>.from(state.cart);
    final existing = updated[key];
    if (existing != null) {
      updated[key] = existing.copyWith(
        quantity: existing.quantity + 1,
        modifiers: mods,
        modifierPrice: modifierPrice,
      );
    } else {
      updated[key] = CartItem(
        product: product,
        modifiers: mods,
        modifierPrice: modifierPrice,
      );
    }
    state = state.copyWith(cart: updated);
  }

  /// Returns the cart key for this product with no modifiers (plain entry).
  static String plainCartKey(Product product) => _cartKey(product.id ?? 0, {});

  /// Removes one unit of [product] from the cart.
  ///
  /// If [cartKey] is provided, removes from that specific variant.
  /// Otherwise removes from the first matching entry (any modifier variant).
  void removeFromCart(Product product, {String? cartKey}) {
    final pid = product.id;
    if (pid == null) return;
    final updated = Map<String, CartItem>.from(state.cart);
    final matchKey =
        cartKey ??
        state.cart.keys.firstWhere(
          (k) => k.startsWith('p${pid}|'),
          orElse: () => '',
        );
    if (matchKey.isEmpty) return;
    final existing = updated[matchKey];
    if (existing == null) return;
    if (existing.quantity > 1) {
      updated[matchKey] = existing.copyWith(quantity: existing.quantity - 1);
    } else {
      updated.remove(matchKey);
    }
    state = state.copyWith(cart: updated);
  }

  /// Total quantity of this product across all modifier variants.
  int cartQuantity(Product product) {
    final pid = product.id;
    if (pid == null) return 0;
    return state.cart.entries
        .where((e) => e.key.startsWith('p${pid}|'))
        .fold(0, (sum, e) => sum + e.value.quantity);
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

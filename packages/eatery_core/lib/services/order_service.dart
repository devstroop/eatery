import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/order_repository.dart';
import 'package:eatery_core/data/repositories/dining_table_repository.dart';
import 'package:eatery_core/data/models/cart_item.dart' as cart;

/// Handles order creation and editing business logic.
///
/// Extracted from the cart page to be testable and reusable
/// across admin POS and waiter app. Assigns [currentStaffId] to
/// new orders when provided.
class OrderService {
  final OrderRepository orderRepo;
  final DiningTableRepository tableRepo;
  final int? currentStaffId;

  OrderService({
    required this.orderRepo,
    required this.tableRepo,
    this.currentStaffId,
  });

  /// Places a new order from the cart.
  ///
  /// Returns the saved [Order]. Does NOT handle UI concerns
  /// (dialogs, navigation, validation).
  Future<Order> placeOrder({
    required Map<int, cart.CartItem> cart,
    required Customer customer,
    required OrderType type,
    DiningTable? diningTable,
    Order? existingOrder,
  }) async {
    if (existingOrder != null) {
      return _updateExistingOrder(existingOrder, cart, customer.phone);
    }
    return _createNewOrder(cart, customer, type, diningTable);
  }

  Future<Order> _createNewOrder(
    Map<int, cart.CartItem> cart,
    Customer customer,
    OrderType type,
    DiningTable? diningTable,
  ) async {
    final cartProducts = cart.values.map((e) => e.product).toList();
    final totalQty = cart.values.fold(0, (sum, e) => sum + e.quantity);

    final order = Order(
      customerPhone: customer.phone,
      staffId: currentStaffId,
      type: type,
      status: OrderStatus.pending,
      totalQuantity: totalQty,
      subTotal: _subtotal(cartProducts),
      discountTotal: 0,
      taxTotal: _taxTotal(cartProducts),
      finalTotal: _finalTotal(cartProducts),
      roundOff: _roundOff(cartProducts),
      grandTotal: _grandTotal(cartProducts),
      paidTotal: null,
      createdAt: DateTime.now(),
    );

    final orderId = await orderRepo.saveOrder(order);

    for (final entry in cart.entries) {
      final item = entry.value;
      final p = item.product;
      for (var i = 0; i < item.quantity; i++) {
        await orderRepo.addOrderProduct(
          OrderProduct(
            orderId: orderId,
            productId: p.id,
            productName: p.name,
            quantity: 1,
            price: p.salePrice ?? p.mrpPrice,
            subTotal: p.salePrice ?? p.mrpPrice,
            total: p.salePrice ?? p.mrpPrice,
            stationId: p.stationId,
            stationName: p.stationName,
          ),
        );
      }
      // Auto-adjust inventory stock for inventory items
      if (p.type == ProductType.inventoryItem && p.id != null) {
        orderRepo.adjustStock(p.id!, -item.quantity);
      }
    }

    // Mark dining table as occupied
    if (type == OrderType.dine && diningTable != null) {
      await tableRepo.saveTable(
        diningTable.copyWith(
          status: DiningTableStatus.occupied,
          orderId: orderId,
          customerPhone: customer.phone,
        ),
      );
    }

    return order.copyWith(id: orderId);
  }

  Future<Order> _updateExistingOrder(
    Order existingOrder,
    Map<int, cart.CartItem> cart,
    String customerPhone,
  ) async {
    for (final entry in cart.entries) {
      final item = entry.value;
      final p = item.product;

      final existing = orderRepo
          .getOrderProducts(existingOrder.id!)
          .where((op) => op.productId == p.id)
          .firstOrNull;

      if (existing != null) {
        // Update quantity of existing line item
        final newQty = existing.quantity + item.quantity;
        final unitPrice = p.salePrice ?? p.mrpPrice;
        await orderRepo.saveOrderProduct(
          existing.copyWith(
            quantity: newQty,
            price: unitPrice,
            subTotal: unitPrice * newQty,
            total: unitPrice * newQty,
          ),
        );
      } else {
        // Add new line item
        for (var i = 0; i < item.quantity; i++) {
          await orderRepo.addOrderProduct(
            OrderProduct(
              orderId: existingOrder.id!,
              productId: p.id,
              productName: p.name,
              quantity: 1,
              price: p.salePrice ?? p.mrpPrice,
              subTotal: p.salePrice ?? p.mrpPrice,
              total: p.salePrice ?? p.mrpPrice,
              stationId: p.stationId,
              stationName: p.stationName,
            ),
          );
        }
      }
    }

    // Recalculate totals
    final allItems = orderRepo.getOrderProducts(existingOrder.id!);
    final products = allItems
        .map(
          (op) => Product(
            name: op.productName,
            mrpPrice: op.price,
            type: ProductType.kitchenDish,
            isActive: true,
            id: op.productId,
          ),
        )
        .toList();

    final totalQty = allItems.fold(0, (s, op) => s + op.quantity);
    final updated = existingOrder.copyWith(
      totalQuantity: totalQty,
      subTotal: _subtotal(products),
      discountTotal: 0,
      taxTotal: _taxTotal(products),
      finalTotal: _finalTotal(products),
      roundOff: _roundOff(products),
      grandTotal: _grandTotal(products),
      updatedAt: DateTime.now(),
    );
    await orderRepo.saveOrder(updated);
    return updated;
  }

  double _subtotal(List<Product> cart) =>
      cart.fold(0.0, (s, p) => s + (p.salePrice ?? p.mrpPrice));

  double _taxTotal(List<Product> cart) =>
      _subtotal(cart) * 0.05; // Simplified: 5% default tax

  double _finalTotal(List<Product> cart) => _subtotal(cart) * 1.05;

  double _roundOff(List<Product> cart) =>
      (_finalTotal(cart).round() - _finalTotal(cart));

  double _grandTotal(List<Product> cart) => _finalTotal(cart) + _roundOff(cart);
}

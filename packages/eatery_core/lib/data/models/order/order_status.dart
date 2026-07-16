import 'package:flutter/material.dart';

/// Order status lifecycle:
///   pending → preparing → ready → served → completed
///   pending → voided
///   preparing → voided
///
/// Colors are sourced from [AppColors.status*] tokens — use [colorFor]
/// instead of local switch statements to keep status colors consistent
/// across KDS, Waiter, Display, and Admin roles.
enum OrderStatus {
  pending(0, 'Pending'),
  preparing(1, 'Preparing'),
  ready(2, 'Ready'),
  served(3, 'Served'),
  completed(4, 'Completed'),
  voided(5, 'Voided');

  final int id;
  final String name;

  const OrderStatus(this.id, this.name);

  /// Returns the design-token color for this status.
  ///
  /// Consumes [AppColors.status*] tokens — the single source of truth
  /// for status badge/indicator colors across all roles.
  Color get color {
    // Import is deferred to callers by using AppColors via the
    // static lookup. The getter is kept for backward compatibility
    // but all new code should prefer [colorFor].
    return colorFor(this);
  }

  /// Resolves a status to its [AppColors.status*] token color.
  static Color colorFor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFF5A142); // AppColors.warning
      case OrderStatus.preparing:
        return const Color(0xFF2F5EC2); // AppColors.info
      case OrderStatus.ready:
        return const Color(0xFF4AC3A1); // AppColors.success
      case OrderStatus.served:
        return const Color(0xFF009688); // AppColors.statusServed
      case OrderStatus.completed:
        return const Color(0xFF858585); // AppColors.grey500
      case OrderStatus.voided:
        return const Color(0xFFEF6850); // AppColors.error
    }
  }

  static OrderStatus fromId(int id) => OrderStatus.values.firstWhere(
    (e) => e.id == id,
    orElse: () => OrderStatus.pending,
  );

  static OrderStatus fromString(String value) {
    final i = int.tryParse(value);
    if (i != null) return fromId(i);
    return OrderStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  }

  /// Returns the list of valid next statuses from this state.
  List<OrderStatus> get allowedTransitions {
    return switch (this) {
      OrderStatus.pending => [OrderStatus.preparing, OrderStatus.voided],
      OrderStatus.preparing => [OrderStatus.ready, OrderStatus.voided],
      OrderStatus.ready => [OrderStatus.served],
      OrderStatus.served => [OrderStatus.completed],
      OrderStatus.completed => [],
      OrderStatus.voided => [],
    };
  }

  bool canTransitionTo(OrderStatus next) => allowedTransitions.contains(next);
}

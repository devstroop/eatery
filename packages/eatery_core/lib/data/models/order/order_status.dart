import 'package:flutter/material.dart';

/// Order status lifecycle:
///   pending → preparing → ready → served → completed
///   pending → voided
///   preparing → voided
enum OrderStatus {
  pending(0, 'Pending', Colors.orange),
  preparing(1, 'Preparing', Colors.blue),
  ready(2, 'Ready', Colors.green),
  served(3, 'Served', Colors.teal),
  completed(4, 'Completed', Colors.grey),
  voided(5, 'Voided', Colors.red);

  final int id;
  final String name;
  final Color color;

  const OrderStatus(this.id, this.name, this.color);

  static OrderStatus fromId(int id) =>
      OrderStatus.values.firstWhere((e) => e.id == id, orElse: () => OrderStatus.pending);

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

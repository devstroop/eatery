import 'package:eatery_core/data/models/converters.dart';
import 'package:eatery_core/data/models/order/order_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_status_history.freezed.dart';
part 'order_status_history.g.dart';

@freezed
abstract class OrderStatusHistory with _$OrderStatusHistory {
  const factory OrderStatusHistory({
    int? id,
    required int orderId,
    required int fromStatus,
    required int toStatus,
    int? changedByStaffId,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime changedAt,
    String? reason,
  }) = _OrderStatusHistory;

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusHistoryFromJson(json);

  static OrderStatusHistory fromMap(Map<String, dynamic> map) =>
      OrderStatusHistory.fromJson(map);
}

extension OrderStatusHistoryX on OrderStatusHistory {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

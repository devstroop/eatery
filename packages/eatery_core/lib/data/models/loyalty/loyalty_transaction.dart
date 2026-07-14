import 'package:freezed_annotation/freezed_annotation.dart'; import 'package:eatery_core/data/models/converters.dart';
part 'loyalty_transaction.freezed.dart'; part 'loyalty_transaction.g.dart';
@freezed
abstract class LoyaltyTransaction with _$LoyaltyTransaction {
  const factory LoyaltyTransaction({int? id, required int customerId, required double points, required int type,
    int? referenceId, String? description, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required DateTime createdAt}) = _LoyaltyTransaction;
  factory LoyaltyTransaction.fromJson(Map<String, dynamic> json) => _$LoyaltyTransactionFromJson(json);
  static LoyaltyTransaction fromMap(Map<String, dynamic> map) => LoyaltyTransaction.fromJson(map);
}
extension LoyaltyTransactionX on LoyaltyTransaction { Map<String, Object?> toMap() => toJson() as Map<String, Object?>; }

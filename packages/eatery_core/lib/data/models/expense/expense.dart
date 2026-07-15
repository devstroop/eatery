import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eatery_core/data/models/converters.dart';
part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    int? id,
    int? categoryId,
    required double amount,
    required String description,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime expenseDate,
    @Default(0) int paymentMode,
    String? reference,
    String? receipt,
    int? createdBy,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime createdAt,
  }) = _Expense;
  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
  static Expense fromMap(Map<String, dynamic> map) => Expense.fromJson(map);
}

extension ExpenseX on Expense {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

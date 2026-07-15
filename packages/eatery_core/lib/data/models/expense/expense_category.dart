import 'package:freezed_annotation/freezed_annotation.dart';
part 'expense_category.freezed.dart';
part 'expense_category.g.dart';

@freezed
abstract class ExpenseCategory with _$ExpenseCategory {
  const factory ExpenseCategory({
    int? id,
    required String name,
    String? description,
    @Default(true) bool isActive,
  }) = _ExpenseCategory;
  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryFromJson(json);
  static ExpenseCategory fromMap(Map<String, dynamic> map) =>
      ExpenseCategory.fromJson(map);
}

extension ExpenseCategoryX on ExpenseCategory {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

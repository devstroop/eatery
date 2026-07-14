// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: (json['id'] as num?)?.toInt(),
  categoryId: (json['categoryId'] as num?)?.toInt(),
  amount: (json['amount'] as num).toDouble(),
  description: json['description'] as String,
  expenseDate: epochFromJson((json['expenseDate'] as num).toInt()),
  paymentMode: (json['paymentMode'] as num?)?.toInt() ?? 0,
  reference: json['reference'] as String?,
  receipt: json['receipt'] as String?,
  createdBy: (json['createdBy'] as num?)?.toInt(),
  createdAt: epochFromJson((json['createdAt'] as num).toInt()),
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'categoryId': instance.categoryId,
  'amount': instance.amount,
  'description': instance.description,
  'expenseDate': epochToJson(instance.expenseDate),
  'paymentMode': instance.paymentMode,
  'reference': instance.reference,
  'receipt': instance.receipt,
  'createdBy': instance.createdBy,
  'createdAt': epochToJson(instance.createdAt),
};

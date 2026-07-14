// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'k_currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KCurrency _$KCurrencyFromJson(Map<String, dynamic> json) => _KCurrency(
  code: json['code'] as String,
  name: json['name'] as String,
  symbol: json['symbol'] as String,
  flag: json['flag'] as String?,
  number: (json['number'] as num).toInt(),
  decimalDigits: (json['decimal_digits'] as num).toInt(),
  namePlural: json['name_plural'] as String,
  decimalSeparator: json['decimal_separator'] as String,
  thousandsSeparator: json['thousands_separator'] as String,
  symbolOnLeft: json['symbol_on_left'] as bool,
  spaceBetweenAmountAndSymbol: json['space_between_amount_and_symbol'] as bool,
);

Map<String, dynamic> _$KCurrencyToJson(_KCurrency instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'symbol': instance.symbol,
      'flag': instance.flag,
      'number': instance.number,
      'decimal_digits': instance.decimalDigits,
      'name_plural': instance.namePlural,
      'decimal_separator': instance.decimalSeparator,
      'thousands_separator': instance.thousandsSeparator,
      'symbol_on_left': instance.symbolOnLeft,
      'space_between_amount_and_symbol': instance.spaceBetweenAmountAndSymbol,
    };

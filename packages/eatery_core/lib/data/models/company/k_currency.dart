import 'package:freezed_annotation/freezed_annotation.dart';

part 'k_currency.freezed.dart';
part 'k_currency.g.dart';

@freezed
abstract class KCurrency with _$KCurrency {
  const factory KCurrency({
    required String code,
    required String name,
    required String symbol,
    String? flag,
    required int number,
    @JsonKey(name: 'decimal_digits') required int decimalDigits,
    @JsonKey(name: 'name_plural') required String namePlural,
    @JsonKey(name: 'decimal_separator') required String decimalSeparator,
    @JsonKey(name: 'thousands_separator') required String thousandsSeparator,
    @JsonKey(name: 'symbol_on_left') required bool symbolOnLeft,
    @JsonKey(name: 'space_between_amount_and_symbol')
    required bool spaceBetweenAmountAndSymbol,
  }) = _KCurrency;

  factory KCurrency.fromJson(Map<String, dynamic> json) =>
      _$KCurrencyFromJson(json);

  static KCurrency fromMap(Map<String, dynamic> map) => KCurrency.fromJson(map);

  static KCurrency fromIterable(Iterable<dynamic> list) {
    return KCurrency.fromMap({
      'code': list.elementAt(0),
      'name': list.elementAt(1),
      'symbol': list.elementAt(2),
      'number': list.elementAt(3),
      'flag': list.elementAt(4),
      'decimal_digits': list.elementAt(5),
      'name_plural': list.elementAt(6),
      'symbol_on_left': list.elementAt(7),
      'decimal_separator': list.elementAt(8),
      'thousands_separator': list.elementAt(9),
      'space_between_amount_and_symbol': list.elementAt(10),
    });
  }
}

extension KCurrencyX on KCurrency {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  Iterable<dynamic> toIterable() {
    var map = toMap();
    return [
      map['code'],
      map['name'],
      map['symbol'],
      map['number'],
      map['flag'],
      map['decimal_digits'],
      map['name_plural'],
      map['symbol_on_left'],
      map['decimal_separator'],
      map['thousands_separator'],
      map['space_between_amount_and_symbol'],
    ];
  }
}

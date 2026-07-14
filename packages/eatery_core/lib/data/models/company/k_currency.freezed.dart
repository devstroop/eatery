// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'k_currency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KCurrency {

 String get code; String get name; String get symbol; String? get flag; int get number;@JsonKey(name: 'decimal_digits') int get decimalDigits;@JsonKey(name: 'name_plural') String get namePlural;@JsonKey(name: 'decimal_separator') String get decimalSeparator;@JsonKey(name: 'thousands_separator') String get thousandsSeparator;@JsonKey(name: 'symbol_on_left') bool get symbolOnLeft;@JsonKey(name: 'space_between_amount_and_symbol') bool get spaceBetweenAmountAndSymbol;
/// Create a copy of KCurrency
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KCurrencyCopyWith<KCurrency> get copyWith => _$KCurrencyCopyWithImpl<KCurrency>(this as KCurrency, _$identity);

  /// Serializes this KCurrency to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KCurrency&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.flag, flag) || other.flag == flag)&&(identical(other.number, number) || other.number == number)&&(identical(other.decimalDigits, decimalDigits) || other.decimalDigits == decimalDigits)&&(identical(other.namePlural, namePlural) || other.namePlural == namePlural)&&(identical(other.decimalSeparator, decimalSeparator) || other.decimalSeparator == decimalSeparator)&&(identical(other.thousandsSeparator, thousandsSeparator) || other.thousandsSeparator == thousandsSeparator)&&(identical(other.symbolOnLeft, symbolOnLeft) || other.symbolOnLeft == symbolOnLeft)&&(identical(other.spaceBetweenAmountAndSymbol, spaceBetweenAmountAndSymbol) || other.spaceBetweenAmountAndSymbol == spaceBetweenAmountAndSymbol));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,symbol,flag,number,decimalDigits,namePlural,decimalSeparator,thousandsSeparator,symbolOnLeft,spaceBetweenAmountAndSymbol);

@override
String toString() {
  return 'KCurrency(code: $code, name: $name, symbol: $symbol, flag: $flag, number: $number, decimalDigits: $decimalDigits, namePlural: $namePlural, decimalSeparator: $decimalSeparator, thousandsSeparator: $thousandsSeparator, symbolOnLeft: $symbolOnLeft, spaceBetweenAmountAndSymbol: $spaceBetweenAmountAndSymbol)';
}


}

/// @nodoc
abstract mixin class $KCurrencyCopyWith<$Res>  {
  factory $KCurrencyCopyWith(KCurrency value, $Res Function(KCurrency) _then) = _$KCurrencyCopyWithImpl;
@useResult
$Res call({
 String code, String name, String symbol, String? flag, int number,@JsonKey(name: 'decimal_digits') int decimalDigits,@JsonKey(name: 'name_plural') String namePlural,@JsonKey(name: 'decimal_separator') String decimalSeparator,@JsonKey(name: 'thousands_separator') String thousandsSeparator,@JsonKey(name: 'symbol_on_left') bool symbolOnLeft,@JsonKey(name: 'space_between_amount_and_symbol') bool spaceBetweenAmountAndSymbol
});




}
/// @nodoc
class _$KCurrencyCopyWithImpl<$Res>
    implements $KCurrencyCopyWith<$Res> {
  _$KCurrencyCopyWithImpl(this._self, this._then);

  final KCurrency _self;
  final $Res Function(KCurrency) _then;

/// Create a copy of KCurrency
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? symbol = null,Object? flag = freezed,Object? number = null,Object? decimalDigits = null,Object? namePlural = null,Object? decimalSeparator = null,Object? thousandsSeparator = null,Object? symbolOnLeft = null,Object? spaceBetweenAmountAndSymbol = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,flag: freezed == flag ? _self.flag : flag // ignore: cast_nullable_to_non_nullable
as String?,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,decimalDigits: null == decimalDigits ? _self.decimalDigits : decimalDigits // ignore: cast_nullable_to_non_nullable
as int,namePlural: null == namePlural ? _self.namePlural : namePlural // ignore: cast_nullable_to_non_nullable
as String,decimalSeparator: null == decimalSeparator ? _self.decimalSeparator : decimalSeparator // ignore: cast_nullable_to_non_nullable
as String,thousandsSeparator: null == thousandsSeparator ? _self.thousandsSeparator : thousandsSeparator // ignore: cast_nullable_to_non_nullable
as String,symbolOnLeft: null == symbolOnLeft ? _self.symbolOnLeft : symbolOnLeft // ignore: cast_nullable_to_non_nullable
as bool,spaceBetweenAmountAndSymbol: null == spaceBetweenAmountAndSymbol ? _self.spaceBetweenAmountAndSymbol : spaceBetweenAmountAndSymbol // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [KCurrency].
extension KCurrencyPatterns on KCurrency {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KCurrency value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KCurrency() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KCurrency value)  $default,){
final _that = this;
switch (_that) {
case _KCurrency():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KCurrency value)?  $default,){
final _that = this;
switch (_that) {
case _KCurrency() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  String symbol,  String? flag,  int number, @JsonKey(name: 'decimal_digits')  int decimalDigits, @JsonKey(name: 'name_plural')  String namePlural, @JsonKey(name: 'decimal_separator')  String decimalSeparator, @JsonKey(name: 'thousands_separator')  String thousandsSeparator, @JsonKey(name: 'symbol_on_left')  bool symbolOnLeft, @JsonKey(name: 'space_between_amount_and_symbol')  bool spaceBetweenAmountAndSymbol)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KCurrency() when $default != null:
return $default(_that.code,_that.name,_that.symbol,_that.flag,_that.number,_that.decimalDigits,_that.namePlural,_that.decimalSeparator,_that.thousandsSeparator,_that.symbolOnLeft,_that.spaceBetweenAmountAndSymbol);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  String symbol,  String? flag,  int number, @JsonKey(name: 'decimal_digits')  int decimalDigits, @JsonKey(name: 'name_plural')  String namePlural, @JsonKey(name: 'decimal_separator')  String decimalSeparator, @JsonKey(name: 'thousands_separator')  String thousandsSeparator, @JsonKey(name: 'symbol_on_left')  bool symbolOnLeft, @JsonKey(name: 'space_between_amount_and_symbol')  bool spaceBetweenAmountAndSymbol)  $default,) {final _that = this;
switch (_that) {
case _KCurrency():
return $default(_that.code,_that.name,_that.symbol,_that.flag,_that.number,_that.decimalDigits,_that.namePlural,_that.decimalSeparator,_that.thousandsSeparator,_that.symbolOnLeft,_that.spaceBetweenAmountAndSymbol);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  String symbol,  String? flag,  int number, @JsonKey(name: 'decimal_digits')  int decimalDigits, @JsonKey(name: 'name_plural')  String namePlural, @JsonKey(name: 'decimal_separator')  String decimalSeparator, @JsonKey(name: 'thousands_separator')  String thousandsSeparator, @JsonKey(name: 'symbol_on_left')  bool symbolOnLeft, @JsonKey(name: 'space_between_amount_and_symbol')  bool spaceBetweenAmountAndSymbol)?  $default,) {final _that = this;
switch (_that) {
case _KCurrency() when $default != null:
return $default(_that.code,_that.name,_that.symbol,_that.flag,_that.number,_that.decimalDigits,_that.namePlural,_that.decimalSeparator,_that.thousandsSeparator,_that.symbolOnLeft,_that.spaceBetweenAmountAndSymbol);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KCurrency implements KCurrency {
  const _KCurrency({required this.code, required this.name, required this.symbol, this.flag, required this.number, @JsonKey(name: 'decimal_digits') required this.decimalDigits, @JsonKey(name: 'name_plural') required this.namePlural, @JsonKey(name: 'decimal_separator') required this.decimalSeparator, @JsonKey(name: 'thousands_separator') required this.thousandsSeparator, @JsonKey(name: 'symbol_on_left') required this.symbolOnLeft, @JsonKey(name: 'space_between_amount_and_symbol') required this.spaceBetweenAmountAndSymbol});
  factory _KCurrency.fromJson(Map<String, dynamic> json) => _$KCurrencyFromJson(json);

@override final  String code;
@override final  String name;
@override final  String symbol;
@override final  String? flag;
@override final  int number;
@override@JsonKey(name: 'decimal_digits') final  int decimalDigits;
@override@JsonKey(name: 'name_plural') final  String namePlural;
@override@JsonKey(name: 'decimal_separator') final  String decimalSeparator;
@override@JsonKey(name: 'thousands_separator') final  String thousandsSeparator;
@override@JsonKey(name: 'symbol_on_left') final  bool symbolOnLeft;
@override@JsonKey(name: 'space_between_amount_and_symbol') final  bool spaceBetweenAmountAndSymbol;

/// Create a copy of KCurrency
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KCurrencyCopyWith<_KCurrency> get copyWith => __$KCurrencyCopyWithImpl<_KCurrency>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KCurrencyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KCurrency&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.flag, flag) || other.flag == flag)&&(identical(other.number, number) || other.number == number)&&(identical(other.decimalDigits, decimalDigits) || other.decimalDigits == decimalDigits)&&(identical(other.namePlural, namePlural) || other.namePlural == namePlural)&&(identical(other.decimalSeparator, decimalSeparator) || other.decimalSeparator == decimalSeparator)&&(identical(other.thousandsSeparator, thousandsSeparator) || other.thousandsSeparator == thousandsSeparator)&&(identical(other.symbolOnLeft, symbolOnLeft) || other.symbolOnLeft == symbolOnLeft)&&(identical(other.spaceBetweenAmountAndSymbol, spaceBetweenAmountAndSymbol) || other.spaceBetweenAmountAndSymbol == spaceBetweenAmountAndSymbol));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,symbol,flag,number,decimalDigits,namePlural,decimalSeparator,thousandsSeparator,symbolOnLeft,spaceBetweenAmountAndSymbol);

@override
String toString() {
  return 'KCurrency(code: $code, name: $name, symbol: $symbol, flag: $flag, number: $number, decimalDigits: $decimalDigits, namePlural: $namePlural, decimalSeparator: $decimalSeparator, thousandsSeparator: $thousandsSeparator, symbolOnLeft: $symbolOnLeft, spaceBetweenAmountAndSymbol: $spaceBetweenAmountAndSymbol)';
}


}

/// @nodoc
abstract mixin class _$KCurrencyCopyWith<$Res> implements $KCurrencyCopyWith<$Res> {
  factory _$KCurrencyCopyWith(_KCurrency value, $Res Function(_KCurrency) _then) = __$KCurrencyCopyWithImpl;
@override @useResult
$Res call({
 String code, String name, String symbol, String? flag, int number,@JsonKey(name: 'decimal_digits') int decimalDigits,@JsonKey(name: 'name_plural') String namePlural,@JsonKey(name: 'decimal_separator') String decimalSeparator,@JsonKey(name: 'thousands_separator') String thousandsSeparator,@JsonKey(name: 'symbol_on_left') bool symbolOnLeft,@JsonKey(name: 'space_between_amount_and_symbol') bool spaceBetweenAmountAndSymbol
});




}
/// @nodoc
class __$KCurrencyCopyWithImpl<$Res>
    implements _$KCurrencyCopyWith<$Res> {
  __$KCurrencyCopyWithImpl(this._self, this._then);

  final _KCurrency _self;
  final $Res Function(_KCurrency) _then;

/// Create a copy of KCurrency
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? symbol = null,Object? flag = freezed,Object? number = null,Object? decimalDigits = null,Object? namePlural = null,Object? decimalSeparator = null,Object? thousandsSeparator = null,Object? symbolOnLeft = null,Object? spaceBetweenAmountAndSymbol = null,}) {
  return _then(_KCurrency(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,flag: freezed == flag ? _self.flag : flag // ignore: cast_nullable_to_non_nullable
as String?,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,decimalDigits: null == decimalDigits ? _self.decimalDigits : decimalDigits // ignore: cast_nullable_to_non_nullable
as int,namePlural: null == namePlural ? _self.namePlural : namePlural // ignore: cast_nullable_to_non_nullable
as String,decimalSeparator: null == decimalSeparator ? _self.decimalSeparator : decimalSeparator // ignore: cast_nullable_to_non_nullable
as String,thousandsSeparator: null == thousandsSeparator ? _self.thousandsSeparator : thousandsSeparator // ignore: cast_nullable_to_non_nullable
as String,symbolOnLeft: null == symbolOnLeft ? _self.symbolOnLeft : symbolOnLeft // ignore: cast_nullable_to_non_nullable
as bool,spaceBetweenAmountAndSymbol: null == spaceBetweenAmountAndSymbol ? _self.spaceBetweenAmountAndSymbol : spaceBetweenAmountAndSymbol // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

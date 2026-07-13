// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderProduct {

 int? get id; int? get orderId; int? get productId; String get productName; int get quantity; double get price; double get subTotal; double? get discountRate; double? get discountAmount; double? get taxRate; double? get taxAmount; double get total; int? get stationId; String? get stationName;
/// Create a copy of OrderProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderProductCopyWith<OrderProduct> get copyWith => _$OrderProductCopyWithImpl<OrderProduct>(this as OrderProduct, _$identity);

  /// Serializes this OrderProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.discountRate, discountRate) || other.discountRate == discountRate)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.total, total) || other.total == total)&&(identical(other.stationId, stationId) || other.stationId == stationId)&&(identical(other.stationName, stationName) || other.stationName == stationName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,productId,productName,quantity,price,subTotal,discountRate,discountAmount,taxRate,taxAmount,total,stationId,stationName);

@override
String toString() {
  return 'OrderProduct(id: $id, orderId: $orderId, productId: $productId, productName: $productName, quantity: $quantity, price: $price, subTotal: $subTotal, discountRate: $discountRate, discountAmount: $discountAmount, taxRate: $taxRate, taxAmount: $taxAmount, total: $total, stationId: $stationId, stationName: $stationName)';
}


}

/// @nodoc
abstract mixin class $OrderProductCopyWith<$Res>  {
  factory $OrderProductCopyWith(OrderProduct value, $Res Function(OrderProduct) _then) = _$OrderProductCopyWithImpl;
@useResult
$Res call({
 int? id, int? orderId, int? productId, String productName, int quantity, double price, double subTotal, double? discountRate, double? discountAmount, double? taxRate, double? taxAmount, double total, int? stationId, String? stationName
});




}
/// @nodoc
class _$OrderProductCopyWithImpl<$Res>
    implements $OrderProductCopyWith<$Res> {
  _$OrderProductCopyWithImpl(this._self, this._then);

  final OrderProduct _self;
  final $Res Function(OrderProduct) _then;

/// Create a copy of OrderProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? orderId = freezed,Object? productId = freezed,Object? productName = null,Object? quantity = null,Object? price = null,Object? subTotal = null,Object? discountRate = freezed,Object? discountAmount = freezed,Object? taxRate = freezed,Object? taxAmount = freezed,Object? total = null,Object? stationId = freezed,Object? stationName = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,discountRate: freezed == discountRate ? _self.discountRate : discountRate // ignore: cast_nullable_to_non_nullable
as double?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double?,taxRate: freezed == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double?,taxAmount: freezed == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,stationId: freezed == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as int?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderProduct].
extension OrderProductPatterns on OrderProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderProduct value)  $default,){
final _that = this;
switch (_that) {
case _OrderProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderProduct value)?  $default,){
final _that = this;
switch (_that) {
case _OrderProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? orderId,  int? productId,  String productName,  int quantity,  double price,  double subTotal,  double? discountRate,  double? discountAmount,  double? taxRate,  double? taxAmount,  double total,  int? stationId,  String? stationName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderProduct() when $default != null:
return $default(_that.id,_that.orderId,_that.productId,_that.productName,_that.quantity,_that.price,_that.subTotal,_that.discountRate,_that.discountAmount,_that.taxRate,_that.taxAmount,_that.total,_that.stationId,_that.stationName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? orderId,  int? productId,  String productName,  int quantity,  double price,  double subTotal,  double? discountRate,  double? discountAmount,  double? taxRate,  double? taxAmount,  double total,  int? stationId,  String? stationName)  $default,) {final _that = this;
switch (_that) {
case _OrderProduct():
return $default(_that.id,_that.orderId,_that.productId,_that.productName,_that.quantity,_that.price,_that.subTotal,_that.discountRate,_that.discountAmount,_that.taxRate,_that.taxAmount,_that.total,_that.stationId,_that.stationName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? orderId,  int? productId,  String productName,  int quantity,  double price,  double subTotal,  double? discountRate,  double? discountAmount,  double? taxRate,  double? taxAmount,  double total,  int? stationId,  String? stationName)?  $default,) {final _that = this;
switch (_that) {
case _OrderProduct() when $default != null:
return $default(_that.id,_that.orderId,_that.productId,_that.productName,_that.quantity,_that.price,_that.subTotal,_that.discountRate,_that.discountAmount,_that.taxRate,_that.taxAmount,_that.total,_that.stationId,_that.stationName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderProduct implements OrderProduct {
  const _OrderProduct({this.id, required this.orderId, required this.productId, required this.productName, required this.quantity, required this.price, required this.subTotal, this.discountRate, this.discountAmount, this.taxRate, this.taxAmount, required this.total, this.stationId, this.stationName});
  factory _OrderProduct.fromJson(Map<String, dynamic> json) => _$OrderProductFromJson(json);

@override final  int? id;
@override final  int? orderId;
@override final  int? productId;
@override final  String productName;
@override final  int quantity;
@override final  double price;
@override final  double subTotal;
@override final  double? discountRate;
@override final  double? discountAmount;
@override final  double? taxRate;
@override final  double? taxAmount;
@override final  double total;
@override final  int? stationId;
@override final  String? stationName;

/// Create a copy of OrderProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderProductCopyWith<_OrderProduct> get copyWith => __$OrderProductCopyWithImpl<_OrderProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.discountRate, discountRate) || other.discountRate == discountRate)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.total, total) || other.total == total)&&(identical(other.stationId, stationId) || other.stationId == stationId)&&(identical(other.stationName, stationName) || other.stationName == stationName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,productId,productName,quantity,price,subTotal,discountRate,discountAmount,taxRate,taxAmount,total,stationId,stationName);

@override
String toString() {
  return 'OrderProduct(id: $id, orderId: $orderId, productId: $productId, productName: $productName, quantity: $quantity, price: $price, subTotal: $subTotal, discountRate: $discountRate, discountAmount: $discountAmount, taxRate: $taxRate, taxAmount: $taxAmount, total: $total, stationId: $stationId, stationName: $stationName)';
}


}

/// @nodoc
abstract mixin class _$OrderProductCopyWith<$Res> implements $OrderProductCopyWith<$Res> {
  factory _$OrderProductCopyWith(_OrderProduct value, $Res Function(_OrderProduct) _then) = __$OrderProductCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? orderId, int? productId, String productName, int quantity, double price, double subTotal, double? discountRate, double? discountAmount, double? taxRate, double? taxAmount, double total, int? stationId, String? stationName
});




}
/// @nodoc
class __$OrderProductCopyWithImpl<$Res>
    implements _$OrderProductCopyWith<$Res> {
  __$OrderProductCopyWithImpl(this._self, this._then);

  final _OrderProduct _self;
  final $Res Function(_OrderProduct) _then;

/// Create a copy of OrderProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? orderId = freezed,Object? productId = freezed,Object? productName = null,Object? quantity = null,Object? price = null,Object? subTotal = null,Object? discountRate = freezed,Object? discountAmount = freezed,Object? taxRate = freezed,Object? taxAmount = freezed,Object? total = null,Object? stationId = freezed,Object? stationName = freezed,}) {
  return _then(_OrderProduct(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,discountRate: freezed == discountRate ? _self.discountRate : discountRate // ignore: cast_nullable_to_non_nullable
as double?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double?,taxRate: freezed == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double?,taxAmount: freezed == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,stationId: freezed == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as int?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

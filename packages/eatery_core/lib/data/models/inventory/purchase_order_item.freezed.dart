// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseOrderItem {

 int? get id; int get purchaseOrderId; int get productId; double get quantity; double get unitPrice; double get totalPrice; double get receivedQty;
/// Create a copy of PurchaseOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderItemCopyWith<PurchaseOrderItem> get copyWith => _$PurchaseOrderItemCopyWithImpl<PurchaseOrderItem>(this as PurchaseOrderItem, _$identity);

  /// Serializes this PurchaseOrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.purchaseOrderId, purchaseOrderId) || other.purchaseOrderId == purchaseOrderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.receivedQty, receivedQty) || other.receivedQty == receivedQty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purchaseOrderId,productId,quantity,unitPrice,totalPrice,receivedQty);

@override
String toString() {
  return 'PurchaseOrderItem(id: $id, purchaseOrderId: $purchaseOrderId, productId: $productId, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, receivedQty: $receivedQty)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderItemCopyWith<$Res>  {
  factory $PurchaseOrderItemCopyWith(PurchaseOrderItem value, $Res Function(PurchaseOrderItem) _then) = _$PurchaseOrderItemCopyWithImpl;
@useResult
$Res call({
 int? id, int purchaseOrderId, int productId, double quantity, double unitPrice, double totalPrice, double receivedQty
});




}
/// @nodoc
class _$PurchaseOrderItemCopyWithImpl<$Res>
    implements $PurchaseOrderItemCopyWith<$Res> {
  _$PurchaseOrderItemCopyWithImpl(this._self, this._then);

  final PurchaseOrderItem _self;
  final $Res Function(PurchaseOrderItem) _then;

/// Create a copy of PurchaseOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? purchaseOrderId = null,Object? productId = null,Object? quantity = null,Object? unitPrice = null,Object? totalPrice = null,Object? receivedQty = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,purchaseOrderId: null == purchaseOrderId ? _self.purchaseOrderId : purchaseOrderId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,receivedQty: null == receivedQty ? _self.receivedQty : receivedQty // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseOrderItem].
extension PurchaseOrderItemPatterns on PurchaseOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int purchaseOrderId,  int productId,  double quantity,  double unitPrice,  double totalPrice,  double receivedQty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOrderItem() when $default != null:
return $default(_that.id,_that.purchaseOrderId,_that.productId,_that.quantity,_that.unitPrice,_that.totalPrice,_that.receivedQty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int purchaseOrderId,  int productId,  double quantity,  double unitPrice,  double totalPrice,  double receivedQty)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderItem():
return $default(_that.id,_that.purchaseOrderId,_that.productId,_that.quantity,_that.unitPrice,_that.totalPrice,_that.receivedQty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int purchaseOrderId,  int productId,  double quantity,  double unitPrice,  double totalPrice,  double receivedQty)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderItem() when $default != null:
return $default(_that.id,_that.purchaseOrderId,_that.productId,_that.quantity,_that.unitPrice,_that.totalPrice,_that.receivedQty);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseOrderItem implements PurchaseOrderItem {
  const _PurchaseOrderItem({this.id, required this.purchaseOrderId, required this.productId, required this.quantity, required this.unitPrice, required this.totalPrice, this.receivedQty = 0.0});
  factory _PurchaseOrderItem.fromJson(Map<String, dynamic> json) => _$PurchaseOrderItemFromJson(json);

@override final  int? id;
@override final  int purchaseOrderId;
@override final  int productId;
@override final  double quantity;
@override final  double unitPrice;
@override final  double totalPrice;
@override@JsonKey() final  double receivedQty;

/// Create a copy of PurchaseOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOrderItemCopyWith<_PurchaseOrderItem> get copyWith => __$PurchaseOrderItemCopyWithImpl<_PurchaseOrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseOrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.purchaseOrderId, purchaseOrderId) || other.purchaseOrderId == purchaseOrderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.receivedQty, receivedQty) || other.receivedQty == receivedQty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purchaseOrderId,productId,quantity,unitPrice,totalPrice,receivedQty);

@override
String toString() {
  return 'PurchaseOrderItem(id: $id, purchaseOrderId: $purchaseOrderId, productId: $productId, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, receivedQty: $receivedQty)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOrderItemCopyWith<$Res> implements $PurchaseOrderItemCopyWith<$Res> {
  factory _$PurchaseOrderItemCopyWith(_PurchaseOrderItem value, $Res Function(_PurchaseOrderItem) _then) = __$PurchaseOrderItemCopyWithImpl;
@override @useResult
$Res call({
 int? id, int purchaseOrderId, int productId, double quantity, double unitPrice, double totalPrice, double receivedQty
});




}
/// @nodoc
class __$PurchaseOrderItemCopyWithImpl<$Res>
    implements _$PurchaseOrderItemCopyWith<$Res> {
  __$PurchaseOrderItemCopyWithImpl(this._self, this._then);

  final _PurchaseOrderItem _self;
  final $Res Function(_PurchaseOrderItem) _then;

/// Create a copy of PurchaseOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? purchaseOrderId = null,Object? productId = null,Object? quantity = null,Object? unitPrice = null,Object? totalPrice = null,Object? receivedQty = null,}) {
  return _then(_PurchaseOrderItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,purchaseOrderId: null == purchaseOrderId ? _self.purchaseOrderId : purchaseOrderId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,receivedQty: null == receivedQty ? _self.receivedQty : receivedQty // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_product_modifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderProductModifier {

 int? get id; int get orderProductId; int get modifierGroupId; int get modifierId; String get modifierName; double get priceAdjust; int get quantity;
/// Create a copy of OrderProductModifier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderProductModifierCopyWith<OrderProductModifier> get copyWith => _$OrderProductModifierCopyWithImpl<OrderProductModifier>(this as OrderProductModifier, _$identity);

  /// Serializes this OrderProductModifier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderProductModifier&&(identical(other.id, id) || other.id == id)&&(identical(other.orderProductId, orderProductId) || other.orderProductId == orderProductId)&&(identical(other.modifierGroupId, modifierGroupId) || other.modifierGroupId == modifierGroupId)&&(identical(other.modifierId, modifierId) || other.modifierId == modifierId)&&(identical(other.modifierName, modifierName) || other.modifierName == modifierName)&&(identical(other.priceAdjust, priceAdjust) || other.priceAdjust == priceAdjust)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderProductId,modifierGroupId,modifierId,modifierName,priceAdjust,quantity);

@override
String toString() {
  return 'OrderProductModifier(id: $id, orderProductId: $orderProductId, modifierGroupId: $modifierGroupId, modifierId: $modifierId, modifierName: $modifierName, priceAdjust: $priceAdjust, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $OrderProductModifierCopyWith<$Res>  {
  factory $OrderProductModifierCopyWith(OrderProductModifier value, $Res Function(OrderProductModifier) _then) = _$OrderProductModifierCopyWithImpl;
@useResult
$Res call({
 int? id, int orderProductId, int modifierGroupId, int modifierId, String modifierName, double priceAdjust, int quantity
});




}
/// @nodoc
class _$OrderProductModifierCopyWithImpl<$Res>
    implements $OrderProductModifierCopyWith<$Res> {
  _$OrderProductModifierCopyWithImpl(this._self, this._then);

  final OrderProductModifier _self;
  final $Res Function(OrderProductModifier) _then;

/// Create a copy of OrderProductModifier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? orderProductId = null,Object? modifierGroupId = null,Object? modifierId = null,Object? modifierName = null,Object? priceAdjust = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderProductId: null == orderProductId ? _self.orderProductId : orderProductId // ignore: cast_nullable_to_non_nullable
as int,modifierGroupId: null == modifierGroupId ? _self.modifierGroupId : modifierGroupId // ignore: cast_nullable_to_non_nullable
as int,modifierId: null == modifierId ? _self.modifierId : modifierId // ignore: cast_nullable_to_non_nullable
as int,modifierName: null == modifierName ? _self.modifierName : modifierName // ignore: cast_nullable_to_non_nullable
as String,priceAdjust: null == priceAdjust ? _self.priceAdjust : priceAdjust // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderProductModifier].
extension OrderProductModifierPatterns on OrderProductModifier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderProductModifier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderProductModifier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderProductModifier value)  $default,){
final _that = this;
switch (_that) {
case _OrderProductModifier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderProductModifier value)?  $default,){
final _that = this;
switch (_that) {
case _OrderProductModifier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int orderProductId,  int modifierGroupId,  int modifierId,  String modifierName,  double priceAdjust,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderProductModifier() when $default != null:
return $default(_that.id,_that.orderProductId,_that.modifierGroupId,_that.modifierId,_that.modifierName,_that.priceAdjust,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int orderProductId,  int modifierGroupId,  int modifierId,  String modifierName,  double priceAdjust,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _OrderProductModifier():
return $default(_that.id,_that.orderProductId,_that.modifierGroupId,_that.modifierId,_that.modifierName,_that.priceAdjust,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int orderProductId,  int modifierGroupId,  int modifierId,  String modifierName,  double priceAdjust,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _OrderProductModifier() when $default != null:
return $default(_that.id,_that.orderProductId,_that.modifierGroupId,_that.modifierId,_that.modifierName,_that.priceAdjust,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderProductModifier implements OrderProductModifier {
  const _OrderProductModifier({this.id, required this.orderProductId, required this.modifierGroupId, required this.modifierId, required this.modifierName, this.priceAdjust = 0.0, this.quantity = 1});
  factory _OrderProductModifier.fromJson(Map<String, dynamic> json) => _$OrderProductModifierFromJson(json);

@override final  int? id;
@override final  int orderProductId;
@override final  int modifierGroupId;
@override final  int modifierId;
@override final  String modifierName;
@override@JsonKey() final  double priceAdjust;
@override@JsonKey() final  int quantity;

/// Create a copy of OrderProductModifier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderProductModifierCopyWith<_OrderProductModifier> get copyWith => __$OrderProductModifierCopyWithImpl<_OrderProductModifier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderProductModifierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderProductModifier&&(identical(other.id, id) || other.id == id)&&(identical(other.orderProductId, orderProductId) || other.orderProductId == orderProductId)&&(identical(other.modifierGroupId, modifierGroupId) || other.modifierGroupId == modifierGroupId)&&(identical(other.modifierId, modifierId) || other.modifierId == modifierId)&&(identical(other.modifierName, modifierName) || other.modifierName == modifierName)&&(identical(other.priceAdjust, priceAdjust) || other.priceAdjust == priceAdjust)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderProductId,modifierGroupId,modifierId,modifierName,priceAdjust,quantity);

@override
String toString() {
  return 'OrderProductModifier(id: $id, orderProductId: $orderProductId, modifierGroupId: $modifierGroupId, modifierId: $modifierId, modifierName: $modifierName, priceAdjust: $priceAdjust, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$OrderProductModifierCopyWith<$Res> implements $OrderProductModifierCopyWith<$Res> {
  factory _$OrderProductModifierCopyWith(_OrderProductModifier value, $Res Function(_OrderProductModifier) _then) = __$OrderProductModifierCopyWithImpl;
@override @useResult
$Res call({
 int? id, int orderProductId, int modifierGroupId, int modifierId, String modifierName, double priceAdjust, int quantity
});




}
/// @nodoc
class __$OrderProductModifierCopyWithImpl<$Res>
    implements _$OrderProductModifierCopyWith<$Res> {
  __$OrderProductModifierCopyWithImpl(this._self, this._then);

  final _OrderProductModifier _self;
  final $Res Function(_OrderProductModifier) _then;

/// Create a copy of OrderProductModifier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? orderProductId = null,Object? modifierGroupId = null,Object? modifierId = null,Object? modifierName = null,Object? priceAdjust = null,Object? quantity = null,}) {
  return _then(_OrderProductModifier(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderProductId: null == orderProductId ? _self.orderProductId : orderProductId // ignore: cast_nullable_to_non_nullable
as int,modifierGroupId: null == modifierGroupId ? _self.modifierGroupId : modifierGroupId // ignore: cast_nullable_to_non_nullable
as int,modifierId: null == modifierId ? _self.modifierId : modifierId // ignore: cast_nullable_to_non_nullable
as int,modifierName: null == modifierName ? _self.modifierName : modifierName // ignore: cast_nullable_to_non_nullable
as String,priceAdjust: null == priceAdjust ? _self.priceAdjust : priceAdjust // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

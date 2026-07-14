// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_discount.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderDiscount {

 int? get id; int get orderId; int? get discountId; String get name; int get type; double get value; double get amount; int? get appliedBy;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get createdAt;
/// Create a copy of OrderDiscount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDiscountCopyWith<OrderDiscount> get copyWith => _$OrderDiscountCopyWithImpl<OrderDiscount>(this as OrderDiscount, _$identity);

  /// Serializes this OrderDiscount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDiscount&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.discountId, discountId) || other.discountId == discountId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.appliedBy, appliedBy) || other.appliedBy == appliedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,discountId,name,type,value,amount,appliedBy,createdAt);

@override
String toString() {
  return 'OrderDiscount(id: $id, orderId: $orderId, discountId: $discountId, name: $name, type: $type, value: $value, amount: $amount, appliedBy: $appliedBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $OrderDiscountCopyWith<$Res>  {
  factory $OrderDiscountCopyWith(OrderDiscount value, $Res Function(OrderDiscount) _then) = _$OrderDiscountCopyWithImpl;
@useResult
$Res call({
 int? id, int orderId, int? discountId, String name, int type, double value, double amount, int? appliedBy,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt
});




}
/// @nodoc
class _$OrderDiscountCopyWithImpl<$Res>
    implements $OrderDiscountCopyWith<$Res> {
  _$OrderDiscountCopyWithImpl(this._self, this._then);

  final OrderDiscount _self;
  final $Res Function(OrderDiscount) _then;

/// Create a copy of OrderDiscount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? orderId = null,Object? discountId = freezed,Object? name = null,Object? type = null,Object? value = null,Object? amount = null,Object? appliedBy = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,discountId: freezed == discountId ? _self.discountId : discountId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,appliedBy: freezed == appliedBy ? _self.appliedBy : appliedBy // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderDiscount].
extension OrderDiscountPatterns on OrderDiscount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderDiscount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderDiscount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderDiscount value)  $default,){
final _that = this;
switch (_that) {
case _OrderDiscount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderDiscount value)?  $default,){
final _that = this;
switch (_that) {
case _OrderDiscount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int orderId,  int? discountId,  String name,  int type,  double value,  double amount,  int? appliedBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderDiscount() when $default != null:
return $default(_that.id,_that.orderId,_that.discountId,_that.name,_that.type,_that.value,_that.amount,_that.appliedBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int orderId,  int? discountId,  String name,  int type,  double value,  double amount,  int? appliedBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _OrderDiscount():
return $default(_that.id,_that.orderId,_that.discountId,_that.name,_that.type,_that.value,_that.amount,_that.appliedBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int orderId,  int? discountId,  String name,  int type,  double value,  double amount,  int? appliedBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderDiscount() when $default != null:
return $default(_that.id,_that.orderId,_that.discountId,_that.name,_that.type,_that.value,_that.amount,_that.appliedBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderDiscount implements OrderDiscount {
  const _OrderDiscount({this.id, required this.orderId, this.discountId, required this.name, required this.type, required this.value, required this.amount, this.appliedBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.createdAt});
  factory _OrderDiscount.fromJson(Map<String, dynamic> json) => _$OrderDiscountFromJson(json);

@override final  int? id;
@override final  int orderId;
@override final  int? discountId;
@override final  String name;
@override final  int type;
@override final  double value;
@override final  double amount;
@override final  int? appliedBy;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime createdAt;

/// Create a copy of OrderDiscount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderDiscountCopyWith<_OrderDiscount> get copyWith => __$OrderDiscountCopyWithImpl<_OrderDiscount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderDiscountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderDiscount&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.discountId, discountId) || other.discountId == discountId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.appliedBy, appliedBy) || other.appliedBy == appliedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,discountId,name,type,value,amount,appliedBy,createdAt);

@override
String toString() {
  return 'OrderDiscount(id: $id, orderId: $orderId, discountId: $discountId, name: $name, type: $type, value: $value, amount: $amount, appliedBy: $appliedBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$OrderDiscountCopyWith<$Res> implements $OrderDiscountCopyWith<$Res> {
  factory _$OrderDiscountCopyWith(_OrderDiscount value, $Res Function(_OrderDiscount) _then) = __$OrderDiscountCopyWithImpl;
@override @useResult
$Res call({
 int? id, int orderId, int? discountId, String name, int type, double value, double amount, int? appliedBy,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt
});




}
/// @nodoc
class __$OrderDiscountCopyWithImpl<$Res>
    implements _$OrderDiscountCopyWith<$Res> {
  __$OrderDiscountCopyWithImpl(this._self, this._then);

  final _OrderDiscount _self;
  final $Res Function(_OrderDiscount) _then;

/// Create a copy of OrderDiscount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? orderId = null,Object? discountId = freezed,Object? name = null,Object? type = null,Object? value = null,Object? amount = null,Object? appliedBy = freezed,Object? createdAt = null,}) {
  return _then(_OrderDiscount(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,discountId: freezed == discountId ? _self.discountId : discountId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,appliedBy: freezed == appliedBy ? _self.appliedBy : appliedBy // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 int? get id; String? get customerPhone; int? get customerId; int? get employeeId; int? get companyId;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get createdAt;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get updatedAt; int get totalQuantity; double get subTotal; double get discountTotal; double get taxTotal; double get finalTotal; double get roundOff; double get grandTotal; double? get paidTotal; OrderType get type;@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) OrderStatus get status; String? get voidReason; String? get voidedBy;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get voidedAt;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.discountTotal, discountTotal) || other.discountTotal == discountTotal)&&(identical(other.taxTotal, taxTotal) || other.taxTotal == taxTotal)&&(identical(other.finalTotal, finalTotal) || other.finalTotal == finalTotal)&&(identical(other.roundOff, roundOff) || other.roundOff == roundOff)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.paidTotal, paidTotal) || other.paidTotal == paidTotal)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.voidReason, voidReason) || other.voidReason == voidReason)&&(identical(other.voidedBy, voidedBy) || other.voidedBy == voidedBy)&&(identical(other.voidedAt, voidedAt) || other.voidedAt == voidedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerPhone,customerId,employeeId,companyId,createdAt,updatedAt,totalQuantity,subTotal,discountTotal,taxTotal,finalTotal,roundOff,grandTotal,paidTotal,type,status,voidReason,voidedBy,voidedAt]);

@override
String toString() {
  return 'Order(id: $id, customerPhone: $customerPhone, customerId: $customerId, employeeId: $employeeId, companyId: $companyId, createdAt: $createdAt, updatedAt: $updatedAt, totalQuantity: $totalQuantity, subTotal: $subTotal, discountTotal: $discountTotal, taxTotal: $taxTotal, finalTotal: $finalTotal, roundOff: $roundOff, grandTotal: $grandTotal, paidTotal: $paidTotal, type: $type, status: $status, voidReason: $voidReason, voidedBy: $voidedBy, voidedAt: $voidedAt)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 int? id, String? customerPhone, int? customerId, int? employeeId, int? companyId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt, int totalQuantity, double subTotal, double discountTotal, double taxTotal, double finalTotal, double roundOff, double grandTotal, double? paidTotal, OrderType type,@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) OrderStatus status, String? voidReason, String? voidedBy,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? voidedAt
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? customerPhone = freezed,Object? customerId = freezed,Object? employeeId = freezed,Object? companyId = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? totalQuantity = null,Object? subTotal = null,Object? discountTotal = null,Object? taxTotal = null,Object? finalTotal = null,Object? roundOff = null,Object? grandTotal = null,Object? paidTotal = freezed,Object? type = null,Object? status = null,Object? voidReason = freezed,Object? voidedBy = freezed,Object? voidedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int?,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as int,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,discountTotal: null == discountTotal ? _self.discountTotal : discountTotal // ignore: cast_nullable_to_non_nullable
as double,taxTotal: null == taxTotal ? _self.taxTotal : taxTotal // ignore: cast_nullable_to_non_nullable
as double,finalTotal: null == finalTotal ? _self.finalTotal : finalTotal // ignore: cast_nullable_to_non_nullable
as double,roundOff: null == roundOff ? _self.roundOff : roundOff // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,paidTotal: freezed == paidTotal ? _self.paidTotal : paidTotal // ignore: cast_nullable_to_non_nullable
as double?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OrderType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,voidReason: freezed == voidReason ? _self.voidReason : voidReason // ignore: cast_nullable_to_non_nullable
as String?,voidedBy: freezed == voidedBy ? _self.voidedBy : voidedBy // ignore: cast_nullable_to_non_nullable
as String?,voidedAt: freezed == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? customerPhone,  int? customerId,  int? employeeId,  int? companyId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt,  int totalQuantity,  double subTotal,  double discountTotal,  double taxTotal,  double finalTotal,  double roundOff,  double grandTotal,  double? paidTotal,  OrderType type, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  OrderStatus status,  String? voidReason,  String? voidedBy, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? voidedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.customerPhone,_that.customerId,_that.employeeId,_that.companyId,_that.createdAt,_that.updatedAt,_that.totalQuantity,_that.subTotal,_that.discountTotal,_that.taxTotal,_that.finalTotal,_that.roundOff,_that.grandTotal,_that.paidTotal,_that.type,_that.status,_that.voidReason,_that.voidedBy,_that.voidedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? customerPhone,  int? customerId,  int? employeeId,  int? companyId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt,  int totalQuantity,  double subTotal,  double discountTotal,  double taxTotal,  double finalTotal,  double roundOff,  double grandTotal,  double? paidTotal,  OrderType type, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  OrderStatus status,  String? voidReason,  String? voidedBy, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? voidedAt)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.customerPhone,_that.customerId,_that.employeeId,_that.companyId,_that.createdAt,_that.updatedAt,_that.totalQuantity,_that.subTotal,_that.discountTotal,_that.taxTotal,_that.finalTotal,_that.roundOff,_that.grandTotal,_that.paidTotal,_that.type,_that.status,_that.voidReason,_that.voidedBy,_that.voidedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? customerPhone,  int? customerId,  int? employeeId,  int? companyId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt,  int totalQuantity,  double subTotal,  double discountTotal,  double taxTotal,  double finalTotal,  double roundOff,  double grandTotal,  double? paidTotal,  OrderType type, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  OrderStatus status,  String? voidReason,  String? voidedBy, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? voidedAt)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.customerPhone,_that.customerId,_that.employeeId,_that.companyId,_that.createdAt,_that.updatedAt,_that.totalQuantity,_that.subTotal,_that.discountTotal,_that.taxTotal,_that.finalTotal,_that.roundOff,_that.grandTotal,_that.paidTotal,_that.type,_that.status,_that.voidReason,_that.voidedBy,_that.voidedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order implements Order {
  const _Order({this.id, this.customerPhone, this.customerId, this.employeeId, this.companyId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.updatedAt, required this.totalQuantity, required this.subTotal, required this.discountTotal, required this.taxTotal, required this.finalTotal, required this.roundOff, required this.grandTotal, this.paidTotal, required this.type, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) this.status = OrderStatus.pending, this.voidReason, this.voidedBy, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.voidedAt});
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  int? id;
@override final  String? customerPhone;
@override final  int? customerId;
@override final  int? employeeId;
@override final  int? companyId;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime createdAt;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? updatedAt;
@override final  int totalQuantity;
@override final  double subTotal;
@override final  double discountTotal;
@override final  double taxTotal;
@override final  double finalTotal;
@override final  double roundOff;
@override final  double grandTotal;
@override final  double? paidTotal;
@override final  OrderType type;
@override@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) final  OrderStatus status;
@override final  String? voidReason;
@override final  String? voidedBy;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? voidedAt;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.discountTotal, discountTotal) || other.discountTotal == discountTotal)&&(identical(other.taxTotal, taxTotal) || other.taxTotal == taxTotal)&&(identical(other.finalTotal, finalTotal) || other.finalTotal == finalTotal)&&(identical(other.roundOff, roundOff) || other.roundOff == roundOff)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.paidTotal, paidTotal) || other.paidTotal == paidTotal)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.voidReason, voidReason) || other.voidReason == voidReason)&&(identical(other.voidedBy, voidedBy) || other.voidedBy == voidedBy)&&(identical(other.voidedAt, voidedAt) || other.voidedAt == voidedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerPhone,customerId,employeeId,companyId,createdAt,updatedAt,totalQuantity,subTotal,discountTotal,taxTotal,finalTotal,roundOff,grandTotal,paidTotal,type,status,voidReason,voidedBy,voidedAt]);

@override
String toString() {
  return 'Order(id: $id, customerPhone: $customerPhone, customerId: $customerId, employeeId: $employeeId, companyId: $companyId, createdAt: $createdAt, updatedAt: $updatedAt, totalQuantity: $totalQuantity, subTotal: $subTotal, discountTotal: $discountTotal, taxTotal: $taxTotal, finalTotal: $finalTotal, roundOff: $roundOff, grandTotal: $grandTotal, paidTotal: $paidTotal, type: $type, status: $status, voidReason: $voidReason, voidedBy: $voidedBy, voidedAt: $voidedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? customerPhone, int? customerId, int? employeeId, int? companyId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt, int totalQuantity, double subTotal, double discountTotal, double taxTotal, double finalTotal, double roundOff, double grandTotal, double? paidTotal, OrderType type,@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) OrderStatus status, String? voidReason, String? voidedBy,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? voidedAt
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? customerPhone = freezed,Object? customerId = freezed,Object? employeeId = freezed,Object? companyId = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? totalQuantity = null,Object? subTotal = null,Object? discountTotal = null,Object? taxTotal = null,Object? finalTotal = null,Object? roundOff = null,Object? grandTotal = null,Object? paidTotal = freezed,Object? type = null,Object? status = null,Object? voidReason = freezed,Object? voidedBy = freezed,Object? voidedAt = freezed,}) {
  return _then(_Order(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int?,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as int,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,discountTotal: null == discountTotal ? _self.discountTotal : discountTotal // ignore: cast_nullable_to_non_nullable
as double,taxTotal: null == taxTotal ? _self.taxTotal : taxTotal // ignore: cast_nullable_to_non_nullable
as double,finalTotal: null == finalTotal ? _self.finalTotal : finalTotal // ignore: cast_nullable_to_non_nullable
as double,roundOff: null == roundOff ? _self.roundOff : roundOff // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,paidTotal: freezed == paidTotal ? _self.paidTotal : paidTotal // ignore: cast_nullable_to_non_nullable
as double?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OrderType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,voidReason: freezed == voidReason ? _self.voidReason : voidReason // ignore: cast_nullable_to_non_nullable
as String?,voidedBy: freezed == voidedBy ? _self.voidedBy : voidedBy // ignore: cast_nullable_to_non_nullable
as String?,voidedAt: freezed == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

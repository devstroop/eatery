// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseOrder {

 int? get id; int? get supplierId;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get orderDate;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get expectedDate;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get deliveredDate; int get status; double get totalAmount; String? get notes; int? get createdBy;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get createdAt;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get updatedAt;
/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderCopyWith<PurchaseOrder> get copyWith => _$PurchaseOrderCopyWithImpl<PurchaseOrder>(this as PurchaseOrder, _$identity);

  /// Serializes this PurchaseOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.expectedDate, expectedDate) || other.expectedDate == expectedDate)&&(identical(other.deliveredDate, deliveredDate) || other.deliveredDate == deliveredDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierId,orderDate,expectedDate,deliveredDate,status,totalAmount,notes,createdBy,createdAt,updatedAt);

@override
String toString() {
  return 'PurchaseOrder(id: $id, supplierId: $supplierId, orderDate: $orderDate, expectedDate: $expectedDate, deliveredDate: $deliveredDate, status: $status, totalAmount: $totalAmount, notes: $notes, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderCopyWith<$Res>  {
  factory $PurchaseOrderCopyWith(PurchaseOrder value, $Res Function(PurchaseOrder) _then) = _$PurchaseOrderCopyWithImpl;
@useResult
$Res call({
 int? id, int? supplierId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime orderDate,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? expectedDate,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? deliveredDate, int status, double totalAmount, String? notes, int? createdBy,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt
});




}
/// @nodoc
class _$PurchaseOrderCopyWithImpl<$Res>
    implements $PurchaseOrderCopyWith<$Res> {
  _$PurchaseOrderCopyWithImpl(this._self, this._then);

  final PurchaseOrder _self;
  final $Res Function(PurchaseOrder) _then;

/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? supplierId = freezed,Object? orderDate = null,Object? expectedDate = freezed,Object? deliveredDate = freezed,Object? status = null,Object? totalAmount = null,Object? notes = freezed,Object? createdBy = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as int?,orderDate: null == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime,expectedDate: freezed == expectedDate ? _self.expectedDate : expectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredDate: freezed == deliveredDate ? _self.deliveredDate : deliveredDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseOrder].
extension PurchaseOrderPatterns on PurchaseOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOrder value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOrder value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? supplierId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime orderDate, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? expectedDate, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? deliveredDate,  int status,  double totalAmount,  String? notes,  int? createdBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
return $default(_that.id,_that.supplierId,_that.orderDate,_that.expectedDate,_that.deliveredDate,_that.status,_that.totalAmount,_that.notes,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? supplierId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime orderDate, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? expectedDate, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? deliveredDate,  int status,  double totalAmount,  String? notes,  int? createdBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrder():
return $default(_that.id,_that.supplierId,_that.orderDate,_that.expectedDate,_that.deliveredDate,_that.status,_that.totalAmount,_that.notes,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? supplierId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime orderDate, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? expectedDate, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? deliveredDate,  int status,  double totalAmount,  String? notes,  int? createdBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
return $default(_that.id,_that.supplierId,_that.orderDate,_that.expectedDate,_that.deliveredDate,_that.status,_that.totalAmount,_that.notes,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseOrder implements PurchaseOrder {
  const _PurchaseOrder({this.id, this.supplierId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.orderDate, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.expectedDate, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.deliveredDate, this.status = 0, this.totalAmount = 0.0, this.notes, this.createdBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.updatedAt});
  factory _PurchaseOrder.fromJson(Map<String, dynamic> json) => _$PurchaseOrderFromJson(json);

@override final  int? id;
@override final  int? supplierId;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime orderDate;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? expectedDate;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? deliveredDate;
@override@JsonKey() final  int status;
@override@JsonKey() final  double totalAmount;
@override final  String? notes;
@override final  int? createdBy;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime createdAt;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? updatedAt;

/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOrderCopyWith<_PurchaseOrder> get copyWith => __$PurchaseOrderCopyWithImpl<_PurchaseOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.expectedDate, expectedDate) || other.expectedDate == expectedDate)&&(identical(other.deliveredDate, deliveredDate) || other.deliveredDate == deliveredDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierId,orderDate,expectedDate,deliveredDate,status,totalAmount,notes,createdBy,createdAt,updatedAt);

@override
String toString() {
  return 'PurchaseOrder(id: $id, supplierId: $supplierId, orderDate: $orderDate, expectedDate: $expectedDate, deliveredDate: $deliveredDate, status: $status, totalAmount: $totalAmount, notes: $notes, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOrderCopyWith<$Res> implements $PurchaseOrderCopyWith<$Res> {
  factory _$PurchaseOrderCopyWith(_PurchaseOrder value, $Res Function(_PurchaseOrder) _then) = __$PurchaseOrderCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? supplierId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime orderDate,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? expectedDate,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? deliveredDate, int status, double totalAmount, String? notes, int? createdBy,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt
});




}
/// @nodoc
class __$PurchaseOrderCopyWithImpl<$Res>
    implements _$PurchaseOrderCopyWith<$Res> {
  __$PurchaseOrderCopyWithImpl(this._self, this._then);

  final _PurchaseOrder _self;
  final $Res Function(_PurchaseOrder) _then;

/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? supplierId = freezed,Object? orderDate = null,Object? expectedDate = freezed,Object? deliveredDate = freezed,Object? status = null,Object? totalAmount = null,Object? notes = freezed,Object? createdBy = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_PurchaseOrder(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as int?,orderDate: null == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime,expectedDate: freezed == expectedDate ? _self.expectedDate : expectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredDate: freezed == deliveredDate ? _self.deliveredDate : deliveredDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

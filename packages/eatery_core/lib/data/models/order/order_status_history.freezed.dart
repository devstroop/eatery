// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_status_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderStatusHistory {

 int? get id; int get orderId; int get fromStatus; int get toStatus; int? get changedByStaffId;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get changedAt; String? get reason;
/// Create a copy of OrderStatusHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderStatusHistoryCopyWith<OrderStatusHistory> get copyWith => _$OrderStatusHistoryCopyWithImpl<OrderStatusHistory>(this as OrderStatusHistory, _$identity);

  /// Serializes this OrderStatusHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderStatusHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.changedByStaffId, changedByStaffId) || other.changedByStaffId == changedByStaffId)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,fromStatus,toStatus,changedByStaffId,changedAt,reason);

@override
String toString() {
  return 'OrderStatusHistory(id: $id, orderId: $orderId, fromStatus: $fromStatus, toStatus: $toStatus, changedByStaffId: $changedByStaffId, changedAt: $changedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $OrderStatusHistoryCopyWith<$Res>  {
  factory $OrderStatusHistoryCopyWith(OrderStatusHistory value, $Res Function(OrderStatusHistory) _then) = _$OrderStatusHistoryCopyWithImpl;
@useResult
$Res call({
 int? id, int orderId, int fromStatus, int toStatus, int? changedByStaffId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime changedAt, String? reason
});




}
/// @nodoc
class _$OrderStatusHistoryCopyWithImpl<$Res>
    implements $OrderStatusHistoryCopyWith<$Res> {
  _$OrderStatusHistoryCopyWithImpl(this._self, this._then);

  final OrderStatusHistory _self;
  final $Res Function(OrderStatusHistory) _then;

/// Create a copy of OrderStatusHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? orderId = null,Object? fromStatus = null,Object? toStatus = null,Object? changedByStaffId = freezed,Object? changedAt = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,fromStatus: null == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as int,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as int,changedByStaffId: freezed == changedByStaffId ? _self.changedByStaffId : changedByStaffId // ignore: cast_nullable_to_non_nullable
as int?,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderStatusHistory].
extension OrderStatusHistoryPatterns on OrderStatusHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderStatusHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderStatusHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderStatusHistory value)  $default,){
final _that = this;
switch (_that) {
case _OrderStatusHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderStatusHistory value)?  $default,){
final _that = this;
switch (_that) {
case _OrderStatusHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int orderId,  int fromStatus,  int toStatus,  int? changedByStaffId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime changedAt,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderStatusHistory() when $default != null:
return $default(_that.id,_that.orderId,_that.fromStatus,_that.toStatus,_that.changedByStaffId,_that.changedAt,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int orderId,  int fromStatus,  int toStatus,  int? changedByStaffId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime changedAt,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _OrderStatusHistory():
return $default(_that.id,_that.orderId,_that.fromStatus,_that.toStatus,_that.changedByStaffId,_that.changedAt,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int orderId,  int fromStatus,  int toStatus,  int? changedByStaffId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime changedAt,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _OrderStatusHistory() when $default != null:
return $default(_that.id,_that.orderId,_that.fromStatus,_that.toStatus,_that.changedByStaffId,_that.changedAt,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderStatusHistory implements OrderStatusHistory {
  const _OrderStatusHistory({this.id, required this.orderId, required this.fromStatus, required this.toStatus, this.changedByStaffId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.changedAt, this.reason});
  factory _OrderStatusHistory.fromJson(Map<String, dynamic> json) => _$OrderStatusHistoryFromJson(json);

@override final  int? id;
@override final  int orderId;
@override final  int fromStatus;
@override final  int toStatus;
@override final  int? changedByStaffId;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime changedAt;
@override final  String? reason;

/// Create a copy of OrderStatusHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderStatusHistoryCopyWith<_OrderStatusHistory> get copyWith => __$OrderStatusHistoryCopyWithImpl<_OrderStatusHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderStatusHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderStatusHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.changedByStaffId, changedByStaffId) || other.changedByStaffId == changedByStaffId)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,fromStatus,toStatus,changedByStaffId,changedAt,reason);

@override
String toString() {
  return 'OrderStatusHistory(id: $id, orderId: $orderId, fromStatus: $fromStatus, toStatus: $toStatus, changedByStaffId: $changedByStaffId, changedAt: $changedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$OrderStatusHistoryCopyWith<$Res> implements $OrderStatusHistoryCopyWith<$Res> {
  factory _$OrderStatusHistoryCopyWith(_OrderStatusHistory value, $Res Function(_OrderStatusHistory) _then) = __$OrderStatusHistoryCopyWithImpl;
@override @useResult
$Res call({
 int? id, int orderId, int fromStatus, int toStatus, int? changedByStaffId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime changedAt, String? reason
});




}
/// @nodoc
class __$OrderStatusHistoryCopyWithImpl<$Res>
    implements _$OrderStatusHistoryCopyWith<$Res> {
  __$OrderStatusHistoryCopyWithImpl(this._self, this._then);

  final _OrderStatusHistory _self;
  final $Res Function(_OrderStatusHistory) _then;

/// Create a copy of OrderStatusHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? orderId = null,Object? fromStatus = null,Object? toStatus = null,Object? changedByStaffId = freezed,Object? changedAt = null,Object? reason = freezed,}) {
  return _then(_OrderStatusHistory(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,fromStatus: null == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as int,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as int,changedByStaffId: freezed == changedByStaffId ? _self.changedByStaffId : changedByStaffId // ignore: cast_nullable_to_non_nullable
as int?,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

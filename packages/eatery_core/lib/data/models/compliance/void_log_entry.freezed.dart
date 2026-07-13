// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'void_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VoidLogEntry {

 int? get id; int get orderId;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get voidedAt; String get voidedBy; String get reasonCode; String? get reasonDescription; double get amount; String? get orderReference;
/// Create a copy of VoidLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoidLogEntryCopyWith<VoidLogEntry> get copyWith => _$VoidLogEntryCopyWithImpl<VoidLogEntry>(this as VoidLogEntry, _$identity);

  /// Serializes this VoidLogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoidLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.voidedAt, voidedAt) || other.voidedAt == voidedAt)&&(identical(other.voidedBy, voidedBy) || other.voidedBy == voidedBy)&&(identical(other.reasonCode, reasonCode) || other.reasonCode == reasonCode)&&(identical(other.reasonDescription, reasonDescription) || other.reasonDescription == reasonDescription)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.orderReference, orderReference) || other.orderReference == orderReference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,voidedAt,voidedBy,reasonCode,reasonDescription,amount,orderReference);

@override
String toString() {
  return 'VoidLogEntry(id: $id, orderId: $orderId, voidedAt: $voidedAt, voidedBy: $voidedBy, reasonCode: $reasonCode, reasonDescription: $reasonDescription, amount: $amount, orderReference: $orderReference)';
}


}

/// @nodoc
abstract mixin class $VoidLogEntryCopyWith<$Res>  {
  factory $VoidLogEntryCopyWith(VoidLogEntry value, $Res Function(VoidLogEntry) _then) = _$VoidLogEntryCopyWithImpl;
@useResult
$Res call({
 int? id, int orderId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime voidedAt, String voidedBy, String reasonCode, String? reasonDescription, double amount, String? orderReference
});




}
/// @nodoc
class _$VoidLogEntryCopyWithImpl<$Res>
    implements $VoidLogEntryCopyWith<$Res> {
  _$VoidLogEntryCopyWithImpl(this._self, this._then);

  final VoidLogEntry _self;
  final $Res Function(VoidLogEntry) _then;

/// Create a copy of VoidLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? orderId = null,Object? voidedAt = null,Object? voidedBy = null,Object? reasonCode = null,Object? reasonDescription = freezed,Object? amount = null,Object? orderReference = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,voidedAt: null == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime,voidedBy: null == voidedBy ? _self.voidedBy : voidedBy // ignore: cast_nullable_to_non_nullable
as String,reasonCode: null == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as String,reasonDescription: freezed == reasonDescription ? _self.reasonDescription : reasonDescription // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,orderReference: freezed == orderReference ? _self.orderReference : orderReference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VoidLogEntry].
extension VoidLogEntryPatterns on VoidLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoidLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoidLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoidLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _VoidLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoidLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _VoidLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int orderId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime voidedAt,  String voidedBy,  String reasonCode,  String? reasonDescription,  double amount,  String? orderReference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoidLogEntry() when $default != null:
return $default(_that.id,_that.orderId,_that.voidedAt,_that.voidedBy,_that.reasonCode,_that.reasonDescription,_that.amount,_that.orderReference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int orderId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime voidedAt,  String voidedBy,  String reasonCode,  String? reasonDescription,  double amount,  String? orderReference)  $default,) {final _that = this;
switch (_that) {
case _VoidLogEntry():
return $default(_that.id,_that.orderId,_that.voidedAt,_that.voidedBy,_that.reasonCode,_that.reasonDescription,_that.amount,_that.orderReference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int orderId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime voidedAt,  String voidedBy,  String reasonCode,  String? reasonDescription,  double amount,  String? orderReference)?  $default,) {final _that = this;
switch (_that) {
case _VoidLogEntry() when $default != null:
return $default(_that.id,_that.orderId,_that.voidedAt,_that.voidedBy,_that.reasonCode,_that.reasonDescription,_that.amount,_that.orderReference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VoidLogEntry implements VoidLogEntry {
  const _VoidLogEntry({this.id, required this.orderId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.voidedAt, required this.voidedBy, required this.reasonCode, this.reasonDescription, required this.amount, this.orderReference});
  factory _VoidLogEntry.fromJson(Map<String, dynamic> json) => _$VoidLogEntryFromJson(json);

@override final  int? id;
@override final  int orderId;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime voidedAt;
@override final  String voidedBy;
@override final  String reasonCode;
@override final  String? reasonDescription;
@override final  double amount;
@override final  String? orderReference;

/// Create a copy of VoidLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoidLogEntryCopyWith<_VoidLogEntry> get copyWith => __$VoidLogEntryCopyWithImpl<_VoidLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoidLogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoidLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.voidedAt, voidedAt) || other.voidedAt == voidedAt)&&(identical(other.voidedBy, voidedBy) || other.voidedBy == voidedBy)&&(identical(other.reasonCode, reasonCode) || other.reasonCode == reasonCode)&&(identical(other.reasonDescription, reasonDescription) || other.reasonDescription == reasonDescription)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.orderReference, orderReference) || other.orderReference == orderReference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,voidedAt,voidedBy,reasonCode,reasonDescription,amount,orderReference);

@override
String toString() {
  return 'VoidLogEntry(id: $id, orderId: $orderId, voidedAt: $voidedAt, voidedBy: $voidedBy, reasonCode: $reasonCode, reasonDescription: $reasonDescription, amount: $amount, orderReference: $orderReference)';
}


}

/// @nodoc
abstract mixin class _$VoidLogEntryCopyWith<$Res> implements $VoidLogEntryCopyWith<$Res> {
  factory _$VoidLogEntryCopyWith(_VoidLogEntry value, $Res Function(_VoidLogEntry) _then) = __$VoidLogEntryCopyWithImpl;
@override @useResult
$Res call({
 int? id, int orderId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime voidedAt, String voidedBy, String reasonCode, String? reasonDescription, double amount, String? orderReference
});




}
/// @nodoc
class __$VoidLogEntryCopyWithImpl<$Res>
    implements _$VoidLogEntryCopyWith<$Res> {
  __$VoidLogEntryCopyWithImpl(this._self, this._then);

  final _VoidLogEntry _self;
  final $Res Function(_VoidLogEntry) _then;

/// Create a copy of VoidLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? orderId = null,Object? voidedAt = null,Object? voidedBy = null,Object? reasonCode = null,Object? reasonDescription = freezed,Object? amount = null,Object? orderReference = freezed,}) {
  return _then(_VoidLogEntry(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,voidedAt: null == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime,voidedBy: null == voidedBy ? _self.voidedBy : voidedBy // ignore: cast_nullable_to_non_nullable
as String,reasonCode: null == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as String,reasonDescription: freezed == reasonDescription ? _self.reasonDescription : reasonDescription // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,orderReference: freezed == orderReference ? _self.orderReference : orderReference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

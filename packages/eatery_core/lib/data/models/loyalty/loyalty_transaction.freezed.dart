// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loyalty_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoyaltyTransaction {

 int? get id; int get customerId; double get points; int get type; int? get referenceId; String? get description;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get createdAt;
/// Create a copy of LoyaltyTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoyaltyTransactionCopyWith<LoyaltyTransaction> get copyWith => _$LoyaltyTransactionCopyWithImpl<LoyaltyTransaction>(this as LoyaltyTransaction, _$identity);

  /// Serializes this LoyaltyTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoyaltyTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.points, points) || other.points == points)&&(identical(other.type, type) || other.type == type)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,points,type,referenceId,description,createdAt);

@override
String toString() {
  return 'LoyaltyTransaction(id: $id, customerId: $customerId, points: $points, type: $type, referenceId: $referenceId, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LoyaltyTransactionCopyWith<$Res>  {
  factory $LoyaltyTransactionCopyWith(LoyaltyTransaction value, $Res Function(LoyaltyTransaction) _then) = _$LoyaltyTransactionCopyWithImpl;
@useResult
$Res call({
 int? id, int customerId, double points, int type, int? referenceId, String? description,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt
});




}
/// @nodoc
class _$LoyaltyTransactionCopyWithImpl<$Res>
    implements $LoyaltyTransactionCopyWith<$Res> {
  _$LoyaltyTransactionCopyWithImpl(this._self, this._then);

  final LoyaltyTransaction _self;
  final $Res Function(LoyaltyTransaction) _then;

/// Create a copy of LoyaltyTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? customerId = null,Object? points = null,Object? type = null,Object? referenceId = freezed,Object? description = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LoyaltyTransaction].
extension LoyaltyTransactionPatterns on LoyaltyTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoyaltyTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoyaltyTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoyaltyTransaction value)  $default,){
final _that = this;
switch (_that) {
case _LoyaltyTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoyaltyTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _LoyaltyTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int customerId,  double points,  int type,  int? referenceId,  String? description, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoyaltyTransaction() when $default != null:
return $default(_that.id,_that.customerId,_that.points,_that.type,_that.referenceId,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int customerId,  double points,  int type,  int? referenceId,  String? description, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _LoyaltyTransaction():
return $default(_that.id,_that.customerId,_that.points,_that.type,_that.referenceId,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int customerId,  double points,  int type,  int? referenceId,  String? description, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _LoyaltyTransaction() when $default != null:
return $default(_that.id,_that.customerId,_that.points,_that.type,_that.referenceId,_that.description,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoyaltyTransaction implements LoyaltyTransaction {
  const _LoyaltyTransaction({this.id, required this.customerId, required this.points, required this.type, this.referenceId, this.description, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.createdAt});
  factory _LoyaltyTransaction.fromJson(Map<String, dynamic> json) => _$LoyaltyTransactionFromJson(json);

@override final  int? id;
@override final  int customerId;
@override final  double points;
@override final  int type;
@override final  int? referenceId;
@override final  String? description;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime createdAt;

/// Create a copy of LoyaltyTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoyaltyTransactionCopyWith<_LoyaltyTransaction> get copyWith => __$LoyaltyTransactionCopyWithImpl<_LoyaltyTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoyaltyTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoyaltyTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.points, points) || other.points == points)&&(identical(other.type, type) || other.type == type)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,points,type,referenceId,description,createdAt);

@override
String toString() {
  return 'LoyaltyTransaction(id: $id, customerId: $customerId, points: $points, type: $type, referenceId: $referenceId, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LoyaltyTransactionCopyWith<$Res> implements $LoyaltyTransactionCopyWith<$Res> {
  factory _$LoyaltyTransactionCopyWith(_LoyaltyTransaction value, $Res Function(_LoyaltyTransaction) _then) = __$LoyaltyTransactionCopyWithImpl;
@override @useResult
$Res call({
 int? id, int customerId, double points, int type, int? referenceId, String? description,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt
});




}
/// @nodoc
class __$LoyaltyTransactionCopyWithImpl<$Res>
    implements _$LoyaltyTransactionCopyWith<$Res> {
  __$LoyaltyTransactionCopyWithImpl(this._self, this._then);

  final _LoyaltyTransaction _self;
  final $Res Function(_LoyaltyTransaction) _then;

/// Create a copy of LoyaltyTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? customerId = null,Object? points = null,Object? type = null,Object? referenceId = freezed,Object? description = freezed,Object? createdAt = null,}) {
  return _then(_LoyaltyTransaction(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

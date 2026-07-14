// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_loyalty.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerLoyalty {

 int? get id; int get customerId; double get points; int get totalVisits; double get totalSpent;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get lastVisitAt; int get tier;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get createdAt;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get updatedAt;
/// Create a copy of CustomerLoyalty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerLoyaltyCopyWith<CustomerLoyalty> get copyWith => _$CustomerLoyaltyCopyWithImpl<CustomerLoyalty>(this as CustomerLoyalty, _$identity);

  /// Serializes this CustomerLoyalty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerLoyalty&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.points, points) || other.points == points)&&(identical(other.totalVisits, totalVisits) || other.totalVisits == totalVisits)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.lastVisitAt, lastVisitAt) || other.lastVisitAt == lastVisitAt)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,points,totalVisits,totalSpent,lastVisitAt,tier,createdAt,updatedAt);

@override
String toString() {
  return 'CustomerLoyalty(id: $id, customerId: $customerId, points: $points, totalVisits: $totalVisits, totalSpent: $totalSpent, lastVisitAt: $lastVisitAt, tier: $tier, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CustomerLoyaltyCopyWith<$Res>  {
  factory $CustomerLoyaltyCopyWith(CustomerLoyalty value, $Res Function(CustomerLoyalty) _then) = _$CustomerLoyaltyCopyWithImpl;
@useResult
$Res call({
 int? id, int customerId, double points, int totalVisits, double totalSpent,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? lastVisitAt, int tier,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt
});




}
/// @nodoc
class _$CustomerLoyaltyCopyWithImpl<$Res>
    implements $CustomerLoyaltyCopyWith<$Res> {
  _$CustomerLoyaltyCopyWithImpl(this._self, this._then);

  final CustomerLoyalty _self;
  final $Res Function(CustomerLoyalty) _then;

/// Create a copy of CustomerLoyalty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? customerId = null,Object? points = null,Object? totalVisits = null,Object? totalSpent = null,Object? lastVisitAt = freezed,Object? tier = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as double,totalVisits: null == totalVisits ? _self.totalVisits : totalVisits // ignore: cast_nullable_to_non_nullable
as int,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,lastVisitAt: freezed == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerLoyalty].
extension CustomerLoyaltyPatterns on CustomerLoyalty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerLoyalty value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerLoyalty() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerLoyalty value)  $default,){
final _that = this;
switch (_that) {
case _CustomerLoyalty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerLoyalty value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerLoyalty() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int customerId,  double points,  int totalVisits,  double totalSpent, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? lastVisitAt,  int tier, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerLoyalty() when $default != null:
return $default(_that.id,_that.customerId,_that.points,_that.totalVisits,_that.totalSpent,_that.lastVisitAt,_that.tier,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int customerId,  double points,  int totalVisits,  double totalSpent, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? lastVisitAt,  int tier, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CustomerLoyalty():
return $default(_that.id,_that.customerId,_that.points,_that.totalVisits,_that.totalSpent,_that.lastVisitAt,_that.tier,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int customerId,  double points,  int totalVisits,  double totalSpent, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? lastVisitAt,  int tier, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomerLoyalty() when $default != null:
return $default(_that.id,_that.customerId,_that.points,_that.totalVisits,_that.totalSpent,_that.lastVisitAt,_that.tier,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerLoyalty implements CustomerLoyalty {
  const _CustomerLoyalty({this.id, required this.customerId, this.points = 0.0, this.totalVisits = 0, this.totalSpent = 0.0, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.lastVisitAt, this.tier = 0, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.updatedAt});
  factory _CustomerLoyalty.fromJson(Map<String, dynamic> json) => _$CustomerLoyaltyFromJson(json);

@override final  int? id;
@override final  int customerId;
@override@JsonKey() final  double points;
@override@JsonKey() final  int totalVisits;
@override@JsonKey() final  double totalSpent;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? lastVisitAt;
@override@JsonKey() final  int tier;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime createdAt;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? updatedAt;

/// Create a copy of CustomerLoyalty
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerLoyaltyCopyWith<_CustomerLoyalty> get copyWith => __$CustomerLoyaltyCopyWithImpl<_CustomerLoyalty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerLoyaltyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerLoyalty&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.points, points) || other.points == points)&&(identical(other.totalVisits, totalVisits) || other.totalVisits == totalVisits)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.lastVisitAt, lastVisitAt) || other.lastVisitAt == lastVisitAt)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,points,totalVisits,totalSpent,lastVisitAt,tier,createdAt,updatedAt);

@override
String toString() {
  return 'CustomerLoyalty(id: $id, customerId: $customerId, points: $points, totalVisits: $totalVisits, totalSpent: $totalSpent, lastVisitAt: $lastVisitAt, tier: $tier, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CustomerLoyaltyCopyWith<$Res> implements $CustomerLoyaltyCopyWith<$Res> {
  factory _$CustomerLoyaltyCopyWith(_CustomerLoyalty value, $Res Function(_CustomerLoyalty) _then) = __$CustomerLoyaltyCopyWithImpl;
@override @useResult
$Res call({
 int? id, int customerId, double points, int totalVisits, double totalSpent,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? lastVisitAt, int tier,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt
});




}
/// @nodoc
class __$CustomerLoyaltyCopyWithImpl<$Res>
    implements _$CustomerLoyaltyCopyWith<$Res> {
  __$CustomerLoyaltyCopyWithImpl(this._self, this._then);

  final _CustomerLoyalty _self;
  final $Res Function(_CustomerLoyalty) _then;

/// Create a copy of CustomerLoyalty
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? customerId = null,Object? points = null,Object? totalVisits = null,Object? totalSpent = null,Object? lastVisitAt = freezed,Object? tier = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_CustomerLoyalty(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as double,totalVisits: null == totalVisits ? _self.totalVisits : totalVisits // ignore: cast_nullable_to_non_nullable
as int,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,lastVisitAt: freezed == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Subscription {

 int? get id; String? get purchaseCode;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get validFrom;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get validTill; SubscriptionType? get subscriptionType;
/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionCopyWith<Subscription> get copyWith => _$SubscriptionCopyWithImpl<Subscription>(this as Subscription, _$identity);

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Subscription&&(identical(other.id, id) || other.id == id)&&(identical(other.purchaseCode, purchaseCode) || other.purchaseCode == purchaseCode)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTill, validTill) || other.validTill == validTill)&&(identical(other.subscriptionType, subscriptionType) || other.subscriptionType == subscriptionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purchaseCode,validFrom,validTill,subscriptionType);

@override
String toString() {
  return 'Subscription(id: $id, purchaseCode: $purchaseCode, validFrom: $validFrom, validTill: $validTill, subscriptionType: $subscriptionType)';
}


}

/// @nodoc
abstract mixin class $SubscriptionCopyWith<$Res>  {
  factory $SubscriptionCopyWith(Subscription value, $Res Function(Subscription) _then) = _$SubscriptionCopyWithImpl;
@useResult
$Res call({
 int? id, String? purchaseCode,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? validFrom,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? validTill, SubscriptionType? subscriptionType
});




}
/// @nodoc
class _$SubscriptionCopyWithImpl<$Res>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._self, this._then);

  final Subscription _self;
  final $Res Function(Subscription) _then;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? purchaseCode = freezed,Object? validFrom = freezed,Object? validTill = freezed,Object? subscriptionType = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,purchaseCode: freezed == purchaseCode ? _self.purchaseCode : purchaseCode // ignore: cast_nullable_to_non_nullable
as String?,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,validTill: freezed == validTill ? _self.validTill : validTill // ignore: cast_nullable_to_non_nullable
as DateTime?,subscriptionType: freezed == subscriptionType ? _self.subscriptionType : subscriptionType // ignore: cast_nullable_to_non_nullable
as SubscriptionType?,
  ));
}

}


/// Adds pattern-matching-related methods to [Subscription].
extension SubscriptionPatterns on Subscription {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Subscription value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Subscription() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Subscription value)  $default,){
final _that = this;
switch (_that) {
case _Subscription():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Subscription value)?  $default,){
final _that = this;
switch (_that) {
case _Subscription() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? purchaseCode, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? validFrom, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? validTill,  SubscriptionType? subscriptionType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that.id,_that.purchaseCode,_that.validFrom,_that.validTill,_that.subscriptionType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? purchaseCode, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? validFrom, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? validTill,  SubscriptionType? subscriptionType)  $default,) {final _that = this;
switch (_that) {
case _Subscription():
return $default(_that.id,_that.purchaseCode,_that.validFrom,_that.validTill,_that.subscriptionType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? purchaseCode, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? validFrom, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? validTill,  SubscriptionType? subscriptionType)?  $default,) {final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that.id,_that.purchaseCode,_that.validFrom,_that.validTill,_that.subscriptionType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Subscription implements Subscription {
  const _Subscription({this.id, this.purchaseCode, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.validFrom, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.validTill, this.subscriptionType = SubscriptionType.individual});
  factory _Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);

@override final  int? id;
@override final  String? purchaseCode;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? validFrom;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? validTill;
@override@JsonKey() final  SubscriptionType? subscriptionType;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionCopyWith<_Subscription> get copyWith => __$SubscriptionCopyWithImpl<_Subscription>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Subscription&&(identical(other.id, id) || other.id == id)&&(identical(other.purchaseCode, purchaseCode) || other.purchaseCode == purchaseCode)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTill, validTill) || other.validTill == validTill)&&(identical(other.subscriptionType, subscriptionType) || other.subscriptionType == subscriptionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purchaseCode,validFrom,validTill,subscriptionType);

@override
String toString() {
  return 'Subscription(id: $id, purchaseCode: $purchaseCode, validFrom: $validFrom, validTill: $validTill, subscriptionType: $subscriptionType)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionCopyWith<$Res> implements $SubscriptionCopyWith<$Res> {
  factory _$SubscriptionCopyWith(_Subscription value, $Res Function(_Subscription) _then) = __$SubscriptionCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? purchaseCode,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? validFrom,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? validTill, SubscriptionType? subscriptionType
});




}
/// @nodoc
class __$SubscriptionCopyWithImpl<$Res>
    implements _$SubscriptionCopyWith<$Res> {
  __$SubscriptionCopyWithImpl(this._self, this._then);

  final _Subscription _self;
  final $Res Function(_Subscription) _then;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? purchaseCode = freezed,Object? validFrom = freezed,Object? validTill = freezed,Object? subscriptionType = freezed,}) {
  return _then(_Subscription(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,purchaseCode: freezed == purchaseCode ? _self.purchaseCode : purchaseCode // ignore: cast_nullable_to_non_nullable
as String?,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,validTill: freezed == validTill ? _self.validTill : validTill // ignore: cast_nullable_to_non_nullable
as DateTime?,subscriptionType: freezed == subscriptionType ? _self.subscriptionType : subscriptionType // ignore: cast_nullable_to_non_nullable
as SubscriptionType?,
  ));
}


}

// dart format on

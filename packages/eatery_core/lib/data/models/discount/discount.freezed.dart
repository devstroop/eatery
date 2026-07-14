// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discount.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Discount {

 int? get id; String get name; int get type; double get value; double? get minOrder; int? get maxUses; bool get isActive;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get startsAt;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get endsAt;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get createdAt;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get updatedAt;
/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscountCopyWith<Discount> get copyWith => _$DiscountCopyWithImpl<Discount>(this as Discount, _$identity);

  /// Serializes this Discount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Discount&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.minOrder, minOrder) || other.minOrder == minOrder)&&(identical(other.maxUses, maxUses) || other.maxUses == maxUses)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,value,minOrder,maxUses,isActive,startsAt,endsAt,createdAt,updatedAt);

@override
String toString() {
  return 'Discount(id: $id, name: $name, type: $type, value: $value, minOrder: $minOrder, maxUses: $maxUses, isActive: $isActive, startsAt: $startsAt, endsAt: $endsAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DiscountCopyWith<$Res>  {
  factory $DiscountCopyWith(Discount value, $Res Function(Discount) _then) = _$DiscountCopyWithImpl;
@useResult
$Res call({
 int? id, String name, int type, double value, double? minOrder, int? maxUses, bool isActive,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? startsAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? endsAt,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt
});




}
/// @nodoc
class _$DiscountCopyWithImpl<$Res>
    implements $DiscountCopyWith<$Res> {
  _$DiscountCopyWithImpl(this._self, this._then);

  final Discount _self;
  final $Res Function(Discount) _then;

/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? type = null,Object? value = null,Object? minOrder = freezed,Object? maxUses = freezed,Object? isActive = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,minOrder: freezed == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as double?,maxUses: freezed == maxUses ? _self.maxUses : maxUses // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Discount].
extension DiscountPatterns on Discount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Discount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Discount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Discount value)  $default,){
final _that = this;
switch (_that) {
case _Discount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Discount value)?  $default,){
final _that = this;
switch (_that) {
case _Discount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  int type,  double value,  double? minOrder,  int? maxUses,  bool isActive, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? startsAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? endsAt, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Discount() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.value,_that.minOrder,_that.maxUses,_that.isActive,_that.startsAt,_that.endsAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  int type,  double value,  double? minOrder,  int? maxUses,  bool isActive, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? startsAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? endsAt, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Discount():
return $default(_that.id,_that.name,_that.type,_that.value,_that.minOrder,_that.maxUses,_that.isActive,_that.startsAt,_that.endsAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  int type,  double value,  double? minOrder,  int? maxUses,  bool isActive, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? startsAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? endsAt, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Discount() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.value,_that.minOrder,_that.maxUses,_that.isActive,_that.startsAt,_that.endsAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Discount implements Discount {
  const _Discount({this.id, required this.name, required this.type, required this.value, this.minOrder, this.maxUses, this.isActive = true, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.startsAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.endsAt, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.updatedAt});
  factory _Discount.fromJson(Map<String, dynamic> json) => _$DiscountFromJson(json);

@override final  int? id;
@override final  String name;
@override final  int type;
@override final  double value;
@override final  double? minOrder;
@override final  int? maxUses;
@override@JsonKey() final  bool isActive;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? startsAt;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? endsAt;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime createdAt;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? updatedAt;

/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscountCopyWith<_Discount> get copyWith => __$DiscountCopyWithImpl<_Discount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Discount&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.minOrder, minOrder) || other.minOrder == minOrder)&&(identical(other.maxUses, maxUses) || other.maxUses == maxUses)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,value,minOrder,maxUses,isActive,startsAt,endsAt,createdAt,updatedAt);

@override
String toString() {
  return 'Discount(id: $id, name: $name, type: $type, value: $value, minOrder: $minOrder, maxUses: $maxUses, isActive: $isActive, startsAt: $startsAt, endsAt: $endsAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DiscountCopyWith<$Res> implements $DiscountCopyWith<$Res> {
  factory _$DiscountCopyWith(_Discount value, $Res Function(_Discount) _then) = __$DiscountCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, int type, double value, double? minOrder, int? maxUses, bool isActive,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? startsAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? endsAt,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt
});




}
/// @nodoc
class __$DiscountCopyWithImpl<$Res>
    implements _$DiscountCopyWith<$Res> {
  __$DiscountCopyWithImpl(this._self, this._then);

  final _Discount _self;
  final $Res Function(_Discount) _then;

/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? type = null,Object? value = null,Object? minOrder = freezed,Object? maxUses = freezed,Object? isActive = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_Discount(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,minOrder: freezed == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as double?,maxUses: freezed == maxUses ? _self.maxUses : maxUses // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

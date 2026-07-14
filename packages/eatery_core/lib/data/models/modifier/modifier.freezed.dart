// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Modifier {

 int? get id; int get modifierGroupId; String get name; double get priceAdjust; int get sortOrder; bool get isDefault;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get createdAt;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get updatedAt;
/// Create a copy of Modifier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModifierCopyWith<Modifier> get copyWith => _$ModifierCopyWithImpl<Modifier>(this as Modifier, _$identity);

  /// Serializes this Modifier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Modifier&&(identical(other.id, id) || other.id == id)&&(identical(other.modifierGroupId, modifierGroupId) || other.modifierGroupId == modifierGroupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceAdjust, priceAdjust) || other.priceAdjust == priceAdjust)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,modifierGroupId,name,priceAdjust,sortOrder,isDefault,createdAt,updatedAt);

@override
String toString() {
  return 'Modifier(id: $id, modifierGroupId: $modifierGroupId, name: $name, priceAdjust: $priceAdjust, sortOrder: $sortOrder, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ModifierCopyWith<$Res>  {
  factory $ModifierCopyWith(Modifier value, $Res Function(Modifier) _then) = _$ModifierCopyWithImpl;
@useResult
$Res call({
 int? id, int modifierGroupId, String name, double priceAdjust, int sortOrder, bool isDefault,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt
});




}
/// @nodoc
class _$ModifierCopyWithImpl<$Res>
    implements $ModifierCopyWith<$Res> {
  _$ModifierCopyWithImpl(this._self, this._then);

  final Modifier _self;
  final $Res Function(Modifier) _then;

/// Create a copy of Modifier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? modifierGroupId = null,Object? name = null,Object? priceAdjust = null,Object? sortOrder = null,Object? isDefault = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,modifierGroupId: null == modifierGroupId ? _self.modifierGroupId : modifierGroupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceAdjust: null == priceAdjust ? _self.priceAdjust : priceAdjust // ignore: cast_nullable_to_non_nullable
as double,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Modifier].
extension ModifierPatterns on Modifier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Modifier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Modifier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Modifier value)  $default,){
final _that = this;
switch (_that) {
case _Modifier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Modifier value)?  $default,){
final _that = this;
switch (_that) {
case _Modifier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int modifierGroupId,  String name,  double priceAdjust,  int sortOrder,  bool isDefault, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Modifier() when $default != null:
return $default(_that.id,_that.modifierGroupId,_that.name,_that.priceAdjust,_that.sortOrder,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int modifierGroupId,  String name,  double priceAdjust,  int sortOrder,  bool isDefault, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Modifier():
return $default(_that.id,_that.modifierGroupId,_that.name,_that.priceAdjust,_that.sortOrder,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int modifierGroupId,  String name,  double priceAdjust,  int sortOrder,  bool isDefault, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Modifier() when $default != null:
return $default(_that.id,_that.modifierGroupId,_that.name,_that.priceAdjust,_that.sortOrder,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Modifier implements Modifier {
  const _Modifier({this.id, required this.modifierGroupId, required this.name, this.priceAdjust = 0.0, this.sortOrder = 0, this.isDefault = false, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.updatedAt});
  factory _Modifier.fromJson(Map<String, dynamic> json) => _$ModifierFromJson(json);

@override final  int? id;
@override final  int modifierGroupId;
@override final  String name;
@override@JsonKey() final  double priceAdjust;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  bool isDefault;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime createdAt;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? updatedAt;

/// Create a copy of Modifier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModifierCopyWith<_Modifier> get copyWith => __$ModifierCopyWithImpl<_Modifier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModifierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Modifier&&(identical(other.id, id) || other.id == id)&&(identical(other.modifierGroupId, modifierGroupId) || other.modifierGroupId == modifierGroupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceAdjust, priceAdjust) || other.priceAdjust == priceAdjust)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,modifierGroupId,name,priceAdjust,sortOrder,isDefault,createdAt,updatedAt);

@override
String toString() {
  return 'Modifier(id: $id, modifierGroupId: $modifierGroupId, name: $name, priceAdjust: $priceAdjust, sortOrder: $sortOrder, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ModifierCopyWith<$Res> implements $ModifierCopyWith<$Res> {
  factory _$ModifierCopyWith(_Modifier value, $Res Function(_Modifier) _then) = __$ModifierCopyWithImpl;
@override @useResult
$Res call({
 int? id, int modifierGroupId, String name, double priceAdjust, int sortOrder, bool isDefault,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt
});




}
/// @nodoc
class __$ModifierCopyWithImpl<$Res>
    implements _$ModifierCopyWith<$Res> {
  __$ModifierCopyWithImpl(this._self, this._then);

  final _Modifier _self;
  final $Res Function(_Modifier) _then;

/// Create a copy of Modifier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? modifierGroupId = null,Object? name = null,Object? priceAdjust = null,Object? sortOrder = null,Object? isDefault = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_Modifier(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,modifierGroupId: null == modifierGroupId ? _self.modifierGroupId : modifierGroupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceAdjust: null == priceAdjust ? _self.priceAdjust : priceAdjust // ignore: cast_nullable_to_non_nullable
as double,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

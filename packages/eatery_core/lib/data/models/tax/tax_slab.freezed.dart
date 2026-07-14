// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tax_slab.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaxSlab {

 int? get id; String get name; double get rate; TaxType get type;
/// Create a copy of TaxSlab
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaxSlabCopyWith<TaxSlab> get copyWith => _$TaxSlabCopyWithImpl<TaxSlab>(this as TaxSlab, _$identity);

  /// Serializes this TaxSlab to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaxSlab&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,rate,type);

@override
String toString() {
  return 'TaxSlab(id: $id, name: $name, rate: $rate, type: $type)';
}


}

/// @nodoc
abstract mixin class $TaxSlabCopyWith<$Res>  {
  factory $TaxSlabCopyWith(TaxSlab value, $Res Function(TaxSlab) _then) = _$TaxSlabCopyWithImpl;
@useResult
$Res call({
 int? id, String name, double rate, TaxType type
});




}
/// @nodoc
class _$TaxSlabCopyWithImpl<$Res>
    implements $TaxSlabCopyWith<$Res> {
  _$TaxSlabCopyWithImpl(this._self, this._then);

  final TaxSlab _self;
  final $Res Function(TaxSlab) _then;

/// Create a copy of TaxSlab
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? rate = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaxType,
  ));
}

}


/// Adds pattern-matching-related methods to [TaxSlab].
extension TaxSlabPatterns on TaxSlab {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaxSlab value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaxSlab() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaxSlab value)  $default,){
final _that = this;
switch (_that) {
case _TaxSlab():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaxSlab value)?  $default,){
final _that = this;
switch (_that) {
case _TaxSlab() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  double rate,  TaxType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaxSlab() when $default != null:
return $default(_that.id,_that.name,_that.rate,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  double rate,  TaxType type)  $default,) {final _that = this;
switch (_that) {
case _TaxSlab():
return $default(_that.id,_that.name,_that.rate,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  double rate,  TaxType type)?  $default,) {final _that = this;
switch (_that) {
case _TaxSlab() when $default != null:
return $default(_that.id,_that.name,_that.rate,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaxSlab implements TaxSlab {
  const _TaxSlab({this.id, required this.name, required this.rate, this.type = TaxType.inclusive});
  factory _TaxSlab.fromJson(Map<String, dynamic> json) => _$TaxSlabFromJson(json);

@override final  int? id;
@override final  String name;
@override final  double rate;
@override@JsonKey() final  TaxType type;

/// Create a copy of TaxSlab
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaxSlabCopyWith<_TaxSlab> get copyWith => __$TaxSlabCopyWithImpl<_TaxSlab>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaxSlabToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaxSlab&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,rate,type);

@override
String toString() {
  return 'TaxSlab(id: $id, name: $name, rate: $rate, type: $type)';
}


}

/// @nodoc
abstract mixin class _$TaxSlabCopyWith<$Res> implements $TaxSlabCopyWith<$Res> {
  factory _$TaxSlabCopyWith(_TaxSlab value, $Res Function(_TaxSlab) _then) = __$TaxSlabCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, double rate, TaxType type
});




}
/// @nodoc
class __$TaxSlabCopyWithImpl<$Res>
    implements _$TaxSlabCopyWith<$Res> {
  __$TaxSlabCopyWithImpl(this._self, this._then);

  final _TaxSlab _self;
  final $Res Function(_TaxSlab) _then;

/// Create a copy of TaxSlab
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? rate = null,Object? type = null,}) {
  return _then(_TaxSlab(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaxType,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_print.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AutoPrint {

 int? get id; bool? get invoicePrintEnabled; bool? get kotPrintEnabled; int? get invoicePrinterId; int? get kotPrinterId;
/// Create a copy of AutoPrint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutoPrintCopyWith<AutoPrint> get copyWith => _$AutoPrintCopyWithImpl<AutoPrint>(this as AutoPrint, _$identity);

  /// Serializes this AutoPrint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutoPrint&&(identical(other.id, id) || other.id == id)&&(identical(other.invoicePrintEnabled, invoicePrintEnabled) || other.invoicePrintEnabled == invoicePrintEnabled)&&(identical(other.kotPrintEnabled, kotPrintEnabled) || other.kotPrintEnabled == kotPrintEnabled)&&(identical(other.invoicePrinterId, invoicePrinterId) || other.invoicePrinterId == invoicePrinterId)&&(identical(other.kotPrinterId, kotPrinterId) || other.kotPrinterId == kotPrinterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoicePrintEnabled,kotPrintEnabled,invoicePrinterId,kotPrinterId);

@override
String toString() {
  return 'AutoPrint(id: $id, invoicePrintEnabled: $invoicePrintEnabled, kotPrintEnabled: $kotPrintEnabled, invoicePrinterId: $invoicePrinterId, kotPrinterId: $kotPrinterId)';
}


}

/// @nodoc
abstract mixin class $AutoPrintCopyWith<$Res>  {
  factory $AutoPrintCopyWith(AutoPrint value, $Res Function(AutoPrint) _then) = _$AutoPrintCopyWithImpl;
@useResult
$Res call({
 int? id, bool? invoicePrintEnabled, bool? kotPrintEnabled, int? invoicePrinterId, int? kotPrinterId
});




}
/// @nodoc
class _$AutoPrintCopyWithImpl<$Res>
    implements $AutoPrintCopyWith<$Res> {
  _$AutoPrintCopyWithImpl(this._self, this._then);

  final AutoPrint _self;
  final $Res Function(AutoPrint) _then;

/// Create a copy of AutoPrint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? invoicePrintEnabled = freezed,Object? kotPrintEnabled = freezed,Object? invoicePrinterId = freezed,Object? kotPrinterId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,invoicePrintEnabled: freezed == invoicePrintEnabled ? _self.invoicePrintEnabled : invoicePrintEnabled // ignore: cast_nullable_to_non_nullable
as bool?,kotPrintEnabled: freezed == kotPrintEnabled ? _self.kotPrintEnabled : kotPrintEnabled // ignore: cast_nullable_to_non_nullable
as bool?,invoicePrinterId: freezed == invoicePrinterId ? _self.invoicePrinterId : invoicePrinterId // ignore: cast_nullable_to_non_nullable
as int?,kotPrinterId: freezed == kotPrinterId ? _self.kotPrinterId : kotPrinterId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AutoPrint].
extension AutoPrintPatterns on AutoPrint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutoPrint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutoPrint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutoPrint value)  $default,){
final _that = this;
switch (_that) {
case _AutoPrint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutoPrint value)?  $default,){
final _that = this;
switch (_that) {
case _AutoPrint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  bool? invoicePrintEnabled,  bool? kotPrintEnabled,  int? invoicePrinterId,  int? kotPrinterId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutoPrint() when $default != null:
return $default(_that.id,_that.invoicePrintEnabled,_that.kotPrintEnabled,_that.invoicePrinterId,_that.kotPrinterId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  bool? invoicePrintEnabled,  bool? kotPrintEnabled,  int? invoicePrinterId,  int? kotPrinterId)  $default,) {final _that = this;
switch (_that) {
case _AutoPrint():
return $default(_that.id,_that.invoicePrintEnabled,_that.kotPrintEnabled,_that.invoicePrinterId,_that.kotPrinterId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  bool? invoicePrintEnabled,  bool? kotPrintEnabled,  int? invoicePrinterId,  int? kotPrinterId)?  $default,) {final _that = this;
switch (_that) {
case _AutoPrint() when $default != null:
return $default(_that.id,_that.invoicePrintEnabled,_that.kotPrintEnabled,_that.invoicePrinterId,_that.kotPrinterId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutoPrint implements AutoPrint {
  const _AutoPrint({this.id, this.invoicePrintEnabled, this.kotPrintEnabled, this.invoicePrinterId, this.kotPrinterId});
  factory _AutoPrint.fromJson(Map<String, dynamic> json) => _$AutoPrintFromJson(json);

@override final  int? id;
@override final  bool? invoicePrintEnabled;
@override final  bool? kotPrintEnabled;
@override final  int? invoicePrinterId;
@override final  int? kotPrinterId;

/// Create a copy of AutoPrint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutoPrintCopyWith<_AutoPrint> get copyWith => __$AutoPrintCopyWithImpl<_AutoPrint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutoPrintToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutoPrint&&(identical(other.id, id) || other.id == id)&&(identical(other.invoicePrintEnabled, invoicePrintEnabled) || other.invoicePrintEnabled == invoicePrintEnabled)&&(identical(other.kotPrintEnabled, kotPrintEnabled) || other.kotPrintEnabled == kotPrintEnabled)&&(identical(other.invoicePrinterId, invoicePrinterId) || other.invoicePrinterId == invoicePrinterId)&&(identical(other.kotPrinterId, kotPrinterId) || other.kotPrinterId == kotPrinterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoicePrintEnabled,kotPrintEnabled,invoicePrinterId,kotPrinterId);

@override
String toString() {
  return 'AutoPrint(id: $id, invoicePrintEnabled: $invoicePrintEnabled, kotPrintEnabled: $kotPrintEnabled, invoicePrinterId: $invoicePrinterId, kotPrinterId: $kotPrinterId)';
}


}

/// @nodoc
abstract mixin class _$AutoPrintCopyWith<$Res> implements $AutoPrintCopyWith<$Res> {
  factory _$AutoPrintCopyWith(_AutoPrint value, $Res Function(_AutoPrint) _then) = __$AutoPrintCopyWithImpl;
@override @useResult
$Res call({
 int? id, bool? invoicePrintEnabled, bool? kotPrintEnabled, int? invoicePrinterId, int? kotPrinterId
});




}
/// @nodoc
class __$AutoPrintCopyWithImpl<$Res>
    implements _$AutoPrintCopyWith<$Res> {
  __$AutoPrintCopyWithImpl(this._self, this._then);

  final _AutoPrint _self;
  final $Res Function(_AutoPrint) _then;

/// Create a copy of AutoPrint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? invoicePrintEnabled = freezed,Object? kotPrintEnabled = freezed,Object? invoicePrinterId = freezed,Object? kotPrinterId = freezed,}) {
  return _then(_AutoPrint(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,invoicePrintEnabled: freezed == invoicePrintEnabled ? _self.invoicePrintEnabled : invoicePrintEnabled // ignore: cast_nullable_to_non_nullable
as bool?,kotPrintEnabled: freezed == kotPrintEnabled ? _self.kotPrintEnabled : kotPrintEnabled // ignore: cast_nullable_to_non_nullable
as bool?,invoicePrinterId: freezed == invoicePrinterId ? _self.invoicePrinterId : invoicePrinterId // ignore: cast_nullable_to_non_nullable
as int?,kotPrinterId: freezed == kotPrinterId ? _self.kotPrinterId : kotPrinterId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

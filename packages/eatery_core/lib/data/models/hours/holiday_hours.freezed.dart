// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holiday_hours.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HolidayHours {

 int? get id; String get date; String? get openTime; String? get closeTime; String? get description;
/// Create a copy of HolidayHours
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HolidayHoursCopyWith<HolidayHours> get copyWith => _$HolidayHoursCopyWithImpl<HolidayHours>(this as HolidayHours, _$identity);

  /// Serializes this HolidayHours to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HolidayHours&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,openTime,closeTime,description);

@override
String toString() {
  return 'HolidayHours(id: $id, date: $date, openTime: $openTime, closeTime: $closeTime, description: $description)';
}


}

/// @nodoc
abstract mixin class $HolidayHoursCopyWith<$Res>  {
  factory $HolidayHoursCopyWith(HolidayHours value, $Res Function(HolidayHours) _then) = _$HolidayHoursCopyWithImpl;
@useResult
$Res call({
 int? id, String date, String? openTime, String? closeTime, String? description
});




}
/// @nodoc
class _$HolidayHoursCopyWithImpl<$Res>
    implements $HolidayHoursCopyWith<$Res> {
  _$HolidayHoursCopyWithImpl(this._self, this._then);

  final HolidayHours _self;
  final $Res Function(HolidayHours) _then;

/// Create a copy of HolidayHours
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? date = null,Object? openTime = freezed,Object? closeTime = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,openTime: freezed == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as String?,closeTime: freezed == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HolidayHours].
extension HolidayHoursPatterns on HolidayHours {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HolidayHours value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HolidayHours() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HolidayHours value)  $default,){
final _that = this;
switch (_that) {
case _HolidayHours():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HolidayHours value)?  $default,){
final _that = this;
switch (_that) {
case _HolidayHours() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String date,  String? openTime,  String? closeTime,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HolidayHours() when $default != null:
return $default(_that.id,_that.date,_that.openTime,_that.closeTime,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String date,  String? openTime,  String? closeTime,  String? description)  $default,) {final _that = this;
switch (_that) {
case _HolidayHours():
return $default(_that.id,_that.date,_that.openTime,_that.closeTime,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String date,  String? openTime,  String? closeTime,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _HolidayHours() when $default != null:
return $default(_that.id,_that.date,_that.openTime,_that.closeTime,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HolidayHours implements HolidayHours {
  const _HolidayHours({this.id, required this.date, this.openTime, this.closeTime, this.description});
  factory _HolidayHours.fromJson(Map<String, dynamic> json) => _$HolidayHoursFromJson(json);

@override final  int? id;
@override final  String date;
@override final  String? openTime;
@override final  String? closeTime;
@override final  String? description;

/// Create a copy of HolidayHours
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HolidayHoursCopyWith<_HolidayHours> get copyWith => __$HolidayHoursCopyWithImpl<_HolidayHours>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HolidayHoursToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HolidayHours&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,openTime,closeTime,description);

@override
String toString() {
  return 'HolidayHours(id: $id, date: $date, openTime: $openTime, closeTime: $closeTime, description: $description)';
}


}

/// @nodoc
abstract mixin class _$HolidayHoursCopyWith<$Res> implements $HolidayHoursCopyWith<$Res> {
  factory _$HolidayHoursCopyWith(_HolidayHours value, $Res Function(_HolidayHours) _then) = __$HolidayHoursCopyWithImpl;
@override @useResult
$Res call({
 int? id, String date, String? openTime, String? closeTime, String? description
});




}
/// @nodoc
class __$HolidayHoursCopyWithImpl<$Res>
    implements _$HolidayHoursCopyWith<$Res> {
  __$HolidayHoursCopyWithImpl(this._self, this._then);

  final _HolidayHours _self;
  final $Res Function(_HolidayHours) _then;

/// Create a copy of HolidayHours
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? date = null,Object? openTime = freezed,Object? closeTime = freezed,Object? description = freezed,}) {
  return _then(_HolidayHours(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,openTime: freezed == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as String?,closeTime: freezed == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

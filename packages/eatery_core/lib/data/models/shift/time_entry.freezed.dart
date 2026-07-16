// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeEntry {

 int? get id; int get employeeId; int? get shiftId;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get clockIn;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get clockOut;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get breakStart;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get breakEnd; String? get note;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get createdAt;
/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeEntryCopyWith<TimeEntry> get copyWith => _$TimeEntryCopyWithImpl<TimeEntry>(this as TimeEntry, _$identity);

  /// Serializes this TimeEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.shiftId, shiftId) || other.shiftId == shiftId)&&(identical(other.clockIn, clockIn) || other.clockIn == clockIn)&&(identical(other.clockOut, clockOut) || other.clockOut == clockOut)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,shiftId,clockIn,clockOut,breakStart,breakEnd,note,createdAt);

@override
String toString() {
  return 'TimeEntry(id: $id, employeeId: $employeeId, shiftId: $shiftId, clockIn: $clockIn, clockOut: $clockOut, breakStart: $breakStart, breakEnd: $breakEnd, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TimeEntryCopyWith<$Res>  {
  factory $TimeEntryCopyWith(TimeEntry value, $Res Function(TimeEntry) _then) = _$TimeEntryCopyWithImpl;
@useResult
$Res call({
 int? id, int employeeId, int? shiftId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime clockIn,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? clockOut,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? breakStart,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? breakEnd, String? note,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt
});




}
/// @nodoc
class _$TimeEntryCopyWithImpl<$Res>
    implements $TimeEntryCopyWith<$Res> {
  _$TimeEntryCopyWithImpl(this._self, this._then);

  final TimeEntry _self;
  final $Res Function(TimeEntry) _then;

/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? employeeId = null,Object? shiftId = freezed,Object? clockIn = null,Object? clockOut = freezed,Object? breakStart = freezed,Object? breakEnd = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int,shiftId: freezed == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as int?,clockIn: null == clockIn ? _self.clockIn : clockIn // ignore: cast_nullable_to_non_nullable
as DateTime,clockOut: freezed == clockOut ? _self.clockOut : clockOut // ignore: cast_nullable_to_non_nullable
as DateTime?,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as DateTime?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeEntry].
extension TimeEntryPatterns on TimeEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeEntry value)  $default,){
final _that = this;
switch (_that) {
case _TimeEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeEntry value)?  $default,){
final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int employeeId,  int? shiftId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime clockIn, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? clockOut, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? breakStart, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? breakEnd,  String? note, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
return $default(_that.id,_that.employeeId,_that.shiftId,_that.clockIn,_that.clockOut,_that.breakStart,_that.breakEnd,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int employeeId,  int? shiftId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime clockIn, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? clockOut, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? breakStart, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? breakEnd,  String? note, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TimeEntry():
return $default(_that.id,_that.employeeId,_that.shiftId,_that.clockIn,_that.clockOut,_that.breakStart,_that.breakEnd,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int employeeId,  int? shiftId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime clockIn, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? clockOut, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? breakStart, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? breakEnd,  String? note, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
return $default(_that.id,_that.employeeId,_that.shiftId,_that.clockIn,_that.clockOut,_that.breakStart,_that.breakEnd,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeEntry implements TimeEntry {
  const _TimeEntry({this.id, required this.employeeId, this.shiftId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.clockIn, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.clockOut, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.breakStart, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.breakEnd, this.note, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.createdAt});
  factory _TimeEntry.fromJson(Map<String, dynamic> json) => _$TimeEntryFromJson(json);

@override final  int? id;
@override final  int employeeId;
@override final  int? shiftId;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime clockIn;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? clockOut;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? breakStart;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? breakEnd;
@override final  String? note;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime createdAt;

/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeEntryCopyWith<_TimeEntry> get copyWith => __$TimeEntryCopyWithImpl<_TimeEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.shiftId, shiftId) || other.shiftId == shiftId)&&(identical(other.clockIn, clockIn) || other.clockIn == clockIn)&&(identical(other.clockOut, clockOut) || other.clockOut == clockOut)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,shiftId,clockIn,clockOut,breakStart,breakEnd,note,createdAt);

@override
String toString() {
  return 'TimeEntry(id: $id, employeeId: $employeeId, shiftId: $shiftId, clockIn: $clockIn, clockOut: $clockOut, breakStart: $breakStart, breakEnd: $breakEnd, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TimeEntryCopyWith<$Res> implements $TimeEntryCopyWith<$Res> {
  factory _$TimeEntryCopyWith(_TimeEntry value, $Res Function(_TimeEntry) _then) = __$TimeEntryCopyWithImpl;
@override @useResult
$Res call({
 int? id, int employeeId, int? shiftId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime clockIn,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? clockOut,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? breakStart,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? breakEnd, String? note,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt
});




}
/// @nodoc
class __$TimeEntryCopyWithImpl<$Res>
    implements _$TimeEntryCopyWith<$Res> {
  __$TimeEntryCopyWithImpl(this._self, this._then);

  final _TimeEntry _self;
  final $Res Function(_TimeEntry) _then;

/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? employeeId = null,Object? shiftId = freezed,Object? clockIn = null,Object? clockOut = freezed,Object? breakStart = freezed,Object? breakEnd = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_TimeEntry(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int,shiftId: freezed == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as int?,clockIn: null == clockIn ? _self.clockIn : clockIn // ignore: cast_nullable_to_non_nullable
as DateTime,clockOut: freezed == clockOut ? _self.clockOut : clockOut // ignore: cast_nullable_to_non_nullable
as DateTime?,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as DateTime?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reservation {

 int? get id; String get customerName; String? get customerPhone; int? get diningTableId; int get partySize;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get dateTime; int get duration; int get status; String? get note; int? get createdBy;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get createdAt;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get updatedAt;
/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationCopyWith<Reservation> get copyWith => _$ReservationCopyWithImpl<Reservation>(this as Reservation, _$identity);

  /// Serializes this Reservation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reservation&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.diningTableId, diningTableId) || other.diningTableId == diningTableId)&&(identical(other.partySize, partySize) || other.partySize == partySize)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerName,customerPhone,diningTableId,partySize,dateTime,duration,status,note,createdBy,createdAt,updatedAt);

@override
String toString() {
  return 'Reservation(id: $id, customerName: $customerName, customerPhone: $customerPhone, diningTableId: $diningTableId, partySize: $partySize, dateTime: $dateTime, duration: $duration, status: $status, note: $note, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReservationCopyWith<$Res>  {
  factory $ReservationCopyWith(Reservation value, $Res Function(Reservation) _then) = _$ReservationCopyWithImpl;
@useResult
$Res call({
 int? id, String customerName, String? customerPhone, int? diningTableId, int partySize,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime dateTime, int duration, int status, String? note, int? createdBy,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt
});




}
/// @nodoc
class _$ReservationCopyWithImpl<$Res>
    implements $ReservationCopyWith<$Res> {
  _$ReservationCopyWithImpl(this._self, this._then);

  final Reservation _self;
  final $Res Function(Reservation) _then;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? customerName = null,Object? customerPhone = freezed,Object? diningTableId = freezed,Object? partySize = null,Object? dateTime = null,Object? duration = null,Object? status = null,Object? note = freezed,Object? createdBy = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,diningTableId: freezed == diningTableId ? _self.diningTableId : diningTableId // ignore: cast_nullable_to_non_nullable
as int?,partySize: null == partySize ? _self.partySize : partySize // ignore: cast_nullable_to_non_nullable
as int,dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Reservation].
extension ReservationPatterns on Reservation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reservation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reservation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reservation value)  $default,){
final _that = this;
switch (_that) {
case _Reservation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reservation value)?  $default,){
final _that = this;
switch (_that) {
case _Reservation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String customerName,  String? customerPhone,  int? diningTableId,  int partySize, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime dateTime,  int duration,  int status,  String? note,  int? createdBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that.id,_that.customerName,_that.customerPhone,_that.diningTableId,_that.partySize,_that.dateTime,_that.duration,_that.status,_that.note,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String customerName,  String? customerPhone,  int? diningTableId,  int partySize, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime dateTime,  int duration,  int status,  String? note,  int? createdBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Reservation():
return $default(_that.id,_that.customerName,_that.customerPhone,_that.diningTableId,_that.partySize,_that.dateTime,_that.duration,_that.status,_that.note,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String customerName,  String? customerPhone,  int? diningTableId,  int partySize, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime dateTime,  int duration,  int status,  String? note,  int? createdBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that.id,_that.customerName,_that.customerPhone,_that.diningTableId,_that.partySize,_that.dateTime,_that.duration,_that.status,_that.note,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reservation implements Reservation {
  const _Reservation({this.id, required this.customerName, this.customerPhone, this.diningTableId, required this.partySize, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.dateTime, this.duration = 60, this.status = 0, this.note, this.createdBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.updatedAt});
  factory _Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

@override final  int? id;
@override final  String customerName;
@override final  String? customerPhone;
@override final  int? diningTableId;
@override final  int partySize;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime dateTime;
@override@JsonKey() final  int duration;
@override@JsonKey() final  int status;
@override final  String? note;
@override final  int? createdBy;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime createdAt;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? updatedAt;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationCopyWith<_Reservation> get copyWith => __$ReservationCopyWithImpl<_Reservation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reservation&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.diningTableId, diningTableId) || other.diningTableId == diningTableId)&&(identical(other.partySize, partySize) || other.partySize == partySize)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerName,customerPhone,diningTableId,partySize,dateTime,duration,status,note,createdBy,createdAt,updatedAt);

@override
String toString() {
  return 'Reservation(id: $id, customerName: $customerName, customerPhone: $customerPhone, diningTableId: $diningTableId, partySize: $partySize, dateTime: $dateTime, duration: $duration, status: $status, note: $note, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReservationCopyWith<$Res> implements $ReservationCopyWith<$Res> {
  factory _$ReservationCopyWith(_Reservation value, $Res Function(_Reservation) _then) = __$ReservationCopyWithImpl;
@override @useResult
$Res call({
 int? id, String customerName, String? customerPhone, int? diningTableId, int partySize,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime dateTime, int duration, int status, String? note, int? createdBy,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt
});




}
/// @nodoc
class __$ReservationCopyWithImpl<$Res>
    implements _$ReservationCopyWith<$Res> {
  __$ReservationCopyWithImpl(this._self, this._then);

  final _Reservation _self;
  final $Res Function(_Reservation) _then;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? customerName = null,Object? customerPhone = freezed,Object? diningTableId = freezed,Object? partySize = null,Object? dateTime = null,Object? duration = null,Object? status = null,Object? note = freezed,Object? createdBy = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_Reservation(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,diningTableId: freezed == diningTableId ? _self.diningTableId : diningTableId // ignore: cast_nullable_to_non_nullable
as int?,partySize: null == partySize ? _self.partySize : partySize // ignore: cast_nullable_to_non_nullable
as int,dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

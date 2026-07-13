// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kds_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KdsStation {

 int? get id; String get name; String? get description; int get sortOrder; bool get isActive;
/// Create a copy of KdsStation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KdsStationCopyWith<KdsStation> get copyWith => _$KdsStationCopyWithImpl<KdsStation>(this as KdsStation, _$identity);

  /// Serializes this KdsStation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KdsStation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,sortOrder,isActive);

@override
String toString() {
  return 'KdsStation(id: $id, name: $name, description: $description, sortOrder: $sortOrder, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $KdsStationCopyWith<$Res>  {
  factory $KdsStationCopyWith(KdsStation value, $Res Function(KdsStation) _then) = _$KdsStationCopyWithImpl;
@useResult
$Res call({
 int? id, String name, String? description, int sortOrder, bool isActive
});




}
/// @nodoc
class _$KdsStationCopyWithImpl<$Res>
    implements $KdsStationCopyWith<$Res> {
  _$KdsStationCopyWithImpl(this._self, this._then);

  final KdsStation _self;
  final $Res Function(KdsStation) _then;

/// Create a copy of KdsStation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? sortOrder = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [KdsStation].
extension KdsStationPatterns on KdsStation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KdsStation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KdsStation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KdsStation value)  $default,){
final _that = this;
switch (_that) {
case _KdsStation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KdsStation value)?  $default,){
final _that = this;
switch (_that) {
case _KdsStation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  String? description,  int sortOrder,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KdsStation() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.sortOrder,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  String? description,  int sortOrder,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _KdsStation():
return $default(_that.id,_that.name,_that.description,_that.sortOrder,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  String? description,  int sortOrder,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _KdsStation() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.sortOrder,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KdsStation implements KdsStation {
  const _KdsStation({this.id, required this.name, this.description, this.sortOrder = 0, this.isActive = true});
  factory _KdsStation.fromJson(Map<String, dynamic> json) => _$KdsStationFromJson(json);

@override final  int? id;
@override final  String name;
@override final  String? description;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  bool isActive;

/// Create a copy of KdsStation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KdsStationCopyWith<_KdsStation> get copyWith => __$KdsStationCopyWithImpl<_KdsStation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KdsStationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KdsStation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,sortOrder,isActive);

@override
String toString() {
  return 'KdsStation(id: $id, name: $name, description: $description, sortOrder: $sortOrder, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$KdsStationCopyWith<$Res> implements $KdsStationCopyWith<$Res> {
  factory _$KdsStationCopyWith(_KdsStation value, $Res Function(_KdsStation) _then) = __$KdsStationCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, String? description, int sortOrder, bool isActive
});




}
/// @nodoc
class __$KdsStationCopyWithImpl<$Res>
    implements _$KdsStationCopyWith<$Res> {
  __$KdsStationCopyWithImpl(this._self, this._then);

  final _KdsStation _self;
  final $Res Function(_KdsStation) _then;

/// Create a copy of KdsStation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? sortOrder = null,Object? isActive = null,}) {
  return _then(_KdsStation(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

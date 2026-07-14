// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Printer {

 int? get id; String get name; String? get bluetoothAddress; String? get usbVendorId; String? get usbProductId; PrinterType get type;
/// Create a copy of Printer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrinterCopyWith<Printer> get copyWith => _$PrinterCopyWithImpl<Printer>(this as Printer, _$identity);

  /// Serializes this Printer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Printer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.bluetoothAddress, bluetoothAddress) || other.bluetoothAddress == bluetoothAddress)&&(identical(other.usbVendorId, usbVendorId) || other.usbVendorId == usbVendorId)&&(identical(other.usbProductId, usbProductId) || other.usbProductId == usbProductId)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,bluetoothAddress,usbVendorId,usbProductId,type);

@override
String toString() {
  return 'Printer(id: $id, name: $name, bluetoothAddress: $bluetoothAddress, usbVendorId: $usbVendorId, usbProductId: $usbProductId, type: $type)';
}


}

/// @nodoc
abstract mixin class $PrinterCopyWith<$Res>  {
  factory $PrinterCopyWith(Printer value, $Res Function(Printer) _then) = _$PrinterCopyWithImpl;
@useResult
$Res call({
 int? id, String name, String? bluetoothAddress, String? usbVendorId, String? usbProductId, PrinterType type
});




}
/// @nodoc
class _$PrinterCopyWithImpl<$Res>
    implements $PrinterCopyWith<$Res> {
  _$PrinterCopyWithImpl(this._self, this._then);

  final Printer _self;
  final $Res Function(Printer) _then;

/// Create a copy of Printer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? bluetoothAddress = freezed,Object? usbVendorId = freezed,Object? usbProductId = freezed,Object? type = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bluetoothAddress: freezed == bluetoothAddress ? _self.bluetoothAddress : bluetoothAddress // ignore: cast_nullable_to_non_nullable
as String?,usbVendorId: freezed == usbVendorId ? _self.usbVendorId : usbVendorId // ignore: cast_nullable_to_non_nullable
as String?,usbProductId: freezed == usbProductId ? _self.usbProductId : usbProductId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PrinterType,
  ));
}

}


/// Adds pattern-matching-related methods to [Printer].
extension PrinterPatterns on Printer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Printer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Printer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Printer value)  $default,){
final _that = this;
switch (_that) {
case _Printer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Printer value)?  $default,){
final _that = this;
switch (_that) {
case _Printer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  String? bluetoothAddress,  String? usbVendorId,  String? usbProductId,  PrinterType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Printer() when $default != null:
return $default(_that.id,_that.name,_that.bluetoothAddress,_that.usbVendorId,_that.usbProductId,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  String? bluetoothAddress,  String? usbVendorId,  String? usbProductId,  PrinterType type)  $default,) {final _that = this;
switch (_that) {
case _Printer():
return $default(_that.id,_that.name,_that.bluetoothAddress,_that.usbVendorId,_that.usbProductId,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  String? bluetoothAddress,  String? usbVendorId,  String? usbProductId,  PrinterType type)?  $default,) {final _that = this;
switch (_that) {
case _Printer() when $default != null:
return $default(_that.id,_that.name,_that.bluetoothAddress,_that.usbVendorId,_that.usbProductId,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Printer implements Printer {
  const _Printer({this.id, required this.name, this.bluetoothAddress, this.usbVendorId, this.usbProductId, this.type = PrinterType.bluetooth});
  factory _Printer.fromJson(Map<String, dynamic> json) => _$PrinterFromJson(json);

@override final  int? id;
@override final  String name;
@override final  String? bluetoothAddress;
@override final  String? usbVendorId;
@override final  String? usbProductId;
@override@JsonKey() final  PrinterType type;

/// Create a copy of Printer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrinterCopyWith<_Printer> get copyWith => __$PrinterCopyWithImpl<_Printer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrinterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Printer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.bluetoothAddress, bluetoothAddress) || other.bluetoothAddress == bluetoothAddress)&&(identical(other.usbVendorId, usbVendorId) || other.usbVendorId == usbVendorId)&&(identical(other.usbProductId, usbProductId) || other.usbProductId == usbProductId)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,bluetoothAddress,usbVendorId,usbProductId,type);

@override
String toString() {
  return 'Printer(id: $id, name: $name, bluetoothAddress: $bluetoothAddress, usbVendorId: $usbVendorId, usbProductId: $usbProductId, type: $type)';
}


}

/// @nodoc
abstract mixin class _$PrinterCopyWith<$Res> implements $PrinterCopyWith<$Res> {
  factory _$PrinterCopyWith(_Printer value, $Res Function(_Printer) _then) = __$PrinterCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, String? bluetoothAddress, String? usbVendorId, String? usbProductId, PrinterType type
});




}
/// @nodoc
class __$PrinterCopyWithImpl<$Res>
    implements _$PrinterCopyWith<$Res> {
  __$PrinterCopyWithImpl(this._self, this._then);

  final _Printer _self;
  final $Res Function(_Printer) _then;

/// Create a copy of Printer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? bluetoothAddress = freezed,Object? usbVendorId = freezed,Object? usbProductId = freezed,Object? type = null,}) {
  return _then(_Printer(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bluetoothAddress: freezed == bluetoothAddress ? _self.bluetoothAddress : bluetoothAddress // ignore: cast_nullable_to_non_nullable
as String?,usbVendorId: freezed == usbVendorId ? _self.usbVendorId : usbVendorId // ignore: cast_nullable_to_non_nullable
as String?,usbProductId: freezed == usbProductId ? _self.usbProductId : usbProductId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PrinterType,
  ));
}


}

// dart format on

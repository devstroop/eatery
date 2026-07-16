// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dining_table.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiningTable {

 int? get id; String get name; String? get description; int? get orderId; int? get categoryId; int get capacity; DiningTableStatus get status; String? get customerPhone; double? get posX; double? get posY; int get shape; double? get width; double? get height; int? get employeeId;
/// Create a copy of DiningTable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiningTableCopyWith<DiningTable> get copyWith => _$DiningTableCopyWithImpl<DiningTable>(this as DiningTable, _$identity);

  /// Serializes this DiningTable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiningTable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.status, status) || other.status == status)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.posX, posX) || other.posX == posX)&&(identical(other.posY, posY) || other.posY == posY)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,orderId,categoryId,capacity,status,customerPhone,posX,posY,shape,width,height,employeeId);

@override
String toString() {
  return 'DiningTable(id: $id, name: $name, description: $description, orderId: $orderId, categoryId: $categoryId, capacity: $capacity, status: $status, customerPhone: $customerPhone, posX: $posX, posY: $posY, shape: $shape, width: $width, height: $height, employeeId: $employeeId)';
}


}

/// @nodoc
abstract mixin class $DiningTableCopyWith<$Res>  {
  factory $DiningTableCopyWith(DiningTable value, $Res Function(DiningTable) _then) = _$DiningTableCopyWithImpl;
@useResult
$Res call({
 int? id, String name, String? description, int? orderId, int? categoryId, int capacity, DiningTableStatus status, String? customerPhone, double? posX, double? posY, int shape, double? width, double? height, int? employeeId
});




}
/// @nodoc
class _$DiningTableCopyWithImpl<$Res>
    implements $DiningTableCopyWith<$Res> {
  _$DiningTableCopyWithImpl(this._self, this._then);

  final DiningTable _self;
  final $Res Function(DiningTable) _then;

/// Create a copy of DiningTable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? orderId = freezed,Object? categoryId = freezed,Object? capacity = null,Object? status = null,Object? customerPhone = freezed,Object? posX = freezed,Object? posY = freezed,Object? shape = null,Object? width = freezed,Object? height = freezed,Object? employeeId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiningTableStatus,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,posX: freezed == posX ? _self.posX : posX // ignore: cast_nullable_to_non_nullable
as double?,posY: freezed == posY ? _self.posY : posY // ignore: cast_nullable_to_non_nullable
as double?,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as int,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiningTable].
extension DiningTablePatterns on DiningTable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiningTable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiningTable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiningTable value)  $default,){
final _that = this;
switch (_that) {
case _DiningTable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiningTable value)?  $default,){
final _that = this;
switch (_that) {
case _DiningTable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  String? description,  int? orderId,  int? categoryId,  int capacity,  DiningTableStatus status,  String? customerPhone,  double? posX,  double? posY,  int shape,  double? width,  double? height,  int? employeeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiningTable() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.orderId,_that.categoryId,_that.capacity,_that.status,_that.customerPhone,_that.posX,_that.posY,_that.shape,_that.width,_that.height,_that.employeeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  String? description,  int? orderId,  int? categoryId,  int capacity,  DiningTableStatus status,  String? customerPhone,  double? posX,  double? posY,  int shape,  double? width,  double? height,  int? employeeId)  $default,) {final _that = this;
switch (_that) {
case _DiningTable():
return $default(_that.id,_that.name,_that.description,_that.orderId,_that.categoryId,_that.capacity,_that.status,_that.customerPhone,_that.posX,_that.posY,_that.shape,_that.width,_that.height,_that.employeeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  String? description,  int? orderId,  int? categoryId,  int capacity,  DiningTableStatus status,  String? customerPhone,  double? posX,  double? posY,  int shape,  double? width,  double? height,  int? employeeId)?  $default,) {final _that = this;
switch (_that) {
case _DiningTable() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.orderId,_that.categoryId,_that.capacity,_that.status,_that.customerPhone,_that.posX,_that.posY,_that.shape,_that.width,_that.height,_that.employeeId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiningTable implements DiningTable {
  const _DiningTable({this.id, required this.name, this.description, this.orderId, this.categoryId, this.capacity = 0, this.status = DiningTableStatus.available, this.customerPhone, this.posX, this.posY, this.shape = 0, this.width, this.height, this.employeeId});
  factory _DiningTable.fromJson(Map<String, dynamic> json) => _$DiningTableFromJson(json);

@override final  int? id;
@override final  String name;
@override final  String? description;
@override final  int? orderId;
@override final  int? categoryId;
@override@JsonKey() final  int capacity;
@override@JsonKey() final  DiningTableStatus status;
@override final  String? customerPhone;
@override final  double? posX;
@override final  double? posY;
@override@JsonKey() final  int shape;
@override final  double? width;
@override final  double? height;
@override final  int? employeeId;

/// Create a copy of DiningTable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiningTableCopyWith<_DiningTable> get copyWith => __$DiningTableCopyWithImpl<_DiningTable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiningTableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiningTable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.status, status) || other.status == status)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.posX, posX) || other.posX == posX)&&(identical(other.posY, posY) || other.posY == posY)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,orderId,categoryId,capacity,status,customerPhone,posX,posY,shape,width,height,employeeId);

@override
String toString() {
  return 'DiningTable(id: $id, name: $name, description: $description, orderId: $orderId, categoryId: $categoryId, capacity: $capacity, status: $status, customerPhone: $customerPhone, posX: $posX, posY: $posY, shape: $shape, width: $width, height: $height, employeeId: $employeeId)';
}


}

/// @nodoc
abstract mixin class _$DiningTableCopyWith<$Res> implements $DiningTableCopyWith<$Res> {
  factory _$DiningTableCopyWith(_DiningTable value, $Res Function(_DiningTable) _then) = __$DiningTableCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, String? description, int? orderId, int? categoryId, int capacity, DiningTableStatus status, String? customerPhone, double? posX, double? posY, int shape, double? width, double? height, int? employeeId
});




}
/// @nodoc
class __$DiningTableCopyWithImpl<$Res>
    implements _$DiningTableCopyWith<$Res> {
  __$DiningTableCopyWithImpl(this._self, this._then);

  final _DiningTable _self;
  final $Res Function(_DiningTable) _then;

/// Create a copy of DiningTable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? orderId = freezed,Object? categoryId = freezed,Object? capacity = null,Object? status = null,Object? customerPhone = freezed,Object? posX = freezed,Object? posY = freezed,Object? shape = null,Object? width = freezed,Object? height = freezed,Object? employeeId = freezed,}) {
  return _then(_DiningTable(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiningTableStatus,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,posX: freezed == posX ? _self.posX : posX // ignore: cast_nullable_to_non_nullable
as double?,posY: freezed == posY ? _self.posY : posY // ignore: cast_nullable_to_non_nullable
as double?,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as int,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 int? get id; String get name; int? get categoryId; String? get description; String? get image; double get mrpPrice; double? get salePrice; int? get taxSlabId; FoodType? get foodType; ProductType get type; bool get isActive; int? get stationId; String? get stationName;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&(identical(other.mrpPrice, mrpPrice) || other.mrpPrice == mrpPrice)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.taxSlabId, taxSlabId) || other.taxSlabId == taxSlabId)&&(identical(other.foodType, foodType) || other.foodType == foodType)&&(identical(other.type, type) || other.type == type)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.stationId, stationId) || other.stationId == stationId)&&(identical(other.stationName, stationName) || other.stationName == stationName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,description,image,mrpPrice,salePrice,taxSlabId,foodType,type,isActive,stationId,stationName);

@override
String toString() {
  return 'Product(id: $id, name: $name, categoryId: $categoryId, description: $description, image: $image, mrpPrice: $mrpPrice, salePrice: $salePrice, taxSlabId: $taxSlabId, foodType: $foodType, type: $type, isActive: $isActive, stationId: $stationId, stationName: $stationName)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 int? id, String name, int? categoryId, String? description, String? image, double mrpPrice, double? salePrice, int? taxSlabId, FoodType? foodType, ProductType type, bool isActive, int? stationId, String? stationName
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? categoryId = freezed,Object? description = freezed,Object? image = freezed,Object? mrpPrice = null,Object? salePrice = freezed,Object? taxSlabId = freezed,Object? foodType = freezed,Object? type = null,Object? isActive = null,Object? stationId = freezed,Object? stationName = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,mrpPrice: null == mrpPrice ? _self.mrpPrice : mrpPrice // ignore: cast_nullable_to_non_nullable
as double,salePrice: freezed == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double?,taxSlabId: freezed == taxSlabId ? _self.taxSlabId : taxSlabId // ignore: cast_nullable_to_non_nullable
as int?,foodType: freezed == foodType ? _self.foodType : foodType // ignore: cast_nullable_to_non_nullable
as FoodType?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,stationId: freezed == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as int?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  int? categoryId,  String? description,  String? image,  double mrpPrice,  double? salePrice,  int? taxSlabId,  FoodType? foodType,  ProductType type,  bool isActive,  int? stationId,  String? stationName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.description,_that.image,_that.mrpPrice,_that.salePrice,_that.taxSlabId,_that.foodType,_that.type,_that.isActive,_that.stationId,_that.stationName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  int? categoryId,  String? description,  String? image,  double mrpPrice,  double? salePrice,  int? taxSlabId,  FoodType? foodType,  ProductType type,  bool isActive,  int? stationId,  String? stationName)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.categoryId,_that.description,_that.image,_that.mrpPrice,_that.salePrice,_that.taxSlabId,_that.foodType,_that.type,_that.isActive,_that.stationId,_that.stationName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  int? categoryId,  String? description,  String? image,  double mrpPrice,  double? salePrice,  int? taxSlabId,  FoodType? foodType,  ProductType type,  bool isActive,  int? stationId,  String? stationName)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.description,_that.image,_that.mrpPrice,_that.salePrice,_that.taxSlabId,_that.foodType,_that.type,_that.isActive,_that.stationId,_that.stationName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({this.id, required this.name, this.categoryId, this.description, this.image, required this.mrpPrice, this.salePrice, this.taxSlabId, this.foodType, required this.type, required this.isActive, this.stationId, this.stationName});
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  int? id;
@override final  String name;
@override final  int? categoryId;
@override final  String? description;
@override final  String? image;
@override final  double mrpPrice;
@override final  double? salePrice;
@override final  int? taxSlabId;
@override final  FoodType? foodType;
@override final  ProductType type;
@override final  bool isActive;
@override final  int? stationId;
@override final  String? stationName;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&(identical(other.mrpPrice, mrpPrice) || other.mrpPrice == mrpPrice)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.taxSlabId, taxSlabId) || other.taxSlabId == taxSlabId)&&(identical(other.foodType, foodType) || other.foodType == foodType)&&(identical(other.type, type) || other.type == type)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.stationId, stationId) || other.stationId == stationId)&&(identical(other.stationName, stationName) || other.stationName == stationName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,description,image,mrpPrice,salePrice,taxSlabId,foodType,type,isActive,stationId,stationName);

@override
String toString() {
  return 'Product(id: $id, name: $name, categoryId: $categoryId, description: $description, image: $image, mrpPrice: $mrpPrice, salePrice: $salePrice, taxSlabId: $taxSlabId, foodType: $foodType, type: $type, isActive: $isActive, stationId: $stationId, stationName: $stationName)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, int? categoryId, String? description, String? image, double mrpPrice, double? salePrice, int? taxSlabId, FoodType? foodType, ProductType type, bool isActive, int? stationId, String? stationName
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? categoryId = freezed,Object? description = freezed,Object? image = freezed,Object? mrpPrice = null,Object? salePrice = freezed,Object? taxSlabId = freezed,Object? foodType = freezed,Object? type = null,Object? isActive = null,Object? stationId = freezed,Object? stationName = freezed,}) {
  return _then(_Product(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,mrpPrice: null == mrpPrice ? _self.mrpPrice : mrpPrice // ignore: cast_nullable_to_non_nullable
as double,salePrice: freezed == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double?,taxSlabId: freezed == taxSlabId ? _self.taxSlabId : taxSlabId // ignore: cast_nullable_to_non_nullable
as int?,foodType: freezed == foodType ? _self.foodType : foodType // ignore: cast_nullable_to_non_nullable
as FoodType?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,stationId: freezed == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as int?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

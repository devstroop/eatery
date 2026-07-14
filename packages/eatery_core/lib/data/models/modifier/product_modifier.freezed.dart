// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_modifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModifier {

 int get productId; int get modifierGroupId;
/// Create a copy of ProductModifier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModifierCopyWith<ProductModifier> get copyWith => _$ProductModifierCopyWithImpl<ProductModifier>(this as ProductModifier, _$identity);

  /// Serializes this ProductModifier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModifier&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.modifierGroupId, modifierGroupId) || other.modifierGroupId == modifierGroupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,modifierGroupId);

@override
String toString() {
  return 'ProductModifier(productId: $productId, modifierGroupId: $modifierGroupId)';
}


}

/// @nodoc
abstract mixin class $ProductModifierCopyWith<$Res>  {
  factory $ProductModifierCopyWith(ProductModifier value, $Res Function(ProductModifier) _then) = _$ProductModifierCopyWithImpl;
@useResult
$Res call({
 int productId, int modifierGroupId
});




}
/// @nodoc
class _$ProductModifierCopyWithImpl<$Res>
    implements $ProductModifierCopyWith<$Res> {
  _$ProductModifierCopyWithImpl(this._self, this._then);

  final ProductModifier _self;
  final $Res Function(ProductModifier) _then;

/// Create a copy of ProductModifier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? modifierGroupId = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,modifierGroupId: null == modifierGroupId ? _self.modifierGroupId : modifierGroupId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductModifier].
extension ProductModifierPatterns on ProductModifier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModifier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModifier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModifier value)  $default,){
final _that = this;
switch (_that) {
case _ProductModifier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModifier value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModifier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  int modifierGroupId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModifier() when $default != null:
return $default(_that.productId,_that.modifierGroupId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  int modifierGroupId)  $default,) {final _that = this;
switch (_that) {
case _ProductModifier():
return $default(_that.productId,_that.modifierGroupId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  int modifierGroupId)?  $default,) {final _that = this;
switch (_that) {
case _ProductModifier() when $default != null:
return $default(_that.productId,_that.modifierGroupId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductModifier implements ProductModifier {
  const _ProductModifier({required this.productId, required this.modifierGroupId});
  factory _ProductModifier.fromJson(Map<String, dynamic> json) => _$ProductModifierFromJson(json);

@override final  int productId;
@override final  int modifierGroupId;

/// Create a copy of ProductModifier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModifierCopyWith<_ProductModifier> get copyWith => __$ProductModifierCopyWithImpl<_ProductModifier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductModifierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModifier&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.modifierGroupId, modifierGroupId) || other.modifierGroupId == modifierGroupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,modifierGroupId);

@override
String toString() {
  return 'ProductModifier(productId: $productId, modifierGroupId: $modifierGroupId)';
}


}

/// @nodoc
abstract mixin class _$ProductModifierCopyWith<$Res> implements $ProductModifierCopyWith<$Res> {
  factory _$ProductModifierCopyWith(_ProductModifier value, $Res Function(_ProductModifier) _then) = __$ProductModifierCopyWithImpl;
@override @useResult
$Res call({
 int productId, int modifierGroupId
});




}
/// @nodoc
class __$ProductModifierCopyWithImpl<$Res>
    implements _$ProductModifierCopyWith<$Res> {
  __$ProductModifierCopyWithImpl(this._self, this._then);

  final _ProductModifier _self;
  final $Res Function(_ProductModifier) _then;

/// Create a copy of ProductModifier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? modifierGroupId = null,}) {
  return _then(_ProductModifier(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,modifierGroupId: null == modifierGroupId ? _self.modifierGroupId : modifierGroupId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

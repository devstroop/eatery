// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Company {

 int? get id; String? get logo; String get name; String get email; String get phone; String get address; Taxation get taxation; String? get currencyCode;@JsonKey(name: 'foodLicNo') String? get foodLicenseNo;@JsonKey(name: 'taxLicNo') String? get salesTaxNumber; int? get subscriptionId; int? get adminStaffId;
/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyCopyWith<Company> get copyWith => _$CompanyCopyWithImpl<Company>(this as Company, _$identity);

  /// Serializes this Company to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Company&&(identical(other.id, id) || other.id == id)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.taxation, taxation) || other.taxation == taxation)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.foodLicenseNo, foodLicenseNo) || other.foodLicenseNo == foodLicenseNo)&&(identical(other.salesTaxNumber, salesTaxNumber) || other.salesTaxNumber == salesTaxNumber)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.adminStaffId, adminStaffId) || other.adminStaffId == adminStaffId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,logo,name,email,phone,address,taxation,currencyCode,foodLicenseNo,salesTaxNumber,subscriptionId,adminStaffId);

@override
String toString() {
  return 'Company(id: $id, logo: $logo, name: $name, email: $email, phone: $phone, address: $address, taxation: $taxation, currencyCode: $currencyCode, foodLicenseNo: $foodLicenseNo, salesTaxNumber: $salesTaxNumber, subscriptionId: $subscriptionId, adminStaffId: $adminStaffId)';
}


}

/// @nodoc
abstract mixin class $CompanyCopyWith<$Res>  {
  factory $CompanyCopyWith(Company value, $Res Function(Company) _then) = _$CompanyCopyWithImpl;
@useResult
$Res call({
 int? id, String? logo, String name, String email, String phone, String address, Taxation taxation, String? currencyCode,@JsonKey(name: 'foodLicNo') String? foodLicenseNo,@JsonKey(name: 'taxLicNo') String? salesTaxNumber, int? subscriptionId, int? adminStaffId
});




}
/// @nodoc
class _$CompanyCopyWithImpl<$Res>
    implements $CompanyCopyWith<$Res> {
  _$CompanyCopyWithImpl(this._self, this._then);

  final Company _self;
  final $Res Function(Company) _then;

/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? logo = freezed,Object? name = null,Object? email = null,Object? phone = null,Object? address = null,Object? taxation = null,Object? currencyCode = freezed,Object? foodLicenseNo = freezed,Object? salesTaxNumber = freezed,Object? subscriptionId = freezed,Object? adminStaffId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,taxation: null == taxation ? _self.taxation : taxation // ignore: cast_nullable_to_non_nullable
as Taxation,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,foodLicenseNo: freezed == foodLicenseNo ? _self.foodLicenseNo : foodLicenseNo // ignore: cast_nullable_to_non_nullable
as String?,salesTaxNumber: freezed == salesTaxNumber ? _self.salesTaxNumber : salesTaxNumber // ignore: cast_nullable_to_non_nullable
as String?,subscriptionId: freezed == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as int?,adminStaffId: freezed == adminStaffId ? _self.adminStaffId : adminStaffId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Company].
extension CompanyPatterns on Company {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Company value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Company() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Company value)  $default,){
final _that = this;
switch (_that) {
case _Company():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Company value)?  $default,){
final _that = this;
switch (_that) {
case _Company() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? logo,  String name,  String email,  String phone,  String address,  Taxation taxation,  String? currencyCode, @JsonKey(name: 'foodLicNo')  String? foodLicenseNo, @JsonKey(name: 'taxLicNo')  String? salesTaxNumber,  int? subscriptionId,  int? adminStaffId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Company() when $default != null:
return $default(_that.id,_that.logo,_that.name,_that.email,_that.phone,_that.address,_that.taxation,_that.currencyCode,_that.foodLicenseNo,_that.salesTaxNumber,_that.subscriptionId,_that.adminStaffId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? logo,  String name,  String email,  String phone,  String address,  Taxation taxation,  String? currencyCode, @JsonKey(name: 'foodLicNo')  String? foodLicenseNo, @JsonKey(name: 'taxLicNo')  String? salesTaxNumber,  int? subscriptionId,  int? adminStaffId)  $default,) {final _that = this;
switch (_that) {
case _Company():
return $default(_that.id,_that.logo,_that.name,_that.email,_that.phone,_that.address,_that.taxation,_that.currencyCode,_that.foodLicenseNo,_that.salesTaxNumber,_that.subscriptionId,_that.adminStaffId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? logo,  String name,  String email,  String phone,  String address,  Taxation taxation,  String? currencyCode, @JsonKey(name: 'foodLicNo')  String? foodLicenseNo, @JsonKey(name: 'taxLicNo')  String? salesTaxNumber,  int? subscriptionId,  int? adminStaffId)?  $default,) {final _that = this;
switch (_that) {
case _Company() when $default != null:
return $default(_that.id,_that.logo,_that.name,_that.email,_that.phone,_that.address,_that.taxation,_that.currencyCode,_that.foodLicenseNo,_that.salesTaxNumber,_that.subscriptionId,_that.adminStaffId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Company implements Company {
  const _Company({this.id = 1, this.logo, required this.name, required this.email, required this.phone, required this.address, required this.taxation, this.currencyCode, @JsonKey(name: 'foodLicNo') this.foodLicenseNo, @JsonKey(name: 'taxLicNo') this.salesTaxNumber, this.subscriptionId, this.adminStaffId});
  factory _Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

@override@JsonKey() final  int? id;
@override final  String? logo;
@override final  String name;
@override final  String email;
@override final  String phone;
@override final  String address;
@override final  Taxation taxation;
@override final  String? currencyCode;
@override@JsonKey(name: 'foodLicNo') final  String? foodLicenseNo;
@override@JsonKey(name: 'taxLicNo') final  String? salesTaxNumber;
@override final  int? subscriptionId;
@override final  int? adminStaffId;

/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyCopyWith<_Company> get copyWith => __$CompanyCopyWithImpl<_Company>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Company&&(identical(other.id, id) || other.id == id)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.taxation, taxation) || other.taxation == taxation)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.foodLicenseNo, foodLicenseNo) || other.foodLicenseNo == foodLicenseNo)&&(identical(other.salesTaxNumber, salesTaxNumber) || other.salesTaxNumber == salesTaxNumber)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.adminStaffId, adminStaffId) || other.adminStaffId == adminStaffId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,logo,name,email,phone,address,taxation,currencyCode,foodLicenseNo,salesTaxNumber,subscriptionId,adminStaffId);

@override
String toString() {
  return 'Company(id: $id, logo: $logo, name: $name, email: $email, phone: $phone, address: $address, taxation: $taxation, currencyCode: $currencyCode, foodLicenseNo: $foodLicenseNo, salesTaxNumber: $salesTaxNumber, subscriptionId: $subscriptionId, adminStaffId: $adminStaffId)';
}


}

/// @nodoc
abstract mixin class _$CompanyCopyWith<$Res> implements $CompanyCopyWith<$Res> {
  factory _$CompanyCopyWith(_Company value, $Res Function(_Company) _then) = __$CompanyCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? logo, String name, String email, String phone, String address, Taxation taxation, String? currencyCode,@JsonKey(name: 'foodLicNo') String? foodLicenseNo,@JsonKey(name: 'taxLicNo') String? salesTaxNumber, int? subscriptionId, int? adminStaffId
});




}
/// @nodoc
class __$CompanyCopyWithImpl<$Res>
    implements _$CompanyCopyWith<$Res> {
  __$CompanyCopyWithImpl(this._self, this._then);

  final _Company _self;
  final $Res Function(_Company) _then;

/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? logo = freezed,Object? name = null,Object? email = null,Object? phone = null,Object? address = null,Object? taxation = null,Object? currencyCode = freezed,Object? foodLicenseNo = freezed,Object? salesTaxNumber = freezed,Object? subscriptionId = freezed,Object? adminStaffId = freezed,}) {
  return _then(_Company(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,taxation: null == taxation ? _self.taxation : taxation // ignore: cast_nullable_to_non_nullable
as Taxation,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,foodLicenseNo: freezed == foodLicenseNo ? _self.foodLicenseNo : foodLicenseNo // ignore: cast_nullable_to_non_nullable
as String?,salesTaxNumber: freezed == salesTaxNumber ? _self.salesTaxNumber : salesTaxNumber // ignore: cast_nullable_to_non_nullable
as String?,subscriptionId: freezed == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as int?,adminStaffId: freezed == adminStaffId ? _self.adminStaffId : adminStaffId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

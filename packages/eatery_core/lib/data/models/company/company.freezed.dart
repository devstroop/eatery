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

 int? get id; String? get logo; String get name; String get email; String get phone; String get address; Taxation get taxation; String? get currencyCode;@JsonKey(name: 'foodLicNo') String? get foodLicenseNo;@JsonKey(name: 'taxLicNo') String? get salesTaxNumber; int? get subscriptionId; int? get adminEmployeeId; String? get country;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get createdAt;@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? get updatedAt; String? get addressLine1; String? get addressLine2; String? get city; String? get state; String? get pincode; String? get invoicePrefix; int? get nextInvoiceNo; String? get invoiceTerms; String? get invoiceFooter; String? get legalName; String? get displayName; String? get businessType; String? get pan; String? get website; String? get timezone; String? get defaultLanguage; int? get defaultOrderType;
/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyCopyWith<Company> get copyWith => _$CompanyCopyWithImpl<Company>(this as Company, _$identity);

  /// Serializes this Company to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Company&&(identical(other.id, id) || other.id == id)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.taxation, taxation) || other.taxation == taxation)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.foodLicenseNo, foodLicenseNo) || other.foodLicenseNo == foodLicenseNo)&&(identical(other.salesTaxNumber, salesTaxNumber) || other.salesTaxNumber == salesTaxNumber)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.adminEmployeeId, adminEmployeeId) || other.adminEmployeeId == adminEmployeeId)&&(identical(other.country, country) || other.country == country)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.invoicePrefix, invoicePrefix) || other.invoicePrefix == invoicePrefix)&&(identical(other.nextInvoiceNo, nextInvoiceNo) || other.nextInvoiceNo == nextInvoiceNo)&&(identical(other.invoiceTerms, invoiceTerms) || other.invoiceTerms == invoiceTerms)&&(identical(other.invoiceFooter, invoiceFooter) || other.invoiceFooter == invoiceFooter)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.businessType, businessType) || other.businessType == businessType)&&(identical(other.pan, pan) || other.pan == pan)&&(identical(other.website, website) || other.website == website)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.defaultLanguage, defaultLanguage) || other.defaultLanguage == defaultLanguage)&&(identical(other.defaultOrderType, defaultOrderType) || other.defaultOrderType == defaultOrderType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,logo,name,email,phone,address,taxation,currencyCode,foodLicenseNo,salesTaxNumber,subscriptionId,adminEmployeeId,country,createdAt,updatedAt,addressLine1,addressLine2,city,state,pincode,invoicePrefix,nextInvoiceNo,invoiceTerms,invoiceFooter,legalName,displayName,businessType,pan,website,timezone,defaultLanguage,defaultOrderType]);

@override
String toString() {
  return 'Company(id: $id, logo: $logo, name: $name, email: $email, phone: $phone, address: $address, taxation: $taxation, currencyCode: $currencyCode, foodLicenseNo: $foodLicenseNo, salesTaxNumber: $salesTaxNumber, subscriptionId: $subscriptionId, adminEmployeeId: $adminEmployeeId, country: $country, createdAt: $createdAt, updatedAt: $updatedAt, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, pincode: $pincode, invoicePrefix: $invoicePrefix, nextInvoiceNo: $nextInvoiceNo, invoiceTerms: $invoiceTerms, invoiceFooter: $invoiceFooter, legalName: $legalName, displayName: $displayName, businessType: $businessType, pan: $pan, website: $website, timezone: $timezone, defaultLanguage: $defaultLanguage, defaultOrderType: $defaultOrderType)';
}


}

/// @nodoc
abstract mixin class $CompanyCopyWith<$Res>  {
  factory $CompanyCopyWith(Company value, $Res Function(Company) _then) = _$CompanyCopyWithImpl;
@useResult
$Res call({
 int? id, String? logo, String name, String email, String phone, String address, Taxation taxation, String? currencyCode,@JsonKey(name: 'foodLicNo') String? foodLicenseNo,@JsonKey(name: 'taxLicNo') String? salesTaxNumber, int? subscriptionId, int? adminEmployeeId, String? country,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt, String? addressLine1, String? addressLine2, String? city, String? state, String? pincode, String? invoicePrefix, int? nextInvoiceNo, String? invoiceTerms, String? invoiceFooter, String? legalName, String? displayName, String? businessType, String? pan, String? website, String? timezone, String? defaultLanguage, int? defaultOrderType
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? logo = freezed,Object? name = null,Object? email = null,Object? phone = null,Object? address = null,Object? taxation = null,Object? currencyCode = freezed,Object? foodLicenseNo = freezed,Object? salesTaxNumber = freezed,Object? subscriptionId = freezed,Object? adminEmployeeId = freezed,Object? country = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? addressLine1 = freezed,Object? addressLine2 = freezed,Object? city = freezed,Object? state = freezed,Object? pincode = freezed,Object? invoicePrefix = freezed,Object? nextInvoiceNo = freezed,Object? invoiceTerms = freezed,Object? invoiceFooter = freezed,Object? legalName = freezed,Object? displayName = freezed,Object? businessType = freezed,Object? pan = freezed,Object? website = freezed,Object? timezone = freezed,Object? defaultLanguage = freezed,Object? defaultOrderType = freezed,}) {
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
as int?,adminEmployeeId: freezed == adminEmployeeId ? _self.adminEmployeeId : adminEmployeeId // ignore: cast_nullable_to_non_nullable
as int?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,pincode: freezed == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String?,invoicePrefix: freezed == invoicePrefix ? _self.invoicePrefix : invoicePrefix // ignore: cast_nullable_to_non_nullable
as String?,nextInvoiceNo: freezed == nextInvoiceNo ? _self.nextInvoiceNo : nextInvoiceNo // ignore: cast_nullable_to_non_nullable
as int?,invoiceTerms: freezed == invoiceTerms ? _self.invoiceTerms : invoiceTerms // ignore: cast_nullable_to_non_nullable
as String?,invoiceFooter: freezed == invoiceFooter ? _self.invoiceFooter : invoiceFooter // ignore: cast_nullable_to_non_nullable
as String?,legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,businessType: freezed == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as String?,pan: freezed == pan ? _self.pan : pan // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,defaultLanguage: freezed == defaultLanguage ? _self.defaultLanguage : defaultLanguage // ignore: cast_nullable_to_non_nullable
as String?,defaultOrderType: freezed == defaultOrderType ? _self.defaultOrderType : defaultOrderType // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? logo,  String name,  String email,  String phone,  String address,  Taxation taxation,  String? currencyCode, @JsonKey(name: 'foodLicNo')  String? foodLicenseNo, @JsonKey(name: 'taxLicNo')  String? salesTaxNumber,  int? subscriptionId,  int? adminEmployeeId,  String? country, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt,  String? addressLine1,  String? addressLine2,  String? city,  String? state,  String? pincode,  String? invoicePrefix,  int? nextInvoiceNo,  String? invoiceTerms,  String? invoiceFooter,  String? legalName,  String? displayName,  String? businessType,  String? pan,  String? website,  String? timezone,  String? defaultLanguage,  int? defaultOrderType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Company() when $default != null:
return $default(_that.id,_that.logo,_that.name,_that.email,_that.phone,_that.address,_that.taxation,_that.currencyCode,_that.foodLicenseNo,_that.salesTaxNumber,_that.subscriptionId,_that.adminEmployeeId,_that.country,_that.createdAt,_that.updatedAt,_that.addressLine1,_that.addressLine2,_that.city,_that.state,_that.pincode,_that.invoicePrefix,_that.nextInvoiceNo,_that.invoiceTerms,_that.invoiceFooter,_that.legalName,_that.displayName,_that.businessType,_that.pan,_that.website,_that.timezone,_that.defaultLanguage,_that.defaultOrderType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? logo,  String name,  String email,  String phone,  String address,  Taxation taxation,  String? currencyCode, @JsonKey(name: 'foodLicNo')  String? foodLicenseNo, @JsonKey(name: 'taxLicNo')  String? salesTaxNumber,  int? subscriptionId,  int? adminEmployeeId,  String? country, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt,  String? addressLine1,  String? addressLine2,  String? city,  String? state,  String? pincode,  String? invoicePrefix,  int? nextInvoiceNo,  String? invoiceTerms,  String? invoiceFooter,  String? legalName,  String? displayName,  String? businessType,  String? pan,  String? website,  String? timezone,  String? defaultLanguage,  int? defaultOrderType)  $default,) {final _that = this;
switch (_that) {
case _Company():
return $default(_that.id,_that.logo,_that.name,_that.email,_that.phone,_that.address,_that.taxation,_that.currencyCode,_that.foodLicenseNo,_that.salesTaxNumber,_that.subscriptionId,_that.adminEmployeeId,_that.country,_that.createdAt,_that.updatedAt,_that.addressLine1,_that.addressLine2,_that.city,_that.state,_that.pincode,_that.invoicePrefix,_that.nextInvoiceNo,_that.invoiceTerms,_that.invoiceFooter,_that.legalName,_that.displayName,_that.businessType,_that.pan,_that.website,_that.timezone,_that.defaultLanguage,_that.defaultOrderType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? logo,  String name,  String email,  String phone,  String address,  Taxation taxation,  String? currencyCode, @JsonKey(name: 'foodLicNo')  String? foodLicenseNo, @JsonKey(name: 'taxLicNo')  String? salesTaxNumber,  int? subscriptionId,  int? adminEmployeeId,  String? country, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)  DateTime? updatedAt,  String? addressLine1,  String? addressLine2,  String? city,  String? state,  String? pincode,  String? invoicePrefix,  int? nextInvoiceNo,  String? invoiceTerms,  String? invoiceFooter,  String? legalName,  String? displayName,  String? businessType,  String? pan,  String? website,  String? timezone,  String? defaultLanguage,  int? defaultOrderType)?  $default,) {final _that = this;
switch (_that) {
case _Company() when $default != null:
return $default(_that.id,_that.logo,_that.name,_that.email,_that.phone,_that.address,_that.taxation,_that.currencyCode,_that.foodLicenseNo,_that.salesTaxNumber,_that.subscriptionId,_that.adminEmployeeId,_that.country,_that.createdAt,_that.updatedAt,_that.addressLine1,_that.addressLine2,_that.city,_that.state,_that.pincode,_that.invoicePrefix,_that.nextInvoiceNo,_that.invoiceTerms,_that.invoiceFooter,_that.legalName,_that.displayName,_that.businessType,_that.pan,_that.website,_that.timezone,_that.defaultLanguage,_that.defaultOrderType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Company implements Company {
  const _Company({this.id = 1, this.logo, required this.name, required this.email, required this.phone, required this.address, required this.taxation, this.currencyCode, @JsonKey(name: 'foodLicNo') this.foodLicenseNo, @JsonKey(name: 'taxLicNo') this.salesTaxNumber, this.subscriptionId, this.adminEmployeeId, this.country = 'IN', @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.createdAt, @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) this.updatedAt, this.addressLine1, this.addressLine2, this.city, this.state, this.pincode, this.invoicePrefix, this.nextInvoiceNo = 1, this.invoiceTerms, this.invoiceFooter, this.legalName, this.displayName, this.businessType, this.pan, this.website, this.timezone, this.defaultLanguage = 'en', this.defaultOrderType});
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
@override final  int? adminEmployeeId;
@override@JsonKey() final  String? country;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime createdAt;
@override@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) final  DateTime? updatedAt;
@override final  String? addressLine1;
@override final  String? addressLine2;
@override final  String? city;
@override final  String? state;
@override final  String? pincode;
@override final  String? invoicePrefix;
@override@JsonKey() final  int? nextInvoiceNo;
@override final  String? invoiceTerms;
@override final  String? invoiceFooter;
@override final  String? legalName;
@override final  String? displayName;
@override final  String? businessType;
@override final  String? pan;
@override final  String? website;
@override final  String? timezone;
@override@JsonKey() final  String? defaultLanguage;
@override final  int? defaultOrderType;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Company&&(identical(other.id, id) || other.id == id)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.taxation, taxation) || other.taxation == taxation)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.foodLicenseNo, foodLicenseNo) || other.foodLicenseNo == foodLicenseNo)&&(identical(other.salesTaxNumber, salesTaxNumber) || other.salesTaxNumber == salesTaxNumber)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.adminEmployeeId, adminEmployeeId) || other.adminEmployeeId == adminEmployeeId)&&(identical(other.country, country) || other.country == country)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.invoicePrefix, invoicePrefix) || other.invoicePrefix == invoicePrefix)&&(identical(other.nextInvoiceNo, nextInvoiceNo) || other.nextInvoiceNo == nextInvoiceNo)&&(identical(other.invoiceTerms, invoiceTerms) || other.invoiceTerms == invoiceTerms)&&(identical(other.invoiceFooter, invoiceFooter) || other.invoiceFooter == invoiceFooter)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.businessType, businessType) || other.businessType == businessType)&&(identical(other.pan, pan) || other.pan == pan)&&(identical(other.website, website) || other.website == website)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.defaultLanguage, defaultLanguage) || other.defaultLanguage == defaultLanguage)&&(identical(other.defaultOrderType, defaultOrderType) || other.defaultOrderType == defaultOrderType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,logo,name,email,phone,address,taxation,currencyCode,foodLicenseNo,salesTaxNumber,subscriptionId,adminEmployeeId,country,createdAt,updatedAt,addressLine1,addressLine2,city,state,pincode,invoicePrefix,nextInvoiceNo,invoiceTerms,invoiceFooter,legalName,displayName,businessType,pan,website,timezone,defaultLanguage,defaultOrderType]);

@override
String toString() {
  return 'Company(id: $id, logo: $logo, name: $name, email: $email, phone: $phone, address: $address, taxation: $taxation, currencyCode: $currencyCode, foodLicenseNo: $foodLicenseNo, salesTaxNumber: $salesTaxNumber, subscriptionId: $subscriptionId, adminEmployeeId: $adminEmployeeId, country: $country, createdAt: $createdAt, updatedAt: $updatedAt, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, pincode: $pincode, invoicePrefix: $invoicePrefix, nextInvoiceNo: $nextInvoiceNo, invoiceTerms: $invoiceTerms, invoiceFooter: $invoiceFooter, legalName: $legalName, displayName: $displayName, businessType: $businessType, pan: $pan, website: $website, timezone: $timezone, defaultLanguage: $defaultLanguage, defaultOrderType: $defaultOrderType)';
}


}

/// @nodoc
abstract mixin class _$CompanyCopyWith<$Res> implements $CompanyCopyWith<$Res> {
  factory _$CompanyCopyWith(_Company value, $Res Function(_Company) _then) = __$CompanyCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? logo, String name, String email, String phone, String address, Taxation taxation, String? currencyCode,@JsonKey(name: 'foodLicNo') String? foodLicenseNo,@JsonKey(name: 'taxLicNo') String? salesTaxNumber, int? subscriptionId, int? adminEmployeeId, String? country,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime createdAt,@JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt, String? addressLine1, String? addressLine2, String? city, String? state, String? pincode, String? invoicePrefix, int? nextInvoiceNo, String? invoiceTerms, String? invoiceFooter, String? legalName, String? displayName, String? businessType, String? pan, String? website, String? timezone, String? defaultLanguage, int? defaultOrderType
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? logo = freezed,Object? name = null,Object? email = null,Object? phone = null,Object? address = null,Object? taxation = null,Object? currencyCode = freezed,Object? foodLicenseNo = freezed,Object? salesTaxNumber = freezed,Object? subscriptionId = freezed,Object? adminEmployeeId = freezed,Object? country = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? addressLine1 = freezed,Object? addressLine2 = freezed,Object? city = freezed,Object? state = freezed,Object? pincode = freezed,Object? invoicePrefix = freezed,Object? nextInvoiceNo = freezed,Object? invoiceTerms = freezed,Object? invoiceFooter = freezed,Object? legalName = freezed,Object? displayName = freezed,Object? businessType = freezed,Object? pan = freezed,Object? website = freezed,Object? timezone = freezed,Object? defaultLanguage = freezed,Object? defaultOrderType = freezed,}) {
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
as int?,adminEmployeeId: freezed == adminEmployeeId ? _self.adminEmployeeId : adminEmployeeId // ignore: cast_nullable_to_non_nullable
as int?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,pincode: freezed == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String?,invoicePrefix: freezed == invoicePrefix ? _self.invoicePrefix : invoicePrefix // ignore: cast_nullable_to_non_nullable
as String?,nextInvoiceNo: freezed == nextInvoiceNo ? _self.nextInvoiceNo : nextInvoiceNo // ignore: cast_nullable_to_non_nullable
as int?,invoiceTerms: freezed == invoiceTerms ? _self.invoiceTerms : invoiceTerms // ignore: cast_nullable_to_non_nullable
as String?,invoiceFooter: freezed == invoiceFooter ? _self.invoiceFooter : invoiceFooter // ignore: cast_nullable_to_non_nullable
as String?,legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,businessType: freezed == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as String?,pan: freezed == pan ? _self.pan : pan // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,defaultLanguage: freezed == defaultLanguage ? _self.defaultLanguage : defaultLanguage // ignore: cast_nullable_to_non_nullable
as String?,defaultOrderType: freezed == defaultOrderType ? _self.defaultOrderType : defaultOrderType // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

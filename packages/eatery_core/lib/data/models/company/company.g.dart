// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Company _$CompanyFromJson(Map<String, dynamic> json) => _Company(
  id: (json['id'] as num?)?.toInt() ?? 1,
  logo: json['logo'] as String?,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  address: json['address'] as String,
  taxation: $enumDecode(_$TaxationEnumMap, json['taxation']),
  currencyCode: json['currencyCode'] as String?,
  foodLicenseNo: json['foodLicNo'] as String?,
  salesTaxNumber: json['taxLicNo'] as String?,
  subscriptionId: (json['subscriptionId'] as num?)?.toInt(),
  adminEmployeeId: (json['adminEmployeeId'] as num?)?.toInt(),
  createdAt: epochFromJson((json['createdAt'] as num).toInt()),
  updatedAt: epochFromJsonNullable((json['updatedAt'] as num?)?.toInt()),
);

Map<String, dynamic> _$CompanyToJson(_Company instance) => <String, dynamic>{
  'id': instance.id,
  'logo': instance.logo,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'address': instance.address,
  'taxation': _$TaxationEnumMap[instance.taxation]!,
  'currencyCode': instance.currencyCode,
  'foodLicNo': instance.foodLicenseNo,
  'taxLicNo': instance.salesTaxNumber,
  'subscriptionId': instance.subscriptionId,
  'adminEmployeeId': instance.adminEmployeeId,
  'createdAt': epochToJson(instance.createdAt),
  'updatedAt': epochToJsonNullable(instance.updatedAt),
};

const _$TaxationEnumMap = {Taxation.none: -1, Taxation.gst: 0, Taxation.vat: 1};

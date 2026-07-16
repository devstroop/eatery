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
  country: json['country'] as String? ?? 'IN',
  createdAt: epochFromJson((json['createdAt'] as num).toInt()),
  updatedAt: epochFromJsonNullable((json['updatedAt'] as num?)?.toInt()),
  addressLine1: json['addressLine1'] as String?,
  addressLine2: json['addressLine2'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  pincode: json['pincode'] as String?,
  invoicePrefix: json['invoicePrefix'] as String?,
  nextInvoiceNo: (json['nextInvoiceNo'] as num?)?.toInt() ?? 1,
  invoiceTerms: json['invoiceTerms'] as String?,
  invoiceFooter: json['invoiceFooter'] as String?,
  legalName: json['legalName'] as String?,
  displayName: json['displayName'] as String?,
  businessType: json['businessType'] as String?,
  pan: json['pan'] as String?,
  website: json['website'] as String?,
  timezone: json['timezone'] as String?,
  defaultLanguage: json['defaultLanguage'] as String? ?? 'en',
  defaultOrderType: (json['defaultOrderType'] as num?)?.toInt(),
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
  'country': instance.country,
  'createdAt': epochToJson(instance.createdAt),
  'updatedAt': epochToJsonNullable(instance.updatedAt),
  'addressLine1': instance.addressLine1,
  'addressLine2': instance.addressLine2,
  'city': instance.city,
  'state': instance.state,
  'pincode': instance.pincode,
  'invoicePrefix': instance.invoicePrefix,
  'nextInvoiceNo': instance.nextInvoiceNo,
  'invoiceTerms': instance.invoiceTerms,
  'invoiceFooter': instance.invoiceFooter,
  'legalName': instance.legalName,
  'displayName': instance.displayName,
  'businessType': instance.businessType,
  'pan': instance.pan,
  'website': instance.website,
  'timezone': instance.timezone,
  'defaultLanguage': instance.defaultLanguage,
  'defaultOrderType': instance.defaultOrderType,
};

const _$TaxationEnumMap = {Taxation.none: -1, Taxation.gst: 0, Taxation.vat: 1};

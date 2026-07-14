// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Supplier _$SupplierFromJson(Map<String, dynamic> json) => _Supplier(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  contactName: json['contactName'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  address: json['address'] as String?,
  gstin: json['gstin'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: epochFromJson((json['createdAt'] as num).toInt()),
  updatedAt: epochFromJsonNullable((json['updatedAt'] as num?)?.toInt()),
);

Map<String, dynamic> _$SupplierToJson(_Supplier instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'contactName': instance.contactName,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'gstin': instance.gstin,
  'isActive': instance.isActive,
  'createdAt': epochToJson(instance.createdAt),
  'updatedAt': epochToJsonNullable(instance.updatedAt),
};

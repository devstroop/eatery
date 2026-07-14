// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  categoryId: (json['categoryId'] as num?)?.toInt(),
  description: json['description'] as String?,
  image: json['image'] as String?,
  mrpPrice: (json['mrpPrice'] as num).toDouble(),
  salePrice: (json['salePrice'] as num?)?.toDouble(),
  taxSlabId: (json['taxSlabId'] as num?)?.toInt(),
  foodType: $enumDecodeNullable(_$FoodTypeEnumMap, json['foodType']),
  type: $enumDecode(_$ProductTypeEnumMap, json['type']),
  isActive: json['isActive'] as bool,
  stationId: (json['stationId'] as num?)?.toInt(),
  stationName: json['stationName'] as String?,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'categoryId': instance.categoryId,
  'description': instance.description,
  'image': instance.image,
  'mrpPrice': instance.mrpPrice,
  'salePrice': instance.salePrice,
  'taxSlabId': instance.taxSlabId,
  'foodType': _$FoodTypeEnumMap[instance.foodType],
  'type': _$ProductTypeEnumMap[instance.type]!,
  'isActive': instance.isActive,
  'stationId': instance.stationId,
  'stationName': instance.stationName,
};

const _$FoodTypeEnumMap = {FoodType.veg: 0, FoodType.nonVeg: 1};

const _$ProductTypeEnumMap = {
  ProductType.kitchenDish: 0,
  ProductType.inventoryItem: 1,
};

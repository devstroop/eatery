import 'base_dto.dart';

class ProductDto extends BaseDto<ProductDto> {
  @override
  int get schemaVersion => 1;

  final String? id;
  final String name;
  final String? categoryId;
  final String? categoryName;
  final String? description;
  final String? image;
  final double mrpPrice;
  final double? salePrice;
  final String? taxSlabId;
  final String? foodType;
  final String productType;
  final bool isActive;
  final String? stationId;
  final String? stationName;

  ProductDto({
    this.id,
    required this.name,
    this.categoryId,
    this.categoryName,
    this.description,
    this.image,
    required this.mrpPrice,
    this.salePrice,
    this.taxSlabId,
    this.foodType,
    required this.productType,
    required this.isActive,
    this.stationId,
    this.stationName,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String?,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      mrpPrice: (json['mrpPrice'] as num).toDouble(),
      salePrice: json['salePrice'] != null
          ? (json['salePrice'] as num).toDouble()
          : null,
      taxSlabId: json['taxSlabId'] as String?,
      foodType: json['foodType'] as String?,
      productType: json['productType'] as String,
      isActive: json['isActive'] as bool,
      stationId: json['stationId'] as String?,
      stationName: json['stationName'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'description': description,
      'image': image,
      'mrpPrice': mrpPrice,
      'salePrice': salePrice,
      'taxSlabId': taxSlabId,
      'foodType': foodType,
      'productType': productType,
      'isActive': isActive,
      'stationId': stationId,
      'stationName': stationName,
    };
  }
}

class ProductCategoryDto extends BaseDto<ProductCategoryDto> {
  @override
  int get schemaVersion => 1;

  final String? id;
  final String name;
  final String? description;
  final String? image;
  final bool isActive;
  final int sortOrder;

  ProductCategoryDto({
    this.id,
    required this.name,
    this.description,
    this.image,
    required this.isActive,
    this.sortOrder = 0,
  });

  factory ProductCategoryDto.fromJson(Map<String, dynamic> json) {
    return ProductCategoryDto(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      isActive: json['isActive'] as bool,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }
}

import 'base_dto.dart';

class DiningTableDto extends BaseDto<DiningTableDto> {
  @override
  int get schemaVersion => 1;

  final String? id;
  final String name;
  final int capacity;
  final String? categoryId;
  final String? categoryName;
  final String status;
  final int? orderId;
  final String? customerPhone;
  final String? qrCode;

  DiningTableDto({
    this.id,
    required this.name,
    required this.capacity,
    this.categoryId,
    this.categoryName,
    this.status = 'available',
    this.orderId,
    this.customerPhone,
    this.qrCode,
  });

  factory DiningTableDto.fromJson(Map<String, dynamic> json) {
    return DiningTableDto(
      id: json['id'] as String?,
      name: json['name'] as String,
      capacity: json['capacity'] as int,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      status: json['status'] as String? ?? 'available',
      orderId: json['orderId'] as int?,
      customerPhone: json['customerPhone'] as String?,
      qrCode: json['qrCode'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'id': id,
      'name': name,
      'capacity': capacity,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'status': status,
      'orderId': orderId,
      'customerPhone': customerPhone,
      'qrCode': qrCode,
    };
  }
}

import 'base_dto.dart';

class CustomerDto extends BaseDto<CustomerDto> {
  @override
  int get schemaVersion => 1;

  final String? id;
  final String phone;
  final String? name;
  final String? email;
  final String? address;
  final double? totalSpent;
  final int? visitCount;
  final DateTime? lastVisit;

  CustomerDto({
    this.id,
    required this.phone,
    this.name,
    this.email,
    this.address,
    this.totalSpent,
    this.visitCount,
    this.lastVisit,
  });

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      id: json['id'] as String?,
      phone: json['phone'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      totalSpent: json['totalSpent'] != null
          ? (json['totalSpent'] as num).toDouble()
          : null,
      visitCount: json['visitCount'] as int?,
      lastVisit: json['lastVisit'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastVisit'] as int)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'id': id,
      'phone': phone,
      'name': name,
      'email': email,
      'address': address,
      'totalSpent': totalSpent,
      'visitCount': visitCount,
      'lastVisit': lastVisit?.millisecondsSinceEpoch,
    };
  }
}

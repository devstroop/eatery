import 'base_dto.dart';

class CompanyDto extends BaseDto<CompanyDto> {
  @override
  int get schemaVersion => 1;

  final String? id;
  final String? logo;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String taxation;
  final String? currencyCode;
  final String? currencySymbol;
  final String? salesTaxNumber;
  final String? foodLicenseNo;

  CompanyDto({
    this.id,
    this.logo,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.taxation,
    this.currencyCode,
    this.currencySymbol,
    this.salesTaxNumber,
    this.foodLicenseNo,
  });

  factory CompanyDto.fromJson(Map<String, dynamic> json) {
    return CompanyDto(
      id: json['id'] as String?,
      logo: json['logo'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      taxation: json['taxation'] as String,
      currencyCode: json['currencyCode'] as String?,
      currencySymbol: json['currencySymbol'] as String?,
      salesTaxNumber: json['salesTaxNumber'] as String?,
      foodLicenseNo: json['foodLicenseNo'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'id': id,
      'logo': logo,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'taxation': taxation,
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'salesTaxNumber': salesTaxNumber,
      'foodLicenseNo': foodLicenseNo,
    };
  }
}

class StaffDto extends BaseDto<StaffDto> {
  @override
  int get schemaVersion => 1;

  final String? id;
  final String name;
  final String? phone;
  final String? email;
  final String staffType;
  final bool isActive;

  StaffDto({
    this.id,
    required this.name,
    this.phone,
    this.email,
    required this.staffType,
    required this.isActive,
  });

  factory StaffDto.fromJson(Map<String, dynamic> json) {
    return StaffDto(
      id: json['id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      staffType: json['staffType'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'staffType': staffType,
      'isActive': isActive,
    };
  }
}

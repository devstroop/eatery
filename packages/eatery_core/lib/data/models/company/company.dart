import 'package:eatery_core/data/models/company/taxation.dart';
import 'package:eatery_core/data/models/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
abstract class Company with _$Company {
  const factory Company({
    @Default(1) int? id,
    String? logo,
    required String name,
    required String email,
    required String phone,
    required String address,
    required Taxation taxation,
    String? currencyCode,
    @JsonKey(name: 'foodLicNo') String? foodLicenseNo,
    @JsonKey(name: 'taxLicNo') String? salesTaxNumber,
    int? subscriptionId,
    int? adminEmployeeId,
    @Default('IN') String? country,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? updatedAt,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? invoicePrefix,
    @Default(1) int? nextInvoiceNo,
    String? invoiceTerms,
    String? invoiceFooter,
    String? legalName,
    String? displayName,
    String? businessType,
    String? pan,
    String? website,
    String? timezone,
    @Default('en') String? defaultLanguage,
    int? defaultOrderType,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  static Company fromMap(Map<String, dynamic> map) => Company.fromJson(map);

  static Company fromIterable(Iterable<dynamic> list) {
    return Company.fromMap({
      'id': list.elementAt(0),
      'logo': list.elementAt(1),
      'name': list.elementAt(2),
      'email': list.elementAt(3),
      'phone': list.elementAt(4),
      'address': list.elementAt(5),
      'taxation': Taxation.values.singleWhere(
        (element) => element.id == list.elementAt(6),
      ),
      'currencyCode': list.elementAt(7),
      'foodLicNo': list.elementAt(8),
      'taxLicNo': list.elementAt(9),
      'subscriptionId': list.elementAt(10),
      'adminEmployeeId': list.elementAt(11),
      'createdAt': list.elementAt(12),
      'updatedAt': list.elementAt(13),
      'addressLine1': list.elementAt(14),
      'addressLine2': list.elementAt(15),
      'city': list.elementAt(16),
      'state': list.elementAt(17),
      'pincode': list.elementAt(18),
      'country': list.elementAt(19) ?? 'IN',
      'invoicePrefix': list.elementAt(20),
      'nextInvoiceNo': list.elementAt(21) ?? 1,
      'invoiceTerms': list.elementAt(22),
      'invoiceFooter': list.elementAt(23),
      'legalName': list.elementAt(24),
      'displayName': list.elementAt(25),
      'businessType': list.elementAt(26),
      'pan': list.elementAt(27),
      'website': list.elementAt(28),
      'timezone': list.elementAt(29),
      'defaultLanguage': list.elementAt(30) ?? 'en',
      'defaultOrderType': list.elementAt(31),
    });
  }
}

extension CompanyX on Company {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['logo'],
      map['name'],
      map['email'],
      map['phone'],
      map['address'],
      map['taxation'],
      map['currencyCode'],
      map['foodLicNo'],
      map['taxLicNo'],
      map['subscriptionId'],
      map['adminEmployeeId'],
      map['createdAt'],
      map['updatedAt'],
      map['addressLine1'],
      map['addressLine2'],
      map['city'],
      map['state'],
      map['pincode'],
      map['country'],
      map['invoicePrefix'],
      map['nextInvoiceNo'],
      map['invoiceTerms'],
      map['invoiceFooter'],
      map['legalName'],
      map['displayName'],
      map['businessType'],
      map['pan'],
      map['website'],
      map['timezone'],
      map['defaultLanguage'],
      map['defaultOrderType'],
    ];
  }
}

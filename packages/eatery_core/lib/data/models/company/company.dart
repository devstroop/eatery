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
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? updatedAt,
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
    ];
  }
}

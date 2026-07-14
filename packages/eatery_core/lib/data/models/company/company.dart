import 'package:eatery_core/data/models/company/edition.dart';
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
    String? password,
    required Taxation taxation,
    String? currencyCode,
    @JsonKey(name: 'foodLicNo') String? foodLicenseNo,
    @JsonKey(name: 'taxLicNo') String? salesTaxNumber,
    int? subscriptionId,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  static Company fromMap(Map<String, dynamic> map) => Company.fromJson(map);

  static Company fromIterable(Iterable<dynamic> list) {
    return Company.fromMap({
      'id': list.elementAt(0),
      'logo': list.elementAt(1),
      'name': list.elementAt(2),
      'email': list.elementAt(3),
      'phone': list.elementAt(4),
      'address': list.elementAt(5),
      'password': list.elementAt(6),
      'edition': Taxation.values.singleWhere(
        (element) => element.id == list.elementAt(7),
      ),
      'currencyCode': list.elementAt(8),
      'foodLicNo': list.elementAt(9),
      'taxLicNo': list.elementAt(10),
      'subscriptionId': list.elementAt(11),
    });
  }
}

extension CompanyX on Company {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  Iterable<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['logo'],
      map['name'],
      map['email'],
      map['phone'],
      map['address'],
      map['password'],
      map['edition'],
      map['currencyCode'],
      map['foodLicNo'],
      map['taxLicNo'],
      map['subscriptionId'],
    ];
  }
}

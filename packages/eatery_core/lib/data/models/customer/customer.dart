import 'package:eatery_core/data/models/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
abstract class Customer with _$Customer {
  const factory Customer({
    int? id,
    String? name,
    required String phone,
    String? address,
    String? landmark,
    double? latitude,
    double? longitude,
    @Default(true) bool isActive,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? lastOrderAt,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  static Customer fromMap(Map<String, dynamic> map) {
    return Customer.fromJson({
      'id': map['id'],
      'name': map['name'],
      'phone': map['phone'],
      'address': map['address'],
      'landmark': map['landmark'],
      'latitude': map['latitude'] != null
          ? double.parse(map['latitude'].toString())
          : null,
      'longitude': map['longitude'] != null
          ? double.parse(map['longitude'].toString())
          : null,
      'isActive': map['isActive'] is int
          ? map['isActive'] == 1
          : (map['isActive'] ?? false),
      'lastOrderAt': map['lastOrderAt'],
    });
  }

  static Customer fromIterable(Iterable<dynamic> list) {
    return Customer.fromMap({
      'id': list.elementAt(0),
      'name': list.elementAt(1),
      'phone': list.elementAt(2),
      'address': list.elementAt(3),
      'landmark': list.elementAt(4),
      'latitude': list.elementAt(5),
      'longitude': list.elementAt(6),
      'isActive': list.elementAt(7),
      'lastOrderAt': list.elementAt(8),
    });
  }
}

extension CustomerX on Customer {
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'isActive': isActive ? 1 : 0,
      'lastOrderAt': lastOrderAt?.millisecondsSinceEpoch,
    };
  }

  Iterable<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['name'],
      map['phone'],
      map['address'],
      map['landmark'],
      map['latitude'],
      map['longitude'],
      map['isActive'],
      map['lastOrderAt'],
    ];
  }
}

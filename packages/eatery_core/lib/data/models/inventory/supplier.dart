import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eatery_core/data/models/converters.dart';

part 'supplier.freezed.dart';
part 'supplier.g.dart';

@freezed
abstract class Supplier with _$Supplier {
  const factory Supplier({
    int? id,
    required String name,
    String? contactName,
    String? phone,
    String? email,
    String? address,
    String? gstin,
    @Default(true) bool isActive,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required DateTime createdAt,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);
  static Supplier fromMap(Map<String, dynamic> map) => Supplier.fromJson(map);
}

extension SupplierX on Supplier {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

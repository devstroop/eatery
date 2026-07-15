import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eatery_core/data/models/converters.dart';

part 'modifier.freezed.dart';
part 'modifier.g.dart';

@freezed
abstract class Modifier with _$Modifier {
  const factory Modifier({
    int? id,
    required int modifierGroupId,
    required String name,
    @Default(0.0) double priceAdjust,
    @Default(0) int sortOrder,
    @Default(false) bool isDefault,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? updatedAt,
  }) = _Modifier;

  factory Modifier.fromJson(Map<String, dynamic> json) =>
      _$ModifierFromJson(json);

  static Modifier fromMap(Map<String, dynamic> map) => Modifier.fromJson(map);
}

extension ModifierX on Modifier {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eatery_core/data/models/converters.dart';

part 'modifier_group.freezed.dart';
part 'modifier_group.g.dart';

@freezed
abstract class ModifierGroup with _$ModifierGroup {
  const factory ModifierGroup({
    int? id,
    required String name,
    String? description,
    @Default(0) int minSelect,
    @Default(1) int maxSelect,
    @Default(0) int sortOrder,
    @Default(false) bool isRequired,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? updatedAt,
  }) = _ModifierGroup;

  factory ModifierGroup.fromJson(Map<String, dynamic> json) =>
      _$ModifierGroupFromJson(json);

  static ModifierGroup fromMap(Map<String, dynamic> map) =>
      ModifierGroup.fromJson(map);
}

extension ModifierGroupX on ModifierGroup {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

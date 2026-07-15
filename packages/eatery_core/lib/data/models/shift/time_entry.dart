import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eatery_core/data/models/converters.dart';
part 'time_entry.freezed.dart';
part 'time_entry.g.dart';

@freezed
abstract class TimeEntry with _$TimeEntry {
  const factory TimeEntry({
    int? id,
    required int staffId,
    int? shiftId,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime clockIn,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? clockOut,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? breakStart,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? breakEnd,
    String? note,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime createdAt,
  }) = _TimeEntry;
  factory TimeEntry.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryFromJson(json);
  static TimeEntry fromMap(Map<String, dynamic> map) => TimeEntry.fromJson(map);
}

extension TimeEntryX on TimeEntry {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

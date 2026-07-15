import 'package:freezed_annotation/freezed_annotation.dart';
part 'holiday_hours.freezed.dart';
part 'holiday_hours.g.dart';

@freezed
abstract class HolidayHours with _$HolidayHours {
  const factory HolidayHours({
    int? id,
    required String date,
    String? openTime,
    String? closeTime,
    String? description,
  }) = _HolidayHours;
  factory HolidayHours.fromJson(Map<String, dynamic> json) =>
      _$HolidayHoursFromJson(json);
  static HolidayHours fromMap(Map<String, dynamic> map) =>
      HolidayHours.fromJson(map);
}

extension HolidayHoursX on HolidayHours {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

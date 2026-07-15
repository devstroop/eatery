import 'package:freezed_annotation/freezed_annotation.dart';
part 'business_hours.freezed.dart';
part 'business_hours.g.dart';

@freezed
abstract class BusinessHours with _$BusinessHours {
  const factory BusinessHours({
    int? id,
    required int dayOfWeek,
    required String openTime,
    required String closeTime,
    @Default(false) bool isClosed,
  }) = _BusinessHours;
  factory BusinessHours.fromJson(Map<String, dynamic> json) =>
      _$BusinessHoursFromJson(json);
  static BusinessHours fromMap(Map<String, dynamic> map) =>
      BusinessHours.fromJson(map);
}

extension BusinessHoursX on BusinessHours {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

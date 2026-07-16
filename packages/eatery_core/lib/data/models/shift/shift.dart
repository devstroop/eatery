import 'package:freezed_annotation/freezed_annotation.dart';
part 'shift.freezed.dart';
part 'shift.g.dart';

@freezed
abstract class Shift with _$Shift {
  const factory Shift({
    int? id,
    required String name,
    required String startTime,
    required String endTime,
    @Default(true) bool isActive,
  }) = _Shift;
  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
  static Shift fromMap(Map<String, dynamic> map) => Shift.fromJson(map);
}

extension ShiftX on Shift {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

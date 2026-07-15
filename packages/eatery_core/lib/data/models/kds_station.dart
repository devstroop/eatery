import 'package:freezed_annotation/freezed_annotation.dart';

part 'kds_station.freezed.dart';
part 'kds_station.g.dart';

@freezed
abstract class KdsStation with _$KdsStation {
  const factory KdsStation({
    int? id,
    required String name,
    String? description,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
  }) = _KdsStation;

  factory KdsStation.fromJson(Map<String, dynamic> json) =>
      _$KdsStationFromJson(json);

  static KdsStation fromMap(Map<String, dynamic> map) =>
      KdsStation.fromJson(map);
}

extension KdsStationX on KdsStation {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

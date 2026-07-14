import 'package:freezed_annotation/freezed_annotation.dart'; import 'package:eatery_core/data/models/converters.dart';
part 'reservation.freezed.dart'; part 'reservation.g.dart';
@freezed
abstract class Reservation with _$Reservation {
  const factory Reservation({int? id, required String customerName, String? customerPhone, int? diningTableId,
    required int partySize, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required DateTime dateTime,
    @Default(60) int duration, @Default(0) int status, String? note, int? createdBy,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required DateTime createdAt,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable) DateTime? updatedAt}) = _Reservation;
  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);
  static Reservation fromMap(Map<String, dynamic> map) => Reservation.fromJson(map);
}
extension ReservationX on Reservation { Map<String, Object?> toMap() => toJson() as Map<String, Object?>; }

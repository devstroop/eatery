import 'package:eatery_core/data/models/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'void_log_entry.freezed.dart';
part 'void_log_entry.g.dart';

@freezed
abstract class VoidLogEntry with _$VoidLogEntry {
  const factory VoidLogEntry({
    int? id,
    required int orderId,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime voidedAt,
    required String voidedBy,
    required String reasonCode,
    String? reasonDescription,
    required double amount,
    String? orderReference,
  }) = _VoidLogEntry;

  factory VoidLogEntry.fromJson(Map<String, dynamic> json) =>
      _$VoidLogEntryFromJson(json);

  static VoidLogEntry fromMap(Map<String, dynamic> map) =>
      VoidLogEntry.fromJson(map);
}

extension VoidLogEntryX on VoidLogEntry {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

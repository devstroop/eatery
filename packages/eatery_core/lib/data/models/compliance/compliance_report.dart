import 'package:eatery_core/data/models/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'compliance_report.freezed.dart';
part 'compliance_report.g.dart';

@freezed
abstract class ComplianceReport with _$ComplianceReport {
  const factory ComplianceReport({
    int? id,
    required String reportType,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime generatedAt,
    required String generatedBy,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime periodStart,
    @JsonKey(fromJson: epochFromJson, toJson: epochToJson)
    required DateTime periodEnd,
    required String reportNumber,
    required double grossSales,
    required double netSales,
    required double taxCollected,
    required int transactionCount,
    required double averageTicket,
    @Default(0) double totalDiscounts,
    @Default(0) int discountCount,
    @Default(0) int voidCount,
    @Default(0) double voidAmount,
    @Default(0) int refundCount,
    @Default(0) double refundAmount,
    required double openingBalance,
    required double closingBalance,
    double? expectedCash,
    double? actualCash,
    double? cashVariance,
    String? paymentBreakdownJson,
    String? taxBreakdownJson,
  }) = _ComplianceReport;

  factory ComplianceReport.fromJson(Map<String, dynamic> json) =>
      _$ComplianceReportFromJson(json);

  static ComplianceReport fromMap(Map<String, dynamic> map) =>
      ComplianceReport.fromJson(map);
}

extension ComplianceReportX on ComplianceReport {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;
}

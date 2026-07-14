// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ComplianceReport _$ComplianceReportFromJson(Map<String, dynamic> json) =>
    _ComplianceReport(
      id: (json['id'] as num?)?.toInt(),
      reportType: json['reportType'] as String,
      generatedAt: epochFromJson((json['generatedAt'] as num).toInt()),
      generatedBy: json['generatedBy'] as String,
      periodStart: epochFromJson((json['periodStart'] as num).toInt()),
      periodEnd: epochFromJson((json['periodEnd'] as num).toInt()),
      reportNumber: json['reportNumber'] as String,
      grossSales: (json['grossSales'] as num).toDouble(),
      netSales: (json['netSales'] as num).toDouble(),
      taxCollected: (json['taxCollected'] as num).toDouble(),
      transactionCount: (json['transactionCount'] as num).toInt(),
      averageTicket: (json['averageTicket'] as num).toDouble(),
      totalDiscounts: (json['totalDiscounts'] as num?)?.toDouble() ?? 0,
      discountCount: (json['discountCount'] as num?)?.toInt() ?? 0,
      voidCount: (json['voidCount'] as num?)?.toInt() ?? 0,
      voidAmount: (json['voidAmount'] as num?)?.toDouble() ?? 0,
      refundCount: (json['refundCount'] as num?)?.toInt() ?? 0,
      refundAmount: (json['refundAmount'] as num?)?.toDouble() ?? 0,
      openingBalance: (json['openingBalance'] as num).toDouble(),
      closingBalance: (json['closingBalance'] as num).toDouble(),
      expectedCash: (json['expectedCash'] as num?)?.toDouble(),
      actualCash: (json['actualCash'] as num?)?.toDouble(),
      cashVariance: (json['cashVariance'] as num?)?.toDouble(),
      paymentBreakdownJson: json['paymentBreakdownJson'] as String?,
      taxBreakdownJson: json['taxBreakdownJson'] as String?,
    );

Map<String, dynamic> _$ComplianceReportToJson(_ComplianceReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reportType': instance.reportType,
      'generatedAt': epochToJson(instance.generatedAt),
      'generatedBy': instance.generatedBy,
      'periodStart': epochToJson(instance.periodStart),
      'periodEnd': epochToJson(instance.periodEnd),
      'reportNumber': instance.reportNumber,
      'grossSales': instance.grossSales,
      'netSales': instance.netSales,
      'taxCollected': instance.taxCollected,
      'transactionCount': instance.transactionCount,
      'averageTicket': instance.averageTicket,
      'totalDiscounts': instance.totalDiscounts,
      'discountCount': instance.discountCount,
      'voidCount': instance.voidCount,
      'voidAmount': instance.voidAmount,
      'refundCount': instance.refundCount,
      'refundAmount': instance.refundAmount,
      'openingBalance': instance.openingBalance,
      'closingBalance': instance.closingBalance,
      'expectedCash': instance.expectedCash,
      'actualCash': instance.actualCash,
      'cashVariance': instance.cashVariance,
      'paymentBreakdownJson': instance.paymentBreakdownJson,
      'taxBreakdownJson': instance.taxBreakdownJson,
    };

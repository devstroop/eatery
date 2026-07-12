// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_report.dart';

class ComplianceReportAdapter extends TypeAdapter<ComplianceReport> {
  @override
  final int typeId = 27;

  @override
  ComplianceReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComplianceReport(
      reportType: fields[1] as String,
      generatedAt: fields[2] as DateTime,
      generatedBy: fields[3] as String,
      periodStart: fields[4] as DateTime,
      periodEnd: fields[5] as DateTime,
      reportNumber: fields[6] as String,
      grossSales: fields[7] as double,
      netSales: fields[8] as double,
      taxCollected: fields[9] as double,
      transactionCount: fields[10] as int,
      averageTicket: fields[11] as double,
      totalDiscounts: fields[12] as double? ?? 0,
      discountCount: fields[13] as int? ?? 0,
      voidCount: fields[14] as int? ?? 0,
      voidAmount: fields[15] as double? ?? 0,
      refundCount: fields[16] as int? ?? 0,
      refundAmount: fields[17] as double? ?? 0,
      openingBalance: fields[18] as double,
      closingBalance: fields[19] as double,
      expectedCash: fields[20] as double?,
      actualCash: fields[21] as double?,
      cashVariance: fields[22] as double?,
      paymentBreakdownJson: fields[23] as String?,
      taxBreakdownJson: fields[24] as String?,
    )
      ..id = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, ComplianceReport obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.reportType)
      ..writeByte(2)
      ..write(obj.generatedAt)
      ..writeByte(3)
      ..write(obj.generatedBy)
      ..writeByte(4)
      ..write(obj.periodStart)
      ..writeByte(5)
      ..write(obj.periodEnd)
      ..writeByte(6)
      ..write(obj.reportNumber)
      ..writeByte(7)
      ..write(obj.grossSales)
      ..writeByte(8)
      ..write(obj.netSales)
      ..writeByte(9)
      ..write(obj.taxCollected)
      ..writeByte(10)
      ..write(obj.transactionCount)
      ..writeByte(11)
      ..write(obj.averageTicket)
      ..writeByte(12)
      ..write(obj.totalDiscounts)
      ..writeByte(13)
      ..write(obj.discountCount)
      ..writeByte(14)
      ..write(obj.voidCount)
      ..writeByte(15)
      ..write(obj.voidAmount)
      ..writeByte(16)
      ..write(obj.refundCount)
      ..writeByte(17)
      ..write(obj.refundAmount)
      ..writeByte(18)
      ..write(obj.openingBalance)
      ..writeByte(19)
      ..write(obj.closingBalance)
      ..writeByte(20)
      ..write(obj.expectedCash)
      ..writeByte(21)
      ..write(obj.actualCash)
      ..writeByte(22)
      ..write(obj.cashVariance)
      ..writeByte(23)
      ..write(obj.paymentBreakdownJson)
      ..writeByte(24)
      ..write(obj.taxBreakdownJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComplianceReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'void_log_entry.dart';

class VoidLogEntryAdapter extends TypeAdapter<VoidLogEntry> {
  @override
  final int typeId = 26;

  @override
  VoidLogEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoidLogEntry(
      orderId: fields[1] as int,
      voidedAt: fields[2] as DateTime,
      voidedBy: fields[3] as String,
      reasonCode: fields[4] as String,
      reasonDescription: fields[5] as String?,
      amount: fields[6] as double,
      orderReference: fields[7] as String?,
    )
      ..id = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, VoidLogEntry obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.voidedAt)
      ..writeByte(3)
      ..write(obj.voidedBy)
      ..writeByte(4)
      ..write(obj.reasonCode)
      ..writeByte(5)
      ..write(obj.reasonDescription)
      ..writeByte(6)
      ..write(obj.amount)
      ..writeByte(7)
      ..write(obj.orderReference);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoidLogEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

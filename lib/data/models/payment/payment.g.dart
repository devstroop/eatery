// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

class PaymentAdapter extends TypeAdapter<Payment> {
  @override
  final int typeId = 21;

  @override
  Payment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Payment(
      orderId: fields[1] as int?,
      amount: fields[3] as double,
      mode: fields[4] as PaymentMode,
      reference: fields[5] as String?,
      attachment: fields[6] as String?,
      processorTransactionId: fields[7] as String?,
      processorName: fields[8] as String?,
      processorStatus: fields[9] as String?,
      cardLastFour: fields[10] as String?,
      terminalId: fields[11] as String?,
    )
      ..id = fields[0] as int?
      ..date = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Payment obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.mode)
      ..writeByte(5)
      ..write(obj.reference)
      ..writeByte(6)
      ..write(obj.attachment)
      ..writeByte(7)
      ..write(obj.processorTransactionId)
      ..writeByte(8)
      ..write(obj.processorName)
      ..writeByte(9)
      ..write(obj.processorStatus)
      ..writeByte(10)
      ..write(obj.cardLastFour)
      ..writeByte(11)
      ..write(obj.terminalId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

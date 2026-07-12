// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 4;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      customerPhone: fields[1] as String?,
      totalQuantity: fields[4] as int,
      subTotal: fields[5] as double,
      discountTotal: fields[6] as double,
      taxTotal: fields[7] as double,
      finalTotal: fields[8] as double,
      roundOff: fields[9] as double,
      grandTotal: fields[10] as double,
      paidTotal: fields[11] as double?,
      type: fields[12] as OrderType,
      status: fields[13] as String? ?? 'active',
      voidReason: fields[14] as String?,
      voidedBy: fields[15] as String?,
      voidedAt: fields[16] as DateTime?,
    )
      ..id = fields[0] as int?
      ..createdAt = fields[2] as DateTime
      ..updatedAt = fields[3] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerPhone)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.totalQuantity)
      ..writeByte(5)
      ..write(obj.subTotal)
      ..writeByte(6)
      ..write(obj.discountTotal)
      ..writeByte(7)
      ..write(obj.taxTotal)
      ..writeByte(8)
      ..write(obj.finalTotal)
      ..writeByte(9)
      ..write(obj.roundOff)
      ..writeByte(10)
      ..write(obj.grandTotal)
      ..writeByte(11)
      ..write(obj.paidTotal)
      ..writeByte(12)
      ..write(obj.type)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(14)
      ..write(obj.voidReason)
      ..writeByte(15)
      ..write(obj.voidedBy)
      ..writeByte(16)
      ..write(obj.voidedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

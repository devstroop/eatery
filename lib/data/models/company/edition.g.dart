// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaxationAdapter extends TypeAdapter<Taxation> {
  @override
  final int typeId = 18;

  @override
  Taxation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Taxation.none;
      case 1:
        return Taxation.gst;
      case 2:
        return Taxation.vat;
      default:
        return Taxation.none;
    }
  }

  @override
  void write(BinaryWriter writer, Taxation obj) {
    switch (obj) {
      case Taxation.none:
        writer.writeByte(0);
        break;
      case Taxation.gst:
        writer.writeByte(1);
        break;
      case Taxation.vat:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

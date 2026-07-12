// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kds_station.dart';

class KdsStationAdapter extends TypeAdapter<KdsStation> {
  @override
  final int typeId = 25;

  @override
  KdsStation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KdsStation(
      name: fields[1] as String,
      description: fields[2] as String?,
      sortOrder: fields[3] as int? ?? 0,
      isActive: fields[4] as bool? ?? true,
    )
      ..id = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, KdsStation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.sortOrder)
      ..writeByte(4)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KdsStationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

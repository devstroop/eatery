// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Printer _$PrinterFromJson(Map<String, dynamic> json) => _Printer(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  bluetoothAddress: json['bluetoothAddress'] as String?,
  usbVendorId: json['usbVendorId'] as String?,
  usbProductId: json['usbProductId'] as String?,
  type:
      $enumDecodeNullable(_$PrinterTypeEnumMap, json['type']) ??
      PrinterType.bluetooth,
);

Map<String, dynamic> _$PrinterToJson(_Printer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'bluetoothAddress': instance.bluetoothAddress,
  'usbVendorId': instance.usbVendorId,
  'usbProductId': instance.usbProductId,
  'type': _$PrinterTypeEnumMap[instance.type]!,
};

const _$PrinterTypeEnumMap = {PrinterType.bluetooth: 0, PrinterType.usb: 1};

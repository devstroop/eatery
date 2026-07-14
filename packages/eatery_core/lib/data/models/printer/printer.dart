import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'printer.freezed.dart';
part 'printer.g.dart';

@freezed
abstract class Printer with _$Printer {
  const factory Printer({
    int? id,
    required String name,
    String? bluetoothAddress,
    String? usbVendorId,
    String? usbProductId,
    @Default(PrinterType.bluetooth) PrinterType type,
  }) = _Printer;

  factory Printer.fromJson(Map<String, dynamic> json) => _$PrinterFromJson(json);

  static Printer fromMap(Map<String, dynamic> map) => Printer.fromJson(map);
}

extension PrinterX on Printer {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  static Printer fromIterable(Iterable<dynamic> row) {
    return Printer.fromMap({
      'id': row.elementAt(0),
      'name': row.elementAt(1),
      'bluetoothAddress': row.elementAt(2),
      'usbVendorId': row.elementAt(3),
      'usbProductId': row.elementAt(4),
      'type': row.elementAt(5),
    });
  }

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['name'],
      map['bluetoothAddress'],
      map['usbVendorId'],
      map['usbProductId'],
      map['type'],
    ];
  }
}

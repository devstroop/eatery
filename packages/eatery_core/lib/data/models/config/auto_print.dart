import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_print.freezed.dart';
part 'auto_print.g.dart';

@freezed
abstract class AutoPrint with _$AutoPrint {
  const factory AutoPrint({
    int? id,
    bool? invoicePrintEnabled,
    bool? kotPrintEnabled,
    int? invoicePrinterId,
    int? kotPrinterId,
  }) = _AutoPrint;

  factory AutoPrint.fromJson(Map<String, dynamic> json) =>
      _$AutoPrintFromJson(json);

  static AutoPrint fromMap(Map<String, dynamic> map) => AutoPrint.fromJson(map);
}

extension AutoPrintX on AutoPrint {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  static AutoPrint fromIterable(Iterable<dynamic> list) {
    return AutoPrint.fromMap({
      'id': list.elementAt(0),
      'invoicePrint': list.elementAt(1),
      'kotPrint': list.elementAt(2),
      'invoicePrinterId': list.elementAt(3),
      'kotPrinterId': list.elementAt(4),
    });
  }

  Iterable<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['invoicePrint'],
      map['kotPrint'],
      map['invoicePrinterId'],
      map['kotPrinterId'],
    ];
  }
}

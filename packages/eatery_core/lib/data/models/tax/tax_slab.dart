import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tax_slab.freezed.dart';
part 'tax_slab.g.dart';

@freezed
abstract class TaxSlab with _$TaxSlab {
  const factory TaxSlab({
    int? id,
    required String name,
    required double rate,
    @Default(TaxType.inclusive) TaxType type,
  }) = _TaxSlab;

  factory TaxSlab.fromJson(Map<String, dynamic> json) => _$TaxSlabFromJson(json);

  static TaxSlab fromMap(Map<String, dynamic> map) => TaxSlab.fromJson(map);

  static TaxSlab fromIterable(Iterable<dynamic> row) {
    return TaxSlab.fromMap({
      'id': row.elementAt(0),
      'name': row.elementAt(1),
      'rate': row.elementAt(2),
      'type': row.elementAt(3),
    });
  }
}

extension TaxSlabX on TaxSlab {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  List<dynamic> toIterable() {
    var map = toMap();
    return [map['id'], map['name'], map['rate'], map['type']];
  }
}

import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dining_table.freezed.dart';
part 'dining_table.g.dart';

@freezed
abstract class DiningTable with _$DiningTable {
  const factory DiningTable({
    int? id,
    required String name,
    String? description,
    int? orderId,
    int? categoryId,
    @Default(0) int capacity,
    @Default(DiningTableStatus.available) DiningTableStatus status,
    String? customerPhone,
    double? posX,
    double? posY,
    @Default(0) int shape,
    double? width,
    double? height,
    int? staffId,
  }) = _DiningTable;

  factory DiningTable.fromJson(Map<String, dynamic> json) =>
      _$DiningTableFromJson(json);

  static DiningTable fromMap(Map<String, dynamic> map) {
    return DiningTable.fromJson({
      'id': map['id'],
      'name': map['name'],
      'description': map['description'],
      'orderId': map['orderId'],
      'categoryId': map['categoryId'],
      'capacity': map['capacity'] ?? 0,
      'status': map['status'] != null
          ? DiningTableStatus.values.singleWhere(
              (element) => element.id == map['status'],
            )
          : DiningTableStatus.available,
      'customerPhone': map['customerPhone'],
      'posX': map['posX'],
      'posY': map['posY'],
      'shape': map['shape'] ?? 0,
      'width': map['width'],
      'height': map['height'],
      'staffId': map['staffId'],
    });
  }

  static DiningTable fromIterable(Iterable<dynamic> row) {
    return DiningTable.fromMap({
      'id': row.elementAt(0),
      'name': row.elementAt(1),
      'description': row.elementAt(2),
      'orderId': row.elementAt(3),
      'categoryId': row.elementAt(4),
      'capacity': row.elementAt(5),
      'status': row.elementAt(6),
      'customerPhone': row.elementAt(7),
      'posX': row.elementAt(8),
      'posY': row.elementAt(9),
      'shape': row.elementAt(10),
      'width': row.elementAt(11),
      'height': row.elementAt(12),
      'staffId': row.elementAt(13),
    });
  }
}

extension DiningTableX on DiningTable {
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'description': description,
      'orderId': orderId,
      'capacity': capacity,
      'status': status.id,
      'customerPhone': customerPhone,
      'posX': posX,
      'posY': posY,
      'shape': shape,
      'width': width,
      'height': height,
      'staffId': staffId,
    };
  }

  List<dynamic> toIterable() {
    return [
      name, categoryId, description, orderId, capacity, status.id,
      customerPhone, posX, posY, shape, width, height, staffId,
    ];
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dining_table_category.freezed.dart';
part 'dining_table_category.g.dart';

@freezed
abstract class DiningTableCategory with _$DiningTableCategory {
  const factory DiningTableCategory({
    int? id,
    required String name,
    String? description,
    @Default(false) bool isActive,
  }) = _DiningTableCategory;

  factory DiningTableCategory.fromJson(Map<String, dynamic> json) =>
      _$DiningTableCategoryFromJson(json);

  static DiningTableCategory fromMap(Map<String, dynamic> map) {
    if (map['isActive'] is int) {
      map = Map<String, dynamic>.from(map);
      map['isActive'] = (map['isActive'] as int) != 0;
    } else if (map['isActive'] == null) {
      map = Map<String, dynamic>.from(map);
      map['isActive'] = false;
    }
    return DiningTableCategory.fromJson(map);
  }

  static DiningTableCategory fromIterable(Iterable<dynamic> row) {
    return DiningTableCategory.fromMap({
      'id': row.elementAt(0),
      'name': row.elementAt(1),
      'description': row.elementAt(2),
      'isActive': row.elementAt(3),
    });
  }
}

extension DiningTableCategoryX on DiningTableCategory {
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive ? 1 : 0,
    };
  }

  List<dynamic> toIterable() {
    return [name, description, isActive];
  }
}

import 'package:eatery/data/models/eatery_db.dart';

part 'kds_station.g.dart';

@HiveType(typeId: TypeIndex.kdsStation)
class KdsStation extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  int sortOrder;
  @HiveField(4)
  bool isActive;

  KdsStation({
    required this.name,
    this.description,
    this.sortOrder = 0,
    this.isActive = true,
  });

  KdsStation.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        sortOrder = map['sortOrder'] ?? 0,
        isActive = map['isActive'] ?? true;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sortOrder': sortOrder,
      'isActive': isActive,
    };
  }
}

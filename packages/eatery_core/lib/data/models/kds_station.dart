class KdsStation {
  int? id;
  String name;
  String? description;
  int sortOrder;
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

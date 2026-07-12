import 'dart:convert';

abstract class BaseDto<T> {
  const BaseDto();

  int get schemaVersion;

  Map<String, dynamic> toJson();

  static int currentVersion = 1;

  String toJsonString() => jsonEncode(toJson());

  bool validate() => true;
}

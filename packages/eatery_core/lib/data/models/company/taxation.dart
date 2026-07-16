import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Taxation {
  @JsonValue(-1)
  none,
  @JsonValue(0)
  gst,
  @JsonValue(1)
  vat,
}

extension NatureOfTaxExtension on Taxation {
  int get id {
    switch (this) {
      case Taxation.none:
        return -1;
      case Taxation.gst:
        return 0;
      case Taxation.vat:
        return 1;
    }
  }

  String get name {
    switch (this) {
      case Taxation.none:
        return 'No Tax';
      case Taxation.gst:
        return 'GST';
      case Taxation.vat:
        return 'VAT';
    }
  }

  String get description {
    switch (this) {
      case Taxation.none:
        return 'Skip tax configuration — no GST or VAT';
      case Taxation.gst:
        return 'Goods and Service Tax';
      case Taxation.vat:
        return 'Value Added Tax';
    }
  }
}

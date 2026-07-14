import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum TaxType {
  @JsonValue(0)
  inclusive,
  @JsonValue(1)
  exclusive,
}

extension TaxTypeExtension on TaxType {
  int? get id {
    switch (this) {
      case TaxType.inclusive:
        return 0;
      case TaxType.exclusive:
        return 1;
    }
  }

  String? get name {
    switch (this) {
      case TaxType.inclusive:
        return "Inclusive";
      case TaxType.exclusive:
        return "Exclusive";
    }
  }

  String? get description {
    switch (this) {
      case TaxType.inclusive:
        return 'Tax Inclusive rates will always include tax in the total that you see in the unit price';
      case TaxType.exclusive:
        return 'Tax Exclusive rates will be excluding the tax that will be added at the point of purchase';
    }
  }
}

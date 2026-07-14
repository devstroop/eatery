import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/models/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
abstract class Subscription with _$Subscription {
  const factory Subscription({
    int? id,
    String? purchaseCode,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? validFrom,
    @JsonKey(fromJson: epochFromJsonNullable, toJson: epochToJsonNullable)
    DateTime? validTill,
    @Default(SubscriptionType.individual) SubscriptionType? subscriptionType,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  static Subscription fromMap(Map<String, dynamic> map) =>
      Subscription.fromJson(map);
}

extension SubscriptionX on Subscription {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['purchaseCode'],
      map['validFrom'],
      map['validTill'],
      map['subscriptionType'],
    ];
  }
}

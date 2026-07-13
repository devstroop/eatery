import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/database/eatery_db_shim.dart';
import 'package:eatery_core/data/database/native/store_config.dart';

class Subscription {
  int? id;
  String? purchaseCode;
  DateTime? validFrom;
  DateTime? validTill;
  SubscriptionType? subscriptionType = SubscriptionType.individual;

  Subscription(
      {
      this.purchaseCode,
      this.validFrom,
      this.validTill,
      required this.subscriptionType}): id = kUseSqliteSubscriptionStore ? null : EateryDB.instance.subscriptionBox?.nextId();

  Subscription.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        purchaseCode = map['purchaseCode'],
        validFrom =
            DateTime.fromMillisecondsSinceEpoch(map['validFrom'] as int? ?? 0),
        validTill =
            DateTime.fromMillisecondsSinceEpoch(map['validTill'] as int? ?? 0),
        subscriptionType = SubscriptionType.values
            .singleWhere((element) => element.id == map['subscriptionType']);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': purchaseCode,
      'validFrom': validFrom?.millisecondsSinceEpoch,
      'validTill': validTill?.millisecondsSinceEpoch,
      'subscriptionType': subscriptionType?.id
    };
  }

  static Subscription fromIterable(Iterable<dynamic> row) {
    return Subscription.fromMap({
      'id': row.elementAt(0),
      'purchaseCode': row.elementAt(1),
      'validFrom': row.elementAt(2),
      'validTill': row.elementAt(3),
      'subscriptionType': row.elementAt(4)
    });
  }

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['purchaseCode'],
      map['validFrom'],
      map['validTill'],
      map['subscriptionType']
    ];
  }
}

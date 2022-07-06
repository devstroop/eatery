import 'encryption.dart';

class License{
  static LicenseData validate(String? purchaseCode){
    try{
      if(purchaseCode == null){
        return LicenseData(purchaseCode, null, null, false, 'Demo');
      }
      String? raw = Encryption.decrypt(purchaseCode);
      if(raw != null){
        List<String> data = raw.split(';');
        int validFrom = int.parse(data[1]);
        int validTill = int.parse(data[2]);
        DateTime _validFrom = DateTime.fromMicrosecondsSinceEpoch(validFrom);
        DateTime _validTill = DateTime.fromMicrosecondsSinceEpoch(validTill);
        if (validFrom <= DateTime.now().microsecondsSinceEpoch && validTill >= DateTime.now().microsecondsSinceEpoch){
          return LicenseData(purchaseCode, _validFrom, _validTill, true, 'Success');
        }
        else{
          return LicenseData(purchaseCode, _validFrom, _validTill, false, 'Expired');
        }
      }
    }catch(_){ }
    return LicenseData(purchaseCode, null, null, false, 'Invalid purchase code');
  }
}
class LicenseData{
  final String? _purchaseCode;
  final DateTime? _validFrom;
  final DateTime? _validTill;
  final bool _status;
  final String _message;

  LicenseData(this._purchaseCode, this._validFrom, this._validTill, this._status, this._message);

  String? get purchaseCode => _purchaseCode;
  DateTime? get validFrom => _validFrom;
  DateTime? get validTill => _validTill;
  bool get status => _status;
  String get message => _message;
}
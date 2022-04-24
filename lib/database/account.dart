import 'package:json_store/json_store.dart';
import 'package:restaurant_pos/services/utility/generate.dart';
class Account{
  static JsonStore store = JsonStore();
  static String name = "account";
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    var q = (await getAll()).where((element) => element['email'].toLowerCase() == email.toLowerCase() && element['password'] == password);
    if (q.isNotEmpty) {
      return q.first;
    }
    return null;
  }
  static Future<String?> add(Map<String, dynamic> data) async {
    try{
      String id;
      while(true){
        id = getRandomString(8);
        if(await store.getItem('$name-$id') == null){
          data['id'] = id;
          break;
        }
      }
      await store.setItem('$name-$id', data);
      return id;
    }
    catch(_){}
    return null;
  }
  static Future<Map<String, dynamic>?> get(String id) async {
    try {
      return await store.getItem('$name-$id');
    }catch(_){}
    return null;
  }
  static Future<List<Map<String, dynamic>>> getAll() async {
    return await store.getListLike('$name-%') ?? [];
  }
  static Future<bool> update(Map<String, dynamic> data) async {
    try{
      await store.setItem('$name-${data['id']}', data);
      return true;
    }catch(_){}
    return false;
  }
  static Future<bool> delete(String id) async {
    try{
      await store.deleteItem('$name-$id');
      return true;
    }catch(_){}
    return false;
  }
  static Future<bool> clear() async {
    try {
      await store.deleteLike('$name-%');
      return true;
    }catch(_){}
    return false;
  }
}
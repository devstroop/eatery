import 'package:json_store/json_store.dart';
import 'package:restaurant_pos/services/utility/generate.dart';
class Product{
  static JsonStore store = JsonStore();
  static String name = "product-ref";

  static Future<String?> add(Map<String, dynamic> data) async {
    try{
      String id;
      if(data.containsKey('id')){
        id = data['id'];
      }else{
        while(true){
          id = getRandomString(8);
          if(await store.getItem('$name-$id') == null){
            data['id'] = id;
            break;
          }
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
  static Future<List<Map<String, dynamic>>> getAll({String? productAs, String? category, String? query}) async {
    List<Map<String, dynamic>> result = [];

    if(productAs != null && category == null) {
      result = (await store.getListLike('$name-%') ?? []).where((element) => element['as'] == productAs).toList();
    } else if (productAs != null && category != null) {
      result = (await store.getListLike('$name-%') ?? []).where((element) => element['as'] == productAs && element['category'] == category).toList();
    } else if (productAs == null && category != null) {
      result = (await store.getListLike('$name-%') ?? []).where((element) => element['category'] == category).toList();
    } else {
      result = await store.getListLike('$name-%') ?? [];
    }

    if(query != null){
      result = result.where((element) => element['name'].toLowerCase().trim().contains(query.toLowerCase().trim())).toList();
    }
    return result;
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
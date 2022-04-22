import 'package:json_store/json_store.dart';
import 'package:restaurant_pos/services/utility/generate.dart';

class Linker {
  static JsonStore jsonStore = JsonStore();

  static List<Map<String, dynamic>> cart = [];

  static Future<Map<String, dynamic>?> loginAccount(String email, String password) async {
    var q = (await getAccounts()).where((element) => element['email'].toLowerCase() == email.toLowerCase() && element['password'] == password);
    if (q.isNotEmpty) {
      return q.first;
    }
    return null;
  }

  static Future<bool> createAccount(Map<String, dynamic> accountData) async {
    String name = "account";
    try{
      await jsonStore.setItem('account-${getRandomString(8)}', accountData);
      return true;
    }
    catch(_){}
    return false;
  }

  static Future<List<Map<String, dynamic>>> getAccounts() async {
    return await jsonStore.getListLike('account-%') ?? [];
  }

  static List<Map<String, dynamic>> getCategories() {
    List<Map<String, dynamic>> result = [];
    result.add({
      'id': 1,
      'name': 'Snacks',
      'image':
          'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/344/external-burger-fast-food-vitaliy-gorbachev-flat-vitaly-gorbachev-1.png'
    });
    result.add({
      'id': 2,
      'name': 'Beverages',
      'image':
          'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/344/external-burger-fast-food-vitaliy-gorbachev-flat-vitaly-gorbachev-1.png'
    });
    result.add({
      'id': 3,
      'name': 'Starters',
      'image':
          'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/344/external-burger-fast-food-vitaliy-gorbachev-flat-vitaly-gorbachev-1.png'
    });
    return result;
  }

  static Map<String, dynamic>? getProduct({required int id}){
    var products = getProducts();
    var result =  products.where((element) => element['id'] == id).toList();
    if(result.isNotEmpty){
      return result.first;
    }
    return null;
  }

  static List<Map<String, dynamic>> getProducts({String? query, int? category, String? productType}) {
    List<Map<String, dynamic>> products = [
      {
        'id': 1,
        'category': 1,
        'name': 'Cheese Burger',
        'description': 'Cheese, lettuce, toma...',
        'mrp': 60.0,
        'salePrice': 40.0,
        'quantity': 10.5,
        'warningQuantity': 15,
        'image': 'C:\\Users\\Akash\\Pictures\\sample-data\\dishes\\burger1.jpg',
        'productType': 'kitchen',
        'foodType': 'veg',
      },
      {
        'id': 2,
        'category': 2,
        'name': 'Cheese Pizza',
        'description': 'Cheese, lettuce, toma...',
        'mrp': 60.0,
        'salePrice': 55.0,
        'quantity': 10.5,
        'warningQuantity': 15,
        'image': 'C:\\Users\\Akash\\Pictures\\sample-data\\dishes\\burger1.jpg',
        'productType': 'inventory',
        'foodType': 'nonveg',
      }
    ];

    return products.where((product) {
      return product['name'].toLowerCase().contains(query != null ? query.toLowerCase() : "") && category != null ? product['category'] == category : true;
    }).toList();
  }

  static String getCurrencySymbol() {
    return '₹';
  }

  static double getBatteryWarningLevel() {
    return 20;
  }

  static Map<String, dynamic> getTodaySales() {
    return {'active': 5, 'total': 10, 'due': 499.50, 'paid': 1290.40};
  }

  static double calculateCartSubtotal() {
    double subtotal = 0;
    for (var each in cart) {
      var product = getProduct(id: each['id']);
      if(product!=null){
        double mrp = product['mrp'] ?? 0;
        double salePrice = product['salePrice'] ?? 0;
        subtotal += salePrice;
      }
    }
    return subtotal;
  }



















}

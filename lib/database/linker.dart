class Linker{
  static Map<String, dynamic>? loginAccount(String email, String password){
    var q = getAccounts().where((element) => element['email'] == email && element['password'] == password);
    if(q.isNotEmpty){
      return q.first;
    }
    return null;
  }
  static Map<String, dynamic>? createAccount(Map<String, dynamic> accountData){
    var q1 = getAccounts();
    var q2 = q1.where((element) => element['email'] == accountData['email']);
    if(q2.isEmpty){
      int id = q1.length;
      while(q1.where((element) => element['id'] == id).isNotEmpty){
        id++;
      }
      accountData['id'] = id;
      print(accountData);
      return accountData;
    }
    return null;
  }
  static List<Map<String, dynamic>> getAccounts(){
    List<Map<String, dynamic>> result = [];
    result.add({
      'id': 1,
      'name': 'Hotel Hayat',
      'image': '',
      'email': 'aksbju@gmail.com',
      'phone': '+917488797047',
      'address': '',
      'password': '12345678',
      'fssai': '',
      'gstin': '',
      'currency': '₹',
      'purchaseCode': '',
      'validFrom': '',
      'validTill': '',
    });
    return result;
  }

  static List<Map<String, dynamic>> getCategories(){
    List<Map<String, dynamic>> result = [];
    result.add({'id': 1, 'name': 'Snacks', 'image': 'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/344/external-burger-fast-food-vitaliy-gorbachev-flat-vitaly-gorbachev-1.png'});
    result.add({'id': 2, 'name': 'Beverages', 'image': 'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/344/external-burger-fast-food-vitaliy-gorbachev-flat-vitaly-gorbachev-1.png'});
    result.add({'id': 3, 'name': 'Starters', 'image': 'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/344/external-burger-fast-food-vitaliy-gorbachev-flat-vitaly-gorbachev-1.png'});
    return result;
  }
  static List<Map<String, dynamic>> getProducts({String? query, int? categoryId}){
    List<Map<String, dynamic>> result = [];
    result.add({
      'id': 1,
      'name': 'Cheese Burst Burger',
      'description': 'Cheese, lettuce, toma...',
      'mrp': 50.0,
      'salePrice': 40.0,
      'quantity': 10.5,
      'warningQuantity': 15,
      'image': 'C:\\Users\\Akash\\Pictures\\sample-data\\dishes\\burger1.jpg',
      'foodType': 'veg',
    });

    return result;
  }
  static String getCurrencySymbol(){
    return '₹';
  }
  static double getBatteryWarningLevel(){
    return 20;
  }
  static List<Map<String, dynamic>> cart = [];
  static Map<String, dynamic> getTodaySales(){
    return {'active': 5, 'total':10, 'due': 499.50, 'paid': 1290.40};
  }

}
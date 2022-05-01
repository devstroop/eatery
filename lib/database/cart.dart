class Cart{
  static Map<String, Map<String, dynamic>> cart = {};

  static Map<String, Map<String, dynamic>> sample = {
    'id': {
      'name': '',
      'description': '',
      'billingPrice': 0.0,
      'mrp': 0.0,
      'salePrice': 0.0,
      'image': '',
      'discount': '',
      'tax': '',
      'quantity': 0.0,
      'unit':'',
      'customizations': [
        {
          'id': '',
          'name': '',
          'description': '',
          'price': 0.0
        }
      ]
    },

  };
}


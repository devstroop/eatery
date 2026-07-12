/// Seed data for development and demo purposes.
/// Loaded from JSON fixtures during development only.
class SeedData {
  final List<Map<String, dynamic>> productCategories;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> customers;
  final List<Map<String, dynamic>> diningTableCategories;
  final List<Map<String, dynamic>> diningTables;
  final List<Map<String, dynamic>> staffs;
  final List<Map<String, dynamic>> taxSlabs;

  const SeedData({
    required this.productCategories,
    required this.products,
    required this.customers,
    required this.diningTableCategories,
    required this.diningTables,
    required this.staffs,
    required this.taxSlabs,
  });

  static const _productCategories = [
    {
      "id": 1,
      "name": "Breakfast",
      "description": "Start your day with a hearty breakfast.",
      "image": "https://cdn-icons-png.flaticon.com/128/8978/8978070.png",
    },
    {
      "id": 2,
      "name": "Lunch",
      "description": "Delicious lunch options for every palate.",
      "image": "https://cdn-icons-png.flaticon.com/128/5525/5525167.png",
    },
    {
      "id": 3,
      "name": "Beverages",
      "description": "Quench your thirst with refreshing drinks.",
      "image": "https://cdn-icons-png.flaticon.com/128/175/175782.png",
    },
    {
      "id": 4,
      "name": "Snacks",
      "description": "Quick bites to keep you satisfied between meals.",
      "image": "https://cdn-icons-png.flaticon.com/128/2450/2450351.png",
    },
    {
      "id": 5,
      "name": "Desserts",
      "description": "Indulge in delightful sweet treats.",
      "image": "https://cdn-icons-png.flaticon.com/128/2871/2871916.png",
    },
  ];

  static const _products = [
    {
      "id": 1,
      "name": "Masala Dosa",
      "categoryId": 2,
      "description": "Spicy and delicious masala dosa.",
      "image":
          "https://sherebengal.com/wp-content/uploads/2017/09/Paneer-butter-masala-dosa.jpg",
      "mrpPrice": 6.99,
      "salePrice": 5.99,
      "taxSlabId": 3,
      "foodType": 0,
      "type": 0,
      "isActive": true,
    },
    {
      "id": 2,
      "name": "Coke",
      "categoryId": 3,
      "description": "Refreshing cola drink.",
      "image": "https://example.com/coke.jpg",
      "mrpPrice": 1.99,
      "salePrice": 1.49,
      "taxSlabId": 4,
      "foodType": null,
      "type": 1,
      "isActive": true,
    },
    {
      "id": 3,
      "name": "Paneer Masala Dosa",
      "categoryId": 2,
      "description": "Delicious paneer masala dosa.",
      "image":
          "https://sherebengal.com/wp-content/uploads/2017/09/Paneer-butter-masala-dosa.jpg",
      "mrpPrice": 8.99,
      "salePrice": 7.99,
      "taxSlabId": 3,
      "foodType": 0,
      "type": 0,
      "isActive": true,
    },
    {
      "id": 4,
      "name": "Idli Sambar",
      "categoryId": 1,
      "description": "Soft idlis served with sambar.",
      "image": "https://example.com/idli.jpg",
      "mrpPrice": 4.99,
      "salePrice": 3.99,
      "taxSlabId": 3,
      "foodType": 0,
      "type": 0,
      "isActive": true,
    },
    {
      "id": 5,
      "name": "French Fries",
      "categoryId": 4,
      "description": "Crispy golden french fries.",
      "image": "https://example.com/fries.jpg",
      "mrpPrice": 3.99,
      "taxSlabId": 1,
      "foodType": null,
      "type": 0,
      "isActive": true,
    },
    {
      "id": 6,
      "name": "Chocolate Cake",
      "categoryId": 5,
      "description": "Rich and moist chocolate cake.",
      "image": "https://example.com/cake.jpg",
      "mrpPrice": 5.99,
      "taxSlabId": 1,
      "foodType": null,
      "type": 0,
      "isActive": true,
    },
  ];

  static const _customers = [
    {
      "id": 1,
      "name": "John Doe",
      "phone": "+1234567890",
      "address": "123 Main St",
      "landmark": "Near Park",
      "isActive": true,
    },
    {
      "id": 2,
      "name": "Jane Smith",
      "phone": "+9876543210",
      "address": "456 Oak Ave",
      "landmark": "Near Library",
      "isActive": true,
    },
  ];

  static const _diningTableCategories = [
    {"id": 1, "name": "Indoor", "description": "Inside seating"},
    {"id": 2, "name": "Outdoor", "description": "Patio seating"},
  ];

  static const _diningTables = [
    {"id": 1, "name": "Table 1", "categoryId": 1, "capacity": 4, "status": 0},
    {"id": 2, "name": "Table 2", "categoryId": 1, "capacity": 2, "status": 0},
    {"id": 3, "name": "Table 3", "categoryId": 2, "capacity": 6, "status": 0},
    {"id": 4, "name": "Table 4", "categoryId": 2, "capacity": 4, "status": 0},
  ];

  static const _staffs = [
    {
      "id": 1,
      "name": "Alice",
      "phone": "+1111111111",
      "type": 0,
      "isActive": true,
    },
    {
      "id": 2,
      "name": "Bob",
      "phone": "+2222222222",
      "type": 0,
      "isActive": true,
    },
  ];

  static const _taxSlabs = [
    {"id": 1, "name": "GST 0%", "rate": 0.0, "type": 0},
    {"id": 2, "name": "GST 5%", "rate": 5.0, "type": 0},
    {"id": 3, "name": "GST 12%", "rate": 12.0, "type": 0},
    {"id": 4, "name": "GST 18%", "rate": 18.0, "type": 0},
  ];

  static const SeedData defaultData = SeedData(
    productCategories: _productCategories,
    products: _products,
    customers: _customers,
    diningTableCategories: _diningTableCategories,
    diningTables: _diningTables,
    staffs: _staffs,
    taxSlabs: _taxSlabs,
  );
}

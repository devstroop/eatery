import 'package:path/path.dart';
import 'package:restaurant_pos/models/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class RestaurantDatabase {
  static final RestaurantDatabase instance = RestaurantDatabase._init();
  static Database? _database;

  RestaurantDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('restaurant.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';

    await db.execute('''
CREATE TABLE $tableRestaurant ( 
  ${RestaurantFields.id} $idType,
  ${RestaurantFields.name} $textType,
  ${RestaurantFields.address} $textTypeNullable,
  ${RestaurantFields.city} $textTypeNullable,
  ${RestaurantFields.state} $textTypeNullable,
  ${RestaurantFields.pinCode} $textTypeNullable,
  ${RestaurantFields.phoneNumber} $textTypeNullable,
  ${RestaurantFields.emailAddress} $textTypeNullable,
  ${RestaurantFields.gstin} $textTypeNullable,
  ${RestaurantFields.fssai} $textTypeNullable,
  ${RestaurantFields.password} $textType,
  ${RestaurantFields.currency} $textType,
  ${RestaurantFields.logo} $textTypeNullable,
  ${RestaurantFields.purchaseCode} $textTypeNullable,
  ${RestaurantFields.validFrom} $textTypeNullable,
  ${RestaurantFields.validTill} $textTypeNullable
  )
''');
  }

  Future<Restaurant> create(Restaurant restaurant) async {
    final db = await instance.database;
    final id = await db.insert(tableRestaurant, restaurant.toJson());
    return restaurant.copy(id: id);
  }

  Future<Restaurant?> read(int id) async {
    final db = await instance.database;
    final maps = await db
        .query(tableRestaurant, columns: RestaurantFields.values, where: '${RestaurantFields.id} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Restaurant.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Restaurant>> readAll() async {
    final db = await instance.database;
    final maps = await db.query(
      tableRestaurant,
      orderBy: '${RestaurantFields.id} ASC',
    );
    return maps.map((json) => Restaurant.fromJson(json)).toList();
  }

  Future<int> update(Restaurant restaurant) async {
    final db = await instance.database;
    return db.update(
      tableRestaurant,
      restaurant.toJson(),
      where: '${RestaurantFields.id} = ?',
      whereArgs: [restaurant.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableRestaurant,
      where: '${RestaurantFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

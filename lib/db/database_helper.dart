import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'items.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE items (id INTEGER PRIMARY KEY AUTOINCREMENT,sid Text, title TEXT)",
        );
      },
    );
  }

  Future<List<ItemModel>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');

    final list = List.generate(maps.length, (i) {
      return ItemModel.fromMap(maps[i], maps[i]["id"].toString());
    });

    return list;
  }

  Future<int> insertItem(ItemModel item) async {
    final db = await database;
    return await db.insert('items', item.toMap());
  }

  Future<int> updateItem(ItemModel item) async {
    final db = await database;
    return await db
        .update('items', item.toMap(), where: "id = ?", whereArgs: [item.id]);
  }

  Future<int> deleteAllItem() async {
    final db = await database;
    return await db.delete('items');
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('items', where: "id = ?", whereArgs: [id]);
  }
}

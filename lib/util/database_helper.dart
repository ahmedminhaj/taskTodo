import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todolist/model/todo_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String tableName = "todoTable";
  final String columnID = "id";
  final String columnItem = "itemName";
  final String columnDate = "dateCreated";
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  DatabaseHelper.internal();

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "todo_db.db");

    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDB;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableName($columnID INTEGER PRIMARY KEY, $columnItem TEXT, $columnDate TEXT)");
  }

  Future<int> saveItem(ToDoItem toDoItem) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", toDoItem.toMap());
    return res;
  }

  Future<List> getAllItem() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY $columnItem ASC");
    return result.toList();
  }

  Future<ToDoItem> getItem(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return new ToDoItem.fromMap(result.first);
  }

  Future<String> deleteItem(int id) async {
    var dbClient = await db;
    await dbClient.delete(tableName, where: "$columnID = ?", whereArgs: [id]);
    return "succesfully";
  }

  Future<int> updateItem(ToDoItem toDoItem) async {
    var dbClient = await db;
    return await dbClient.update(tableName, toDoItem.toMap(),
        where: "$columnID = ?", whereArgs: [toDoItem.id]);
  }

  Future close() async {
    var dbClient = await db;
    return await dbClient.close();
  }
}

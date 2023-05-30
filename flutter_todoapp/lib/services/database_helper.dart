import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/todomodel.dart';
class DatabaseHelper {

static const int _version = 1;
static const String _dnName = 'Todo.db';

static Future<Database> _getDB() async {
return openDatabase(join(await getDatabasesPath(), _dnName),
onCreate:(db, version) async => await db.execute(
  "CREATE TABLE Todo( id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL, etat INTEGER NOT NULL,  date TEXT NOT NULL  );"), version: _version

  );
}

 static Future<int> addTodo(Todo todo) async {

  final db = await _getDB();
  return await db.insert("Todo", todo.toJson(), conflictAlgorithm: ConflictAlgorithm.replace );
 }

 static Future<int> update(Todo todo) async {
 final db = await _getDB();
  return await db.update("Todo", todo.toJson(), where:'id = ?', whereArgs: [todo.id], conflictAlgorithm: ConflictAlgorithm.replace);
 }

 static Future<int> delete(Todo todo) async {
 final db = await _getDB();
  return await db.delete("Todo", where:'id = ?', whereArgs: [todo.id],);
 }

 static Future<List<Todo>?> alltodo() async {
 final db = await _getDB();
 final List<Map<String, dynamic>> maps = await db.query("Todo");

if(maps.isEmpty){

  return null;
}
return List.generate(maps.length, (index) => Todo.fromJson(maps[index]));

   }



}
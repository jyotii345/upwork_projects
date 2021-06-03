import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class IronDiverDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "ironDiverDatabase.db";

  static final _databaseVersion = 1;

  IronDiverDatabaseHelper._privateConstructor();

  static final IronDiverDatabaseHelper instance =
      IronDiverDatabaseHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    //get the database object
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    // initialize the database
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    //create a new table object in the database
    return db.execute(
      "CREATE TABLE irondiver(id INTEGER PRIMARY KEY,idval TEXT,name TEXT,)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertIronDiver(String idVal, String name) async {
    //add a iron diver to the database
    final Database db = await database;

    int id = await db.insert(
      'irondiver',
      {'idval': idVal, 'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteIronDiver(int id) async {
    // delete a iron diver in the database
    final db = await database;

    await db.delete(
      'irondiver',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteIronDiverTable() async {
    //delete the entire iron diver table in the database
    final db = await database;
    await db.delete('irondiver');
  }

  Future<bool> ironDiverExists(String idVal) async {
    //check if a iron diver exists in the database by the iron diver path and name
    final db = await database;
    var result = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM irondiver WHERE idval = ?)', [idVal]);
    int exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<List<dynamic>> queryIronDiver() async {
    // Get a iron diver from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('irondiver');

    return List.generate(maps.length, (i) {
      return [
        maps[i]['idval'],
        maps[i]['name'],
      ];
    });
  }
}

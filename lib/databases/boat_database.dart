import 'dart:async';
import 'dart:io';
import 'package:aggressor_adventures/classes/boat.dart';
import 'package:aggressor_adventures/classes/file_data.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BoatDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "boatDatabase.db";

  static final _databaseVersion = 1;

  BoatDatabaseHelper._privateConstructor();

  static final BoatDatabaseHelper instance =
  BoatDatabaseHelper._privateConstructor();
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
      "CREATE TABLE boat(id INTEGER PRIMARY KEY,boatId TEXT,name TEXT,abbreviation TEXT, email TEXT,active TEXT,imageLink TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertBoat(Boat boat) async {
    //add a photo to the database
    final Database db = await database;

    int id = await db.insert(
      'boat',
      boat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteBoat(String id) async {
    // delete a file in the database
    final db = await database;

    await db.delete(
      'boat',
      where: "boatId = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteBoatTable() async {
    final db = await database;
    await db.delete('boat');
  }

  Future<bool> boatExists(String boatId) async {
    final db = await database;
    var result = await db
        .rawQuery('SELECT EXISTS(SELECT 1 FROM boat WHERE boatId = ?)', [boatId]);
    int exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<Boat> getBoat(String boatId) async {
    final db = await database;
    var result = await db
        .rawQuery('SELECT * FROM boat WHERE boatId = ?', [boatId]);
    return Boat(
      result[0]['boatId'],
      result[0]['name'],
      result[0]['abbreviation'],
      result[0]['email'],
      result[0]['active'],
      result[0]['imageLink'],
    );
  }

  Future<List<Boat>> queryBoat() async {
    // Get a file from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('boat');


    return List.generate(maps.length, (i) {
      return Boat(
        maps[i]['boatId'],
        maps[i]['name'],
        maps[i]['abbreviation'],
        maps[i]['email'],
        maps[i]['active'],
        maps[i]['imageLink'],
      );
    });
  }
}

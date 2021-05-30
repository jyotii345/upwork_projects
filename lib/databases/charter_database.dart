import 'dart:async';
import 'dart:io';
import 'package:aggressor_adventures/classes/charter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CharterDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "charterDatabase.db";

  static final _databaseVersion = 1;

  CharterDatabaseHelper._privateConstructor();

  static final CharterDatabaseHelper instance = CharterDatabaseHelper._privateConstructor();
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
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    //create a new table object in the database
    return db.execute(
      "CREATE TABLE charter(charterId TEXT,startDate TEXT,statusId TEXT,boatId TEXT,nights TEXT,itinerary TEXT,embarkment TEXT, disembarkment TEXT, destination TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertCharter(Charter charter) async {
    //add a charter to the database
    final Database db = await database;

    int id = await db.insert(
      'charter',
      charter.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteCharter(String id) async {
    // delete a charter in the database
    final db = await database;

    await db.delete(
      'charter',
      where: "charterId = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteCharterTable() async {
    //delete the entire charter table in the database
    final db = await database;
    await db.delete('charter');
  }

  Future<bool> charterExists(String charterId) async {
    //check if a charter exists based on its charter id
    final db = await database;
    var result = await db.rawQuery('SELECT EXISTS(SELECT 1 FROM charter WHERE charterId = ?)', [charterId]);
    int exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<Charter> getCharter(String charterId) async {
    //get a charter from the database based on its charterId
    final db = await database;
    var result = await db
        .rawQuery('SELECT * FROM charter WHERE charterId = ?', [charterId]);
    return Charter(
      result[0]['charterId'],
      result[0]['startDate'],
      result[0]['statusId'],
      result[0]['boatId'],
      result[0]['nights'],
      result[0]['itinerary'],
      result[0]['embarkment'],
      result[0]['disembarkment'],
      result[0]['destination'],
    );
  }

  Future<List<Charter>> queryCharter() async {
    // Get the entire charter table from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('charter');

    return List.generate(maps.length, (i) {
      return Charter(
        maps[i]['charterId'],
        maps[i]['startDate'],
        maps[i]['statusId'],
        maps[i]['boatId'],
        maps[i]['nights'],
        maps[i]['itinerary'],
        maps[i]['embarkment'],
        maps[i]['disembarkment'],
        maps[i]['destination'],
      );
    });
  }
}

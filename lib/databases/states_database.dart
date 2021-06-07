import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class StatesDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "statesDatabase.db";

  static final _databaseVersion = 1;

  StatesDatabaseHelper._privateConstructor();

  static final StatesDatabaseHelper instance =
  StatesDatabaseHelper._privateConstructor();
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
      "CREATE TABLE states(state TEXT,stateAbbr TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertStates(Map<String, dynamic> state) async {
    //add a states to the database
    final Database db = await database;

    int id = await db.insert(
      'states',
      state,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteStates(String state) async {
    // delete a states in the database
    final db = await database;

    await db.delete(
      'states',
      where: "state = ?",
      whereArgs: [state],
    );
  }

  Future<void> deleteStatesTable() async {
    //delete the entire states table in the database
    final db = await database;
    await db.delete('states');
  }

  Future<bool> statesExists(String state) async {
    //check if a states exists in the database by the states path and name
    final db = await database;
    var result = await db
        .rawQuery('SELECT EXISTS(SELECT 1 FROM states WHERE state = ?)', [state]);
    int exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<List<Map<String, dynamic>>> queryStates() async {
    // Get a states from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('states');


    return List.generate(maps.length, (i) {
      return {'state':maps[i]["state"], 'stateAbbr' : maps[i]["stateAbbr"]};
    });
  }
}

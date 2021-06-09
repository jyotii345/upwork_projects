import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "offlineDatabase.db";

  static final _databaseVersion = 1;

  OfflineDatabaseHelper._privateConstructor();

  static final OfflineDatabaseHelper instance =
  OfflineDatabaseHelper._privateConstructor();
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
      "CREATE TABLE offline(id TEXT,type TEXT,action TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertOffline(Map<String, dynamic> offlineValue) async {
    //add a Offline to the database
    final Database db = await database;

    int id = await db.insert(
      'offline',
      offlineValue,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteOffline(String id) async {
    // delete a Offline in the database
    final db = await database;

    await db.delete(
      'offline',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteOfflineTable() async {
    //delete the entire Offline table in the database
    final db = await database;
    await db.delete('offline');
  }

  Future<bool> offlineExists(String id) async {
    //check if a Offline exists in the database by the Offline path and name
    final db = await database;
    var result = await db
        .rawQuery('SELECT EXISTS(SELECT 1 FROM offline WHERE id = ?)', [id]);
    int exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<List<Map<String,dynamic>>> queryOffline() async {
    // Get a Offline from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('offline');

    return List.generate(maps.length, (i) {
      return {'id' : maps[i]['id'], 'type':maps[i]['type'], 'action' : maps[i]['action']};
    });
  }
}

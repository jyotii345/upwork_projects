import 'dart:async';
import 'dart:io';
import 'package:aggressor_adventures/classes/note.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SlidersDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "slidersDatabase.db";

  static final _databaseVersion = 1;

  SlidersDatabaseHelper._privateConstructor();

  static final SlidersDatabaseHelper instance =
  SlidersDatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    //get the database object
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
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
      "CREATE TABLE sliders(id TEXT,fileName TEXT,filePath TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertSliders(Map<String, dynamic> slider) async {
    //add a sliders to the database
    final Database db = await database;

    int id = await db.insert(
      'sliders',
      slider,
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteSliders(String fileName) async {
    // delete a sliders in the database
    final db = await database;

    await db.delete(
      'sliders',
      where: "fileName = ?",
      whereArgs: [fileName],
    );
  }

  Future<void> deleteSlidersTable() async {
    //delete the entire sliders table in the database
    final db = await database;
    await db.delete('sliders');
  }

  Future<bool> slidersExists(String fileName) async {
    //check if a sliders exists based on its sliders id
    final db = await database;
    var result = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM sliders WHERE fileName = ?)', [fileName]);
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<Note> getSliders(String fileName) async {
    //get a sliders from the database based on its slidersId
    final db = await database;
    var result =
    await db.rawQuery('SELECT * FROM sliders WHERE fileName = ?', [fileName]);
    return Note(
      result[0]['id'].toString(),
      result[0]['boatId'].toString(),
      result[0]['destination'].toString(),
      result[0]['startDate'].toString(),
      result[0]['endDate'].toString(),
      result[0]['preTripSliders'].toString(),
      result[0]['postTripSliders'].toString(),
      result[0]['miscSliders'].toString(),
      null,
      null,
      null,
    );
  }

  Future<List<Map<String,dynamic>>> querySliders() async {
    // Get the entire sliders table from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('sliders');

    return List.generate(maps.length, (i) {
      return {'fileName' : maps[i]['fileName'], 'filePath' : maps[i]['filePath']};
    });
  }
//TODO note there must be a callback, context, and user set on pull from database
}

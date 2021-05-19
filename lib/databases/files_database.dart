import 'dart:async';
import 'dart:io';
import 'package:aggressor_adventures/classes/file_data.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FileDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "fileDatabase.db";

  static final _databaseVersion = 1;

  FileDatabaseHelper._privateConstructor();

  static final FileDatabaseHelper instance =
  FileDatabaseHelper._privateConstructor();
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
      "CREATE TABLE file(id INTEGER PRIMARY KEY,filePath TEXT,date TEXT,fileName TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertFile(FileData file) async {
    //add a photo to the database
    final Database db = await database;

    int id = await db.insert(
      'file',
      file.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteFile(int id) async {
    // delete a file in the database
    final db = await database;

    await db.delete(
      'file',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteFileTable() async {
    final db = await database;
    await db.delete('file');
  }

  Future<bool> fileExists(String file) async {
    final db = await database;
    var result = await db
        .rawQuery('SELECT EXISTS(SELECT 1 FROM file WHERE fileName = ?)', [file]);
    int exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<List<FileData>> queryFile() async {
    // Get a file from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('file');


    return List.generate(maps.length, (i) {
      return FileData(
        maps[i]['filePath'],
        maps[i]['date'],
        maps[i]['fileName'],
      );
    });
  }
}

import 'dart:async';
import 'dart:io';
import 'package:aggressor_adventures/classes/photo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class PhotoDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "photoDatabase.db";

  static final _databaseVersion = 1;

  PhotoDatabaseHelper._privateConstructor();

  static final PhotoDatabaseHelper instance =
  PhotoDatabaseHelper._privateConstructor();
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
      "CREATE TABLE photo(id INTEGER PRIMARY KEY,imageName TEXT,userId TEXT,byteString TEXT,date TEXT,charterId TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertPhoto(Photo photo) async {
    //add a photo to the database
    final Database db = await database;

    int id = await db.insert(
      'photo',
      photo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deletePhoto(int id) async {
    // delete a photo in the database
    final db = await database;

    await db.delete(
      'photo',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deletePhotoTable() async {
    final db = await database;
    await db.delete('photo');
  }

  Future<bool> photoExists(String image, String charterId) async {
    final db = await database;
    var result = await db
        .rawQuery('SELECT EXISTS(SELECT 1 FROM photo WHERE imageName = ? AND charterId = ?)', [image, charterId]);
    int exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<List<Photo>> queryPhoto() async {
    // Get a photo from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('photo');


    return List.generate(maps.length, (i) {
      return Photo(
        maps[i]['imageName'],
        maps[i]['userId'],
        maps[i]['byteString'],
        maps[i]['date'],
        maps[i]['charterId'],
      );
    });
  }
}

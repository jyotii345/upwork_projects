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
      "CREATE TABLE photo(id INTEGER PRIMARY KEY,imageName TEXT,userId TEXT,imagePath TEXT,date TEXT,boatId TEXT,key TEXT)",
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

  Future<void> deletePhoto(String imagePath) async {
    // delete a photo in the database
    final db = await database;

    await db.delete(
      'photo',
      where: "imagePath = ?",
      whereArgs: [imagePath],
    );
  }

  Future<void> deletePhotoTable() async {
    //delete the entire photo table of the database
    final db = await database;
    await db.delete('photo');
  }

  Future<bool> photoExists(String image, String boatId) async {
    //check if a photo exists in the database by the image extension and the boat id
    final db = await database;
    var result = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM photo WHERE imageName = ? AND boatId = ?)',
        [image, boatId]);
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<bool> keyExists(String key) async {
    //check if a photo exists by the aws download key
    final db = await database;
    var result = await db
        .rawQuery('SELECT EXISTS(SELECT 1 FROM photo WHERE key = ?)', [key]);
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<Photo> getPhoto(String filePath) async {
    final db = await database;
    var result = await db
        .rawQuery('SELECT * FROM photo WHERE imagePath = ?', [filePath]);
    return
        // Photo(imageName: imageName, userId: userId, imagePath: imagePath, date: date, boatId: boatId, key: key)

        Photo(
      imageName: result[0]['imageName'].toString(),
      userId: result[0]['userId'].toString(),
      imagePath: result[0]['imagePath'].toString(),
      date: result[0]['date'].toString(),
      boatId: result[0]['boatId'].toString(),
      key: result[0]['key'].toString(),
    );
  }

  Future<List<Photo>> queryPhoto() async {
    // Get a photo from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('photo');

    return List.generate(maps.length, (i) {
      return
        Photo(
          imageName: maps[i]['imageName'].toString(),
          userId: maps[i]['userId'].toString(),
          imagePath: maps[i]['imagePath'].toString(),
          date: maps[i]['date'].toString(),
          boatId: maps[i]['boatId'].toString(),
          key: maps[i]['key'].toString(),
        );
        // Photo(
        //   maps[i]['imageName'],
        //   maps[i]['userId'],
        //   maps[i]['imagePath'],
        //   maps[i]['date'],
        //   maps[i]['boatId'],
        //   maps[i]['key']);
    });
  }
}

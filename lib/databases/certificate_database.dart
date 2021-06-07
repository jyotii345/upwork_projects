import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CertificateDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "certificateDatabase.db";

  static final _databaseVersion = 1;

  CertificateDatabaseHelper._privateConstructor();

  static final CertificateDatabaseHelper instance =
  CertificateDatabaseHelper._privateConstructor();
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
      "CREATE TABLE certificate(id INTEGER PRIMARY KEY,idval TEXT,name TEXT,)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertCertificate(String idVal, String name) async {
    //add a iron diver to the database
    final Database db = await database;

    int id = await db.insert(
      'certificate',
      {'idval': idVal, 'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteCertificate(int id) async {
    // delete a iron diver in the database
    final db = await database;

    await db.delete(
      'certificate',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteCertificateTable() async {
    //delete the entire iron diver table in the database
    final db = await database;
    await db.delete('certificate');
  }

  Future<bool> certificateExists(String idVal) async {
    //check if a iron diver exists in the database by the iron diver path and name
    final db = await database;
    var result = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM certificate WHERE idval = ?)', [idVal]);
    int exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<List<dynamic>> queryCertificate() async {
    // Get a iron diver from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('certificate');

    return List.generate(maps.length, (i) {
      return [
        maps[i]['idval'],
        maps[i]['name'],
      ];
    });
  }
}

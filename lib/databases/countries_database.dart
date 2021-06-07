import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CountriesDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "countriesDatabase.db";

  static final _databaseVersion = 1;

  CountriesDatabaseHelper._privateConstructor();

  static final CountriesDatabaseHelper instance =
  CountriesDatabaseHelper._privateConstructor();
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
      "CREATE TABLE countries(country TEXT,countryId TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertCountries(Map<String, dynamic> country) async {
    //add a countries to the database
    final Database db = await database;

    int id = await db.insert(
      'countries',
      country,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteCountries(String country) async {
    // delete a countries in the database
    final db = await database;

    await db.delete(
      'countries',
      where: "country = ?",
      whereArgs: [country],
    );
  }

  Future<void> deleteCountriesTable() async {
    //delete the entire countries table in the database
    final db = await database;
    await db.delete('countries');
  }

  Future<bool> countriesExists(String country) async {
    //check if a countries exists in the database by the countries path and name
    final db = await database;
    var result = await db
        .rawQuery('SELECT EXISTS(SELECT 1 FROM countries WHERE country = ?)', [country]);
    int exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<List<Map<String,dynamic>>> queryCountries() async {
    // Get a countries from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('countries');


    return List.generate(maps.length, (i) {
      return {'country' : maps[i]['country'], 'countryId':maps[i]['countryId']};
    });
  }
}

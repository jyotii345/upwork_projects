import 'dart:async';
import 'dart:io';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TripDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "tripDatabase.db";

  static final _databaseVersion = 1;

  TripDatabaseHelper._privateConstructor();

  static final TripDatabaseHelper instance =
      TripDatabaseHelper._privateConstructor();
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
      "CREATE TABLE trip(id INTEGER PRIMARY KEY,tripDate TEXT,title TEXT,latitude TEXT,longitude TEXT,destination TEXT,reservationDate TEXT,reservationId TEXT, charterId TEXT,total TEXT,discount TEXT,payments TEXT,due TEXT, dueDate TEXT,passengers TEXT,location TEXT,embark TEXT,disembark TEXT,detailDestination TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertTrip(Trip trip) async {
    //add a trip to the database
    final Database db = await database;

    int id = await db.insert(
      'trip',
      trip.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteTrip(int id) async {
    // delete a trip in the database
    final db = await database;

    await db.delete(
      'trip',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteTripTable() async {
    final db = await database;
    await db.delete('trip');
  }

  Future<bool> tripExists(String id) async {
    final db = await database;
    var result = await db
        .rawQuery('SELECT EXISTS(SELECT 1 FROM trip WHERE id = ?)', [id]);
    int exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<Trip> getTrip(String reservationId) async {
    final db = await database;
    var result = await db
        .rawQuery('SELECT * FROM trip WHERE reservationId = ?', [reservationId]);
    return Trip.TripWithDetails(
      result[0]['tripDate'],
      result[0]['title'],
      result[0]['latitude'],
      result[0]['longitude'],
      result[0]['destination'],
      result[0]['reservationDate'],
      result[0]['reservationId'],
      result[0]['charterId'],
      result[0]['total'],
      result[0]['discount'],
      result[0]['payments'],
      result[0]['due'],
      result[0]['dueDate'],
      result[0]['passengers'],
      result[0]['location'],
      result[0]['embark'],
      result[0]['disembark'],
      result[0]['detailDestination'],
    );

  }

  Future<List<Trip>> queryTrip() async {
    // Get a trip from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('trip');

    return List.generate(maps.length, (i) {
      return Trip.TripWithDetails(
        maps[i]['tripDate'],
        maps[i]['title'],
        maps[i]['latitude'],
        maps[i]['longitude'],
        maps[i]['destination'],
        maps[i]['reservationDate'],
        maps[i]['reservationId'],
        maps[i]['charterId'],
        maps[i]['total'],
        maps[i]['discount'],
        maps[i]['payments'],
        maps[i]['due'],
        maps[i]['dueDate'],
        maps[i]['passengers'],
        maps[i]['location'],
        maps[i]['embark'],
        maps[i]['disembark'],
        maps[i]['detailDestination'],
      );
    });
  }
}
